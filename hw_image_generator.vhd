LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_etc.all;

ENTITY hw_image_generator IS  
  PORT(
	 clk		 : in std_logic;
    disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
	 e			 :	 in	entities;
	 score	 :	 in	integer;
	 lives	 :	 in	integer;
--	 data		 :  IN	mainArea;
--	 header	 :	 IN	scoreArea;
    row      :  IN   INTEGER;    --row pixel coordinate
    column   :  IN   INTEGER;    --column pixel coordinate
    red      :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); --blue magnitude output to DAC
	 game_clk :	 OUT	STD_LOGIC
);
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
--constant bulletDraw : bulletarray := (0=>projectile1, 1=>projectile2);

component scoreDisp
	port(	data	:	in integer range 0 to 9999;
			offset3, offset2, offset1, offset0	:	out integer
	);
end component scoreDisp;

component single_port_ram is

	generic 
	(
		DATA_WIDTH : natural := 12;
		ADDR_WIDTH : natural := 16
	);

	port 
	(
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end component;

signal scoreVector		:	STD_LOGIC_VECTOr (15 downto 0);
signal d0, d1, d2, d3	:	integer;
signal l0					:	integer;
signal ramColor			:	STD_LOGIC_VECTOR (11 downto 0);
signal address				:	integer := 0;
begin

	U0	:	scoreDisp port map(score,d3,d2,d1,d0);
	U1	:	scoreDisp port map(lives, open, open, open, l0);
	U2 :	single_port_ram port map(clk, address, "000000000000", '0', ramColor);
	
main	: process (clk)
	variable colordata	:	STD_LOGIC_VECTOR (11 downto 0);
	begin
		if(row = 0 and column = 0) then
			game_clk <= '1';
		
		elsif(row = 100 and column = 0) then
			game_clk <= '0';
		
		end if;
		
		if(row <= 98) then
			
			if(row >= 30 and row <= 70 and column >= 102 and column <= 122) then
				address <= l0 + 1 + ((row - 30) * 20 + column - 102);
				red <= ramColor(11 downto 8);
				green <= ramColor(7 downto 4);
				blue <= ramColor(3 downto 0);
				
			elsif(row >= 30 and row <= 70 and column >= 493 and column <= 573) then
				if(column >= 493 and column < 513) then
					address <= d3 + 1 + ((row - 30) * 20 + column - 494);
					
				elsif(column >= 513 and column < 533) then
					address <= d2 + 1 + ((row - 30) * 20 + column - 514);
					
				elsif(column >= 533 and column < 553) then
					address <= d1 + 1 + ((row - 30) * 20 + column - 534);
					
				elsif(column >= 553 and column < 573) then
					address <= d0 + 1 + ((row - 30) * 20 + column - 554);
					
				end if;
				red <= ramColor(11 downto 8);
				green <= ramColor(7 downto 4);
				blue <= ramColor(3 downto 0);
				
			elsif(column >= 213 and column <= 427) then
				address <= 29500 + 1 + (row * 214 + column - 213);
				red <= ramColor(11 downto 8);
				green <= ramColor(7 downto 4);
				blue <= ramColor(3 downto 0);
			else 
				red <= "1000";
				green <= "1001";
				blue <= "1010";
			end if;	
			
		elsif(row <= 100) then
			red <= "1101";
			green <= "0110";
			blue <= "0010";
		else
			address <= 19400;
			for i in e'range loop
				if(e(i).enable = '1') then
					if((row - 100 >= e(i).posy and row - 100 <= e(i).posy + e(i).height and column + 1 >= e(i).posx and column <= e(i).posx + e(i).len)) then
						if(e(i).entity_type = "000") then
							if(playerPixels(1 + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx))) = '1') then
								address <= 1 + e(i).imageID + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx));
							end if;
							
						elsif(e(i).entity_type = "010") then
							if(alien1Pixels(1 + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx))) = '1') then
								address <= 1 + e(i).imageID + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx));
							end if;
						
						elsif(e(i).entity_type = "011") then
							if(alien2Pixels(1 + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx))) = '1') then
								address <= 1 + e(i).imageID + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx));
							end if;
						
						elsif(e(i).entity_type = "100") then
							if(alien3Pixels(1 + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx))) = '1') then
								address <= 1 + e(i).imageID + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx));
							end if;
						
						elsif(e(i).entity_type = "101") then
							if(asteroidPixels(1 + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx))) = '1') then
								address <= 1 + e(i).imageID + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx));
							end if;
						
						elsif(e(i).entity_type = "111") then
							if(explosionPixels(1 + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx))) = '1') then
								address <= 1 + e(i).imageID + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx));
							end if;							
						
						else
							address <= 1 + e(i).imageID + (((row - 100) - e(i).posy) * e(i).len + (column - e(i).posx));
						
						end if;
					end if;
				end if;
			end loop;
			red <= ramColor(11 downto 8);
			green <= ramColor(7 downto 4);
			blue <= ramColor(3 downto 0);
		end if;
	end process main;

END behavior;
