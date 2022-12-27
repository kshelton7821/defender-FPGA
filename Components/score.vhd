LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_etc.all;

entity scoreDisp is
	port(	data	:	in integer range 0 to 9999;
			offset3, offset2, offset1, offset0	:	out integer
	);
end entity scoreDisp;

architecture scoreDisp_arch of scoreDisp is
begin
	main	:	process (data)
	variable a3,a2,a1,a0 : integer range 0 to 9 := 0;
		begin
					a3 := (data / 1000) mod 10;
					a2 := (data / 100) mod 10;
					a1 := (data / 10) mod 10;
					a0 := data mod 10;
					offset3 <= a3 * 800;
					offset2 <= a2 * 800;
					offset1 <= a1 * 800;
					offset0 <= a0 * 800;
	end process main;
end architecture scoreDisp_arch;