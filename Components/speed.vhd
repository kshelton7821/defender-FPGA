library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity speed is
	port (
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
end speed;

architecture behavioral of speed is
signal data_x      : STD_LOGIC_VECTOR(15 downto 0);
signal data_y      : STD_LOGIC_VECTOR(15 downto 0);
signal data_z      : STD_LOGIC_VECTOR(15 downto 0);
signal dataX : unsigned(7 downto 0);
signal dataY : unsigned(7 downto 0);


component ADXL345_controller is port(
	
		reset_n     : IN STD_LOGIC;
		clk         : IN STD_LOGIC;
		data_valid  : OUT STD_LOGIC;
		data_x      : OUT STD_LOGIC_VECTOR(15 downto 0);
		data_y      : OUT STD_LOGIC_VECTOR(15 downto 0);
		data_z      : OUT STD_LOGIC_VECTOR(15 downto 0);
		SPI_SDI     : OUT STD_LOGIC;
		SPI_SDO     : IN STD_LOGIC;
		SPI_CSN     : OUT STD_LOGIC;
		SPI_CLK     : OUT STD_LOGIC
		
    );
end component;


begin



U0 : ADXL345_controller port map('1', maxclk, open, data_x, data_y, data_z, GSENSOR_SDI, GSENSOR_SDO, GSENSOR_CS_N, GSENSOR_SCLK);
dataX <= unsigned(data_x(11 downto 4));
dataY <= unsigned(data_y(11 downto 4));

DIR: process(clock)	
begin
	if (rising_edge(clock)) then
	--If Flat X-Axis
		if ((to_integer(dataX) = 255) or (to_integer(dataX) = 0)) then
			speedX <= 0;
			--If Tilt Left Stepping
		elsif ((to_integer(dataX) >= 1) and (to_integer(dataX) <= 4)) then
			speedX <= 1;
			directionX <= '0';
		elsif ((to_integer(dataX) >= 5) and (to_integer(dataX) <= 9 )) then
			speedX <= 3;
			directionX <= '0';
		elsif ((to_integer(dataX) >= 10) and (to_integer(dataX) <= 15)) then
			speedX <= 5;
			directionX <= '0';
		--If Tilt Right Stepping
		elsif ((to_integer(dataX) >= 251) and (to_integer(dataX) <= 254)) then
			speedX <= 1;
			directionX<= '1';
		elsif ((to_integer(dataX) >= 245) and (to_integer(dataX) <= 250)) then
			speedX <= 3;
			directionX <= '1';
		elsif ((to_integer(dataX) >= 240 ) and (to_integer(dataX) <= 244 )) then
			speedX <= 5;
			directionX <= '1';
		end if;
	--If Flat Y-Axis
		if ((to_integer(dataY) = 255) or (to_integer(dataY) = 0)) then
			speedY <= 0;
			--If Tilt Up Stepping
		elsif ((to_integer(dataY) >= 1) and (to_integer(dataY) <= 4)) then
			speedY <= 1;
			directionY <= '1';
		elsif ((to_integer(dataY) >= 5) and (to_integer(dataY) <= 9 )) then
			speedY <= 3;
			directionY <= '1';
		elsif ((to_integer(dataY) >= 10) and (to_integer(dataY) <= 15)) then
			speedY <= 5;
			directionY <= '1';
		--If Tilt Down Stepping
		elsif ((to_integer(dataY) >= 251) and (to_integer(dataY) <= 254)) then
			speedY <= 1;
			directionY <= '0';
		elsif ((to_integer(dataY) >= 245) and (to_integer(dataY) <= 250)) then
			speedY <= 3;
			directionY <= '0';
		elsif ((to_integer(dataY) >= 240 ) and (to_integer(dataY) <= 244 )) then
			speedY <= 5;
			directionY <= '0';
		end if;
	end if;
end process;


end behavioral;





