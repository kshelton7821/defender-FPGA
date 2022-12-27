library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lfsrP is
	port (
			clk : in std_logic;
			reset : in std_logic;
			enable : in std_logic;
			output: out std_logic_vector(7 downto 0));
end entity;

architecture dataflow of lfsrP is
component lfsr is
generic(
  G_M             : integer           := 7         ;
  G_POLY          : std_logic_vector  := "1100000") ;  -- x^7+x^6+1 
port (
  i_clk           : in  std_logic;
  i_rstb          : in  std_logic;
  i_sync_reset    : in  std_logic;
    i_seed          : in  std_logic_vector (G_M-1 downto 0);
    i_en            : in  std_logic;
    o_lsfr          : out std_logic_vector (G_M-1 downto 0));
end component;

signal prime1: std_logic_vector(1 downto 0);
signal prime2: std_logic_vector(2 downto 0);
signal prime3: std_logic_vector(4 downto 0);
signal prime4: std_logic_vector(6 downto 0);
signal prime5: std_logic_vector(12 downto 0);
signal prime6: std_logic_vector(16 downto 0);
signal prime7: std_logic_vector(18 downto 0);
signal prime8: std_logic_vector(30 downto 0);


begin

P1: lfsr
	generic map (
					G_M => 2,
					G_POLY => "11")
	port map (
				i_clk => clk,
				i_rstb => reset,
				i_sync_reset => '0',
				i_seed => "11",
				i_en => enable,
				o_lsfr => prime1);
				
P2: lfsr
	generic map (
					G_M => 3,
					G_POLY => "110")
	port map (
				i_clk => clk,
				i_rstb => reset,
				i_sync_reset => '0',
				i_seed => "111",
				i_en => enable,
				o_lsfr => prime2);
				
P3: lfsr
	generic map (
					G_M => 5,
					G_POLY => "10100")
	port map (
				i_clk => clk,
				i_rstb => reset,
				i_sync_reset => '0',
				i_seed => "11101",
				i_en => enable,
				o_lsfr => prime3);
				
P4: lfsr
	port map (
				i_clk => clk,
				i_rstb => reset,
				i_sync_reset => '0',
				i_seed => "1101111",
				i_en => enable,
				o_lsfr => prime4);
				
P5: lfsr
	generic map (
					G_M => 13,
					G_POLY => "1110010000000")
	port map (
				i_clk => clk,
				i_rstb => reset,
				i_sync_reset => '0',
				i_seed => "1111101111111",
				i_en => enable,
				o_lsfr => prime5);
				
P6: lfsr
	generic map (
					G_M => 17,
					G_POLY => "10010000000000000")
	port map (
				i_clk => clk,
				i_rstb => reset,
				i_sync_reset => '0',
				i_seed => "11111111111101111",
				i_en => enable,
				o_lsfr => prime6);
				
P7: lfsr
	generic map (
					G_M => 19,
					G_POLY => "1110010000000000000")
	port map (
				i_clk => clk,
				i_rstb => reset,
				i_sync_reset => '0',
				i_seed => "1111111111110111111",
				i_en => enable,
				o_lsfr => prime7);
				
P8: lfsr
	generic map (
					G_M => 31,
					G_POLY => "1001000000000000000000000000000")
	port map (
				i_clk => clk,
				i_rstb => reset,
				i_sync_reset => '0',
				i_seed => "1111111011111111111111111111111",
				i_en => enable,
				o_lsfr => prime8);
				
output <= prime8(0) & prime7(0) & prime6(0) & prime5(0) & prime4(0) & prime3(0) & prime2(0) & prime1(0);
				
				
				
end dataflow;
				
					
			