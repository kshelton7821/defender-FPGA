LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_etc.all;

entity proj0 is
	port( clkin		: in STD_LOGIC;
			h_sync_m	: OUT STD_LOGIC;
			v_sync_m	: OUT STD_LOGIC;
			
			GSENSOR_CS_N : OUT	STD_LOGIC;
			GSENSOR_SCLK : OUT	STD_LOGIC;
			GSENSOR_SDI  : INOUT	STD_LOGIC;
			GSENSOR_SDO  : INOUT	STD_LOGIC;
			
			fire	: in std_logic;
			pause : in std_logic;
			
			
			red_m		:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
			green_m	:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
			blue_m	:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0')
	);
end entity proj0;

architecture proj0_arch of proj0 is
	signal player						: game_entity := ("000", 0, 100, 50, 50, 14600, '1', '0', 100);
	signal projectile					: game_entity := ("001", -100, -100, 40, 20, 13000, '0', '0', 100);
	signal alien1						: game_entity := ("010", 580, 200, 50, 50, 10500, '1', '0', 100);
	signal alien2						: game_entity := ("011", 640, 100, 150, 40, 17100, '1', '0', 100);
	signal alien3						: game_entity := ("100", 640, 300, 50, 56, 23100, '1', '0', 100);
	signal asteroid					: game_entity := ("101", 640, 150, 60, 60, 25900, '1', '0', 100);
	constant empty						: game_entity := ("111", 580, 200, 0, 0, 0, '0', '0', 500);
	signal e								: entities := (0=>player, 1=>projectile, others=> empty);
	signal score						: integer range 0 to 9999 := 0;
	
	signal game_clk					: STD_LOGIC;
	signal gamePhase					: integer range 1 to 3 := 1;
	signal gamePause					: std_logic := '1';
	signal tpause						: std_logic;
	signal playerLives				: integer range 0 to 3 := 3;
	
	
	
	signal alienclock					: std_logic := '0';
	signal loadValue					: std_logic_vector(7 downto 0);
	signal entitySelect				: std_logic_vector(2 downto 0);
	signal rowValue					: integer := 100;
	
	signal directionX, directionY : std_logic;
	signal speedX, speedY			: integer;
	
	constant maxLoops	 : integer := 8;

	component vga_pll_25_175 is 
	
		port(
		
			inclk0		:	IN  STD_LOGIC := '0';  -- Input clock that gets divided (50 MHz for max10)
			c0			:	OUT STD_LOGIC          -- Output clock for vga timing (25.175 MHz)
		
		);
		
	end component;
	
	component vga_controller is 
	
		port(
		
			pixel_clk	:	IN	STD_LOGIC;	--pixel clock at frequency of VGA mode being used
			reset_n		:	IN	STD_LOGIC;	--active low asycnchronous reset
			h_sync		:	OUT	STD_LOGIC;	--horiztonal sync pulse
			v_sync		:	OUT	STD_LOGIC;	--vertical sync pulse
			disp_ena	:	OUT	STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
			column		:	OUT	INTEGER;	--horizontal pixel coordinate
			row			:	OUT	INTEGER;	--vertical pixel coordinate
			n_blank		:	OUT	STD_LOGIC;	--direct blacking output to DAC
			n_sync		:	OUT	STD_LOGIC   --sync-on-green output to DAC
		
		);
		
	end component;
	
	component hw_image_generator is
	
		port(
			clk 		: in std_logic;
			disp_ena :  IN  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
			e			 :	 in	entities;
			score		:	in integer;
			lives		:	in integer;
			row      :  IN  INTEGER;    --row pixel coordinate
			column   :  IN  INTEGER;    --column pixel coordinate
			red      :  OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
			green    :  OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
			blue     :  OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');   --blue magnitude output to DAC
			game_clk :	 OUT	STD_LOGIC
		);
		
		
		
	end component;
	
	component speed is
		port(
			clock : in std_logic; --16.777Mhz
			maxclk : in std_logic;
			
			GSENSOR_CS_N : OUT	STD_LOGIC;
			GSENSOR_SCLK : OUT	STD_LOGIC;
			GSENSOR_SDI  : INOUT	STD_LOGIC;
			GSENSOR_SDO  : INOUT	STD_LOGIC;
			

			directionX : out std_logic;
			directionY : out std_logic;
			speedX : out integer;
			speedY : out integer
			);
		end component;
		
	component lfsrP is
		port(
			clk : in std_logic;
			reset : in std_logic;
			enable : in std_logic;
			output: out std_logic_vector(7 downto 0)
			);
	end component;
	
	component Clock_Divider is
		generic(counter : integer := 1);
		port ( clk,reset: in std_logic;
			clock_out: out std_logic
		);
	end component;
	
	
	component debouncer is
		generic (
			timeout_cycles : positive
			);
		port (
		 clk : in std_logic;
		 rst : in std_logic;
		 switch : in std_logic;
		 switch_debounced : out std_logic
		);
	end component;
	
	
	
	signal pll_OUT_to_vga_controller_IN, dispEn : STD_LOGIC;
	signal rowSignal, colSignal : INTEGER;
	
	--Alien Spawn Clocks
	signal spawnS, spawnM, spawnF : std_logic;
	
	begin
	
		U1	:	vga_pll_25_175 port map(clkin, pll_OUT_to_vga_controller_IN);
		U2	:	vga_controller port map(pll_OUT_to_vga_controller_IN, '1', h_sync_m, v_sync_m, dispEn, colSignal, rowSignal, open, open);
		U3	:	hw_image_generator port map(pll_OUT_to_vga_controller_IN, '1', e, score, playerLives, rowSignal, colSignal, red_m, green_m, blue_m, game_clk);
		U4 :	speed port map(pll_OUT_to_vga_controller_IN, clkin, GSENSOR_CS_N, GSENSOR_SCLK, GSENSOR_SDI, GSENSOR_SDO, directionX, directionY, speedX, speedY);
		U5	:  lfsrP port map(alienclock, '1', '1', loadValue);
		
		--Alien Spawn Rate Clock Generation
		--0.5Hz
		U6 :  Clock_Divider generic map(90000000) port map(clkin, '0', spawnS);
		--1Hz
		U7 :  Clock_Divider generic map(62500000) port map(clkin, '0', spawnM);
		--2Hz
		U8 :  Clock_Divider generic map(31250000) port map(clkin, '0', spawnF);
		
		U11:  debouncer generic map(50000) port map(clkin, '0', pause, tpause);
		
		
	start_pause: process(tpause)
		begin
			if(rising_edge(tpause)) then
				gamePause <= not gamePause;
			end if;
	end process;
		
	game_main	: process (game_clk)
	variable direction : STD_LOGIC := '0';
	variable alienValue : std_logic_vector(7 downto 0) := (others=> '0');
	variable refresh : std_logic := '0';
	variable alienReady : std_logic := '0';
	begin
		if(rising_edge(game_clk) and playerLives > 0 and gamePause = '1') then
			--Player Speed and Direction
			if(directionX = '1' and (e(0).posx + e(0).len < 320) and e(0).toDelete = '0') then
				e(0).posx <= e(0).posx + speedX;
			elsif(directionX = '0' and (e(0).posx > 0) and e(0).toDelete = '0') then
				e(0).posx <= e(0).posx - speedX;
			end if;
			if(directionY = '1' and (e(0).posy + e(0).height < 380) and e(0).toDelete = '0') then
				e(0).posy <= e(0).posy + speedY;
			elsif(directionY = '0' and (e(0).posy > 0) and e(0).toDelete = '0') then
				e(0).posy <= e(0).posy - speedY;
			end if;
			
			--Alien Game Phase Determination
			if(score <= 30) then
				gamePhase <= 1;
			elsif(score <= 80 and score >= 31) then
				gamePhase <= 2;
			elsif(score >= 81) then
				gamePhase <= 3;
			end if;
			
			--Alien Spawn Rate Determination
			if(gamePhase = 1) then
				alienclock <= spawnS;
			elsif(gamePhase = 2) then
				alienclock <= spawnM;
			elsif(gamePhase = 3) then
				alienclock <= spawnF;
			end if;
			
			--Alien Type Determination
			if(loadValue /= alienValue and refresh = '0') then
				alienValue := loadValue;
				refresh := '1';
			end if;
			if(loadValue /= alienValue and refresh = '1') then
				if(to_integer(unsigned(alienValue)) >= 0 and to_integer(unsigned(alienValue)) <= 100) then
					entitySelect <= "010";
				elsif(to_integer(unsigned(alienValue)) >= 101 and to_integer(unsigned(alienValue)) <= 160) then
					entitySelect <= "011"; --Change to 011 Final
				elsif(to_integer(unsigned(alienValue)) >= 161 and to_integer(unsigned(alienValue)) <= 219) then
					entitySelect <= "100"; --Change to 100 Final
				elsif(to_integer(unsigned(alienValue)) >= 220 and to_integer(unsigned(alienValue)) <= 255) then
					entitySelect <= "101"; --Change to 101 Final
				end if;
				
				if(to_integer(unsigned(loadValue)) <= 165 and refresh = '1') then
					rowValue <= to_integer(unsigned(loadValue)) * 2; --to_integer(unsigned(loadValue)) * 2
				elsif(to_integer(unsigned(loadValue)) >= 166 and refresh = '1' and to_integer(unsigned(loadValue)) <= 240) then
					rowValue <= to_integer(unsigned(loadValue));
				elsif(to_integer(unsigned(loadValue)) >= 241 and refresh = '1' and to_integer(unsigned(loadValue)) <= 245) then
					rowValue <= 250; --250
				elsif(to_integer(unsigned(loadValue)) >= 246 and refresh = '1' and to_integer(unsigned(loadValue)) <= 250) then
					rowValue <= 300;
				elsif(to_integer(unsigned(loadValue)) >= 251 and refresh = '1' and to_integer(unsigned(loadValue)) <= 255) then
					rowValue <= 330;
				end if;
				refresh := '0';
				alienReady := '1';
			end if;
			
			--Enemy Spawn System
			if(alienReady = '1') then
				for i in 2 to maxLoops loop
					if(e(i).entity_type = "111" and e(i).enable = '0') then
						if(entitySelect = "010") then
							e(i) <= alien1;
							e(i).posy <= rowValue;
							alienReady := '0';
							exit;
						elsif(entitySelect = "011") then
							e(i) <= alien2;
							e(i).posy <= rowValue;
							alienReady := '0';
							exit;
						elsif(entitySelect = "100") then
							e(i) <= alien3;
							e(i).posy <= rowValue;
							alienReady := '0';
							exit;
						elsif(entitySelect = "101") then
							e(i) <= asteroid;
							e(i).posy <= rowValue;
							alienReady := '0';
							exit;
						end if;
					end if;
				end loop;
			end if;
			
			--Enemy Movement System
			for i in 2 to maxLoops loop
				if(e(i).enable = '1') then
					if(e(i).entity_type = "010" and e(i).toDelete = '0') then
						e(i).posx <= e(i).posx - 1;
					elsif(e(i).entity_type = "011"and e(i).toDelete = '0') then
						e(i).posx <= e(i).posx - 2;
					elsif(e(i).entity_type = "100"and e(i).toDelete = '0') then
						e(i).posx <= e(i).posx - 3;
					elsif(e(i).entity_type = "101"and e(i).toDelete = '0') then
						e(i).posx <= e(i).posx - 8;
					end if;
				end if;
			end loop;
			
			--Enemy Despawn if Fly By
			for i in 2 to maxLoops loop
				if(e(i).posx < 0) then
					e(i) <= empty;
				end if;
			end loop;
			
				
			--Firing System Begin
			if(fire = '0' and e(1).enable = '0') then
				e(1).posx <= e(0).posx + 10;
				e(1).posy <= e(0).posy + 15;
				e(1).enable <= '1';
			end if;
			
			--Firing System Bullet Travel
			if(e(1).enable = '1' and e(1).posx <= 600) then
				e(1).posx <= e(1).posx + 5;
				if(e(1).imageID = 13000) then
					e(1).imageID <= 13800;
				elsif(e(1).imageID = 13800) then
					e(1).imageID <= 13000;
				end if;
			elsif(e(1).enable = '1' and e(1).posx > 600) then
				e(1).enable <= '0';
				e(1).posx <= -100;
				e(1).posy <= -100;
			end if;
			
			--Firing System Bullet / Enemy Collision Detection
			for i in 2 to maxLoops loop
				if(((e(1).posx < (e(i).posx + e(i).len)) and ((e(1).posx + e(1).len) > e(i).posx) and (e(1).posy < (e(i).posy + e(i).height)) and ((e(1).posy + e(1).height) > e(i).posy)) and e(i).entity_type /= "111" and e(i).toDelete /= '1') then
					e(i).toDelete <= '1';
					e(1).enable <= '0';
					e(1).posx <= -100;
					e(1).posy <= -100;
					if(e(i).entity_type = "010") then
						score <= score + 1;
					elsif(e(i).entity_type = "011") then
						score <= score + 2;
					elsif(e(i).entity_type = "100") then
						score <= score + 3;
					elsif(e(i).entity_type = "101") then
						score <= score + 5;
					end if;
				end if;
			end loop;
			
			
			--Player / Enemy Collision Detecton
			for i in 2 to maxLoops loop
				if(((e(0).posx < (e(i).posx + e(i).len)) and ((e(0).posx + e(0).len) > e(i).posx) and (e(0).posy < (e(i).posy + e(i).height)) and ((e(0).posy + e(0).height) > e(i).posy)) and e(i).entity_type /= "111" and e(i).toDelete /= '1' and e(i).entity_type /= "001") then
					e(0).toDelete <= '1';
					e(i).toDelete <= '1';
					playerLives <= playerLives - 1;
				end if;
			end loop;
			
			--Player Respawn
			if(e(0).entity_type = "111" and playerLives > 0) then
				e(0) <= player;
			end if;
			
			
			
			--Deletion of Shot Enemies
			
			for i in 0 to maxLoops loop
				if(e(i).toDelete = '1') then
					--e(i) <= empty;
					--alienAlive <= alienAlive - 1;
					e(i).imageID <= 8000;
					e(i).entity_type <= "111";
					e(i).len <= 50;
					e(i).height <= 50;
					if(e(i).expCount > 0) then
						e(i).expCount <= e(i).expCount - 1;
					else
						e(i) <= empty;
					end if;
				end if;
			end loop;	
		end if;
	end process game_main;
		
		
		
		
		
		
		
		
end architecture proj0_arch;