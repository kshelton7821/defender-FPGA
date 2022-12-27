-- --------------------------------------  
--
--  BASIC VHDL LOGIC GATES PACKAGE
--
--  (C) 2018, 2019 JW BRUCE 
--  TENNESSEE TECH UNIVERSITY 
--
-- ----------------------------------------
--      DO NOT MODIFY THIS FILE!!!!!!!!!
-- ----------------------------------------
-- REVISION HISTORY
-- ----------------------------------------
-- Rev 0.1 -- Created        (JWB Nov.2018)
-- Rev 0.2 -- Refactored into package
--                           (JWB Nov.2018)
-- Rev 0.3 -- Added more combinational
--            gates and the first sequential
--            logic primitives (SR latch & FF)
--                           (JWB Dec.2018)
-- Rev 0.4 -- Clean up some and prepared
--            for use in the Spring 2019
--            semester
--                           (JWB Feb.2019)
-- Rev 0.5 -- Created better design example
--            for use in the Spring 2019
--            semester
--                           (JWB Feb.2019)
-- Rev 0.6 -- Added some behavioral combi
--            logic building blocks
--                           (JWB Sept.2019)

--
-- ================================================
-- Package currently contains the following gates:
-- ================================================
--  COMBINATIONAL               SEQUENTIAL
--    inv                         SR 
--    orX
--    norX
--    andX
--    nandX
--    xorX
--    xnorX
--
--  where X is 2, 3, 4 and
--    denotes the number of inputs
-- ==================================

-- --------------------------------------  
library IEEE;
use IEEE.STD_LOGIC_1164.all;
--- -------------------------------------  

-- EXAMPLE 1 : package and package body definition

package TTU is
  constant Size: Natural; -- Deferred constant
  subtype Byte is STD_LOGIC_VECTOR(7 downto 0);
  -- Subprogram declaration...
  function PARITY (V: Byte) return STD_LOGIC;
  function MAJ4 (x1: STD_LOGIC; x2:STD_LOGIC; x3:STD_LOGIC;x4:STD_LOGIC) return STD_LOGIC;
end package TTU;

package body TTU is
  constant Size: Natural := 16;
  -- Subprogram body...
  function PARITY (V: Byte) return STD_LOGIC is
    variable B: STD_LOGIC := '0';
  begin
    for I in V'RANGE loop
      B := B xor V(I);
    end loop;
    return B;
  end function PARITY;
  
  function MAJ4 (x1: STD_LOGIC;x2:STD_LOGIC;x3:STD_LOGIC;x4:STD_LOGIC) return STD_LOGIC is
    variable tmp: STD_LOGIC_VECTOR(3 downto 0);
    variable retval: STD_LOGIC;
  begin
    tmp := x1 & x2 & x3 & x4;
    
    if (tmp = "1110") then
      retval := '1';
    elsif (tmp = "1101") then
      retval := '1';
    elsif (tmp = "1011") then      
      retval := '1';
    elsif (tmp = "0111") then      
      retval := '1';
    elsif (tmp = "1111") then      
      retval := '1';
    else      
      retval := '0';
    end if;
    return retval;
  end function MAJ4;
  
end package body TTU;

----------------------------------------  
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity EX_PACKAGE is port(
  A  :  in Byte;
  Y  : out STD_LOGIC);
end entity EX_PACKAGE;

architecture A1 of EX_PACKAGE is
  begin
    Y <= PARITY(A);
end architecture A1;

----------------------------------------  
-- The INVERTER
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity INV is
port(
  x: in STD_LOGIC;
  y: out STD_LOGIC);
end INV;

architecture RTL of INV is
begin
  process(x) is
  begin
    y <= not x;
  end process;
end RTL;

-- ------------------------------------
-- OR GATES

----------------------------------------  
-- The TWO-INPUT OR GATE
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity OR2 is
port(
  x0: in std_logic;
  x1: in std_logic;
  y: out std_logic);
end OR2;

architecture RTL of OR2 is
begin
  process(x0, x1) is
  begin
    y <= x0 or x1;
  end process;
end RTL;

-- The THREE-input OR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity OR3 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  y: out std_logic);
end OR3;

architecture RTL of or3 is
begin
  process(x0, x1, x2) is
  begin
    y <= x1 or x2 or x0;
  end process;
end RTL;

-- The FOUR-input OR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity OR4 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  x3: in std_logic;
  y: out std_logic);
end OR4;

architecture RTL of OR4 is
begin
  process(x1, x2, x3, x0) is
  begin
    y <= x1 or x2 or x3 or x0;
  end process;
end RTL;

-- ------------------------------------
-- AND GATES

-- The TWO-input AND gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity AND2 is
port(
  x0: in std_logic;
  x1: in std_logic;
  y: out std_logic);
end AND2;

architecture RTL of AND2 is
begin
  process(x1, x0) is
  begin
    y <= x1 and x0;
  end process;
end RTL;

-- The THREE-input AND gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity AND3 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  y: out std_logic);
end AND3;

architecture RTL of AND3 is
begin
  process(x1, x2, x0) is
  begin
    y <= x1 and x2 and x0;
  end process;
end RTL;

-- The FOUR-input AND gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity AND4 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  x3: in std_logic;
  y: out std_logic);
end AND4;

architecture RTL of AND4 is
begin
  process(x1, x2, x3, x0) is
  begin
    y <= x1 and x2 and x3 and x0;
  end process;
end RTL;

-- ------------------------------------
-- XOR GATES

-- The TWO-input XOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity XOR2 is
port(
  x0: in std_logic;
  x1: in std_logic;
  y: out std_logic);
end XOR2;

architecture RTL of XOR2 is
begin
  process(x1, x0) is
  begin
    y <= x1 xor x0;
  end process;
end RTL;

-- The THREE-input XOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity XOR3 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  y: out std_logic);
end XOR3;

architecture RTL of XOR3 is
begin
  process(x1, x2, x0) is
  begin
    y <= x1 xor x2 xor x0;
  end process;
end RTL;

-- The FOUR-input XOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity XOR4 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  x3: in std_logic;
  y: out std_logic);
end XOR4;

architecture RTL of XOR4 is
begin
  process(x1, x2, x3, x0) is
  begin
    y <= x1 xor x2 xor x3 xor x0;
  end process;
end RTL;

-- ------------------------------------
-- NOR GATES

-- The TWO-input NOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity NOR2 is
port(
  x0: in std_logic;
  x1: in std_logic;
  y: out std_logic);
end NOR2;

architecture RTL of NOR2 is
begin
  process(x1, x0) is
  begin
    y <= x1 nor x0;
  end process;
end RTL;

-- The THREE-input NOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity NOR3 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  y: out std_logic);
end NOR3;

architecture RTL of NOR3 is
begin
  process(x1, x2, x0) is
  begin
    y <= not(x1 or x2 or x0);
  end process;
end RTL;

-- The FOUR-input NOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity NOR4 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  x3: in std_logic;
  y: out std_logic);
end NOR4;

architecture RTL of NOR4 is
begin
  process(x1, x2, x3, x0) is
  begin
    y <= not(x1 or x2 or x3 or x0);
  end process;
end RTL;

-- ------------------------------------
-- NAND GATES

-- The TWO-input NAND gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity NAND2 is
port(
  x0: in std_logic;
  x1: in std_logic;
  y: out std_logic);
end NAND2;

architecture RTL of NAND2 is
begin
  process(x1, x0) is
  begin
    y <= x1 nand x0;
  end process;
end RTL;

-- The THREE-input NAND gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity NAND3 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  y: out std_logic);
end NAND3;

architecture RTL of NAND3 is
begin
  process(x1, x2, x0) is
  begin
    y <= not(x1 and x2 and x0);
  end process;
end RTL;

-- The FOUR-input NAND gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity NAND4 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  x3: in std_logic;
  y: out std_logic);
end NAND4;

architecture RTL of NAND4 is
begin
  process(x1, x2, x3, x0) is
  begin
    y <= not(x1 and x2 and x3 and x0);
  end process;
end RTL;

-- ------------------------------------
-- XNOR GATES

-- The TWO-input XNOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity XNOR2 is
port(
  x0: in std_logic;
  x1: in std_logic;
  y: out std_logic);
end XNOR2;

architecture RTL of XNOR2 is
begin
  process(x1, x0) is
  begin
    y <= x1 xnor x0;
  end process;
end RTL;

-- The THREE-input XNOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity XNOR3 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  y: out std_logic);
end XNOR3;

architecture RTL of XNOR3 is
begin
  process(x1, x2, x0) is
  begin
    y <= not(x1 xor x2 xor x0);
  end process;
end rtl;

-- The FOUR-input XOR gate
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity XNOR4 is
port(
  x0: in std_logic;
  x1: in std_logic;
  x2: in std_logic;
  x3: in std_logic;
  y: out std_logic);
end XNOR4;

architecture RTL of XNOR4 is begin
  process(x1, x2, x3, x0) is
  begin
    y <= not(x0 xor x1 xor x2 xor x3);
  end process;
end RTL;

-- =======================================================
-- === COMBINATIONAL LOGIC BUILDING BLOCKS
-- =======================================================

-- the 3-to-8 decoder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TTU.all;

entity decoder_3to8 is
	port ( 	sel : in STD_LOGIC_VECTOR (2 downto 0);
			y : out STD_LOGIC_VECTOR (7 downto 0));
end decoder_3to8;

architecture behavioral of decoder_3to8 is
	begin
		with sel select
			y <=	"00000001" when "000",
					"00000010" when "001",
					"00000100" when "010",
					"00001000" when "011",
					"00010000" when "100",
					"00100000" when "101",
					"01000000" when "110",
					"10000000" when "111",
					"00000000" when others;
end behavioral;

-- the two-to-one MUX
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TTU.all;
 
entity mux_2to1 is
	port(	A,B : in STD_LOGIC;
			S: in STD_LOGIC;
			Z: out STD_LOGIC);
end mux_2to1;
 
architecture behavioral of mux_2to1 is
	begin
 
	process (A,B,S) is
		begin
			if (S ='0') then
				Z <= A;
			else
				Z <= B;
			end if;
	end process;
end behavioral;

-- the four-to-one MUX
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.TTU.all;

entity mux_4to1 is
 port(A,B,C,D : in STD_LOGIC;
      S0,S1: in STD_LOGIC;
      Z: out STD_LOGIC);
end mux_4to1;
 
architecture behavioral of mux_4to1 is
	begin
		process (A,B,C,D,S0,S1) is
			begin
  				if (S0 ='0' and S1 = '0') then
      				Z <= A;
  				elsif (S0 ='1' and S1 = '0') then
      				Z <= B;
  				elsif (S0 ='0' and S1 = '1') then
      				Z <= C;
  				else
      				Z <= D;
  				end if;
		end process;
end behavioral;

-- =======================================================
-- === SEQUENTIAL GATES
-- =======================================================
-- The SR latch
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TTU.all;

entity SR_LATCH is
    Port ( S : in    STD_LOGIC;
           R : in    STD_LOGIC;
           Q : inout STD_LOGIC;
           Qnot: inout STD_LOGIC); 
end SR_LATCH;

architecture RTL of SR_LATCH is begin
  Q    <= R nor Qnot;
  Qnot <= S nor Q;
end RTL;

-- the SR flip-flop

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TTU.all;

entity SRFF is port(
  S: in std_logic;
  R: in std_logic;
  CLK: in std_logic;
  RESET: in std_logic;
  Q: out std_logic;
  Qnot: out std_logic);
end SRFF;

architecture RTL of SRFF is begin
  process(S,R,CLK,RESET)
  begin
    if(RESET='1') then		-- async reset
       Q <= '0';
       Qnot <= '0';
    elsif(rising_edge(clk)) then	-- synchronous behavoir
       if( S /= R) then
         Q <= S;
         Qnot <= R;
       elsif (S='1' and R='1') then
         Q <= 'Z';
         Qnot <= 'Z';
       end if;
     end if;
   end process;
end RTL;

-- the D flip-flop

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TTU.all;

entity DFF1 is port(
  D: in std_logic;
  CLK: in std_logic;
  RESET: in std_logic;
  Q: out std_logic;
  Qnot: out std_logic);
end DFF1;

architecture RTL of DFF1 is begin
  process(D,CLK,RESET)
  begin
    if(RESET='1') then		-- async reset
       Q <= '0';
       Qnot <= '0';
    elsif(rising_edge(clk)) then	-- synchronous behavoir
       Q <= D;
       Qnot <= not D;
     end if;
   end process;
end RTL;


--7Seg Display
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity bin2seg7 is 
	port (inData : in std_logic_vector(3 downto 0);
			blanking : in std_logic;
			dispHex : in std_logic;
			dispPoint : in std_logic;
			segA : out std_logic;
			segB : out std_logic;
			segC : out std_logic;
			segD : out std_logic;
			segE : out std_logic;
			segF : out std_logic;
			segG : out std_logic;
			segPoint : out std_logic);
end bin2seg7;

architecture behavioral of bin2seg7 is 
signal output : std_logic_vector(6 downto 0);
signal decOut: std_logic;
begin

U1: process (inData,dispHex,blanking,dispPoint)
begin
	if (blanking = '0') then
	output <= "1111111";
	decOut <= '1';
	else
		decOut <= not dispPoint;
		if (dispHex = '1') then
			case (inData) is
				when "0000" => output <= "0000001";
				when "0001" => output <= "1001111";
				when "0010" => output <= "0010010";
				when "0011" => output <= "0000110";
				when "0100" => output <= "1001100";
				when "0101" => output <= "0100100";
				when "0110" => output <= "0100000";
				when "0111" => output <= "0001111";
            when "1000" => output <= "0000000";
            when "1001" => output <= "0000100";
            when "1010" => output <= "0001000";
            when "1011" => output <= "1100000";
            when "1100" => output <= "0110001";
            when "1101" => output <= "1000010";
            when "1110" => output <= "0110000";
            when "1111" => output <= "0111000";
				when others => null;
			end case;
		else
			case (inData) is
				when "0000" => output <= "0000001";
				when "0001" => output <= "1001111";
				when "0010" => output <= "0010010";
				when "0011" => output <= "0000110";
				when "0100" => output <= "1001100";
				when "0101" => output <= "0100100";
				when "0110" => output <= "0100000";
				when "0111" => output <= "0001111";
            when "1000" => output <= "0000000";
            when "1001" => output <= "0000100";
				when others => output <= "1111111";
			end case;
		end if;
	end if;
end process;

segA <= output(6);
segB <= output(5);
segC <= output(4);
segD <= output(3);
segE <= output(2);
segF <= output(1);
segG <= output(0);
segPoint <= decOut;


end behavioral;

--Debouncer
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity debouncer is
  generic (
    timeout_cycles : positive
    );
  port (
    clk : in std_logic;
    rst : in std_logic;
    switch : in std_logic;
    switch_debounced : out std_logic
  );
end debouncer;

architecture rtl of debouncer is
 
  signal debounced : std_logic;
  signal counter : integer range 0 to timeout_cycles - 1;
 
begin
 
  -- Copy internal signal to output
  switch_debounced <= debounced;
 
  DEBOUNCE_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        counter <= 0;
        debounced <= switch;
         
      else
         
        if counter < timeout_cycles - 1 then
          counter <= counter + 1;
        elsif switch /= debounced then
          counter <= 0;
          debounced <= switch;
        end if;
 
      end if;
    end if;
  end process;
 
end architecture;


--LFSR

library ieee; 
use ieee.std_logic_1164.all;

entity lfsr is 
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
end lfsr;

architecture rtl of lfsr is  
signal r_lfsr           : std_logic_vector (G_M downto 1) := (others => '1');
signal w_mask           : std_logic_vector (G_M downto 1);
signal w_poly           : std_logic_vector (G_M downto 1);

begin  
o_lsfr  <= r_lfsr(G_M downto 1);

w_poly  <= G_POLY;
g_mask : for k in G_M downto 1 generate
  w_mask(k)  <= w_poly(k) and r_lfsr(1);
end generate g_mask;

p_lfsr : process (i_clk,i_rstb) begin 
  if (i_rstb = '0') then 
    r_lfsr   <= (others=>'1');
  elsif rising_edge(i_clk) then 
    if(i_sync_reset='1') then
      r_lfsr   <= i_seed;
    elsif (i_en = '1') then 
      r_lfsr   <= '0'&r_lfsr(G_M downto 2) xor w_mask;
    end if; 
  end if; 
end process p_lfsr; 
end architecture rtl;


--Clock Divider
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity Clock_Divider is
	generic (counter : integer := 1);
	port ( clk,reset: in std_logic;
	clock_out: out std_logic);
end Clock_Divider;
  
architecture bhv of Clock_Divider is
  
signal count: integer:= 1;
signal tmp : std_logic := '0';
  
begin
  
process(clk,reset)
begin
if(reset='1') then
count<=1;
tmp<='0';
elsif(clk'event and clk='1') then
count <=count+1;
if (count = counter) then
tmp <= NOT tmp;
count <= 1;
end if;
end if;
clock_out <= tmp;
end process;
  
end bhv;


--Generic Ripple Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ripple_counter is
	generic (n : natural := 4);
	port (
			clk : in std_logic;
			clear : in std_logic;
			dout: out std_logic_vector(n-1 to 0));
end ripple_counter;

architecture arch_rtl of ripple_counter is
signal clk_i : std_logic_vector(n-1 downto 0);
signal q_i : std_logic_vector(n-1 downto 0);

begin
	clk_i(0) <= clk;
	clk_i(n-1 downto 1) <= q_i(n-2 downto 0);
	
	gen_cnt: for i in 0 to n-1 generate
		dff: process(clear,clk_i)
		begin
			if (clear = '1') then
				q_i(i) <= '1';
			elsif (clk_i(i)'event and clk_i(i) = '1') then
				q_i(i) <= not q_i(i);
			end if;
		end process dff;
	end generate;
	dout <= not q_i;
end arch_rtl;


--Counter Up/Down with Async Reset and Sync Reset

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- ~ --
entity cnt_bindir is
  generic ( n : natural := 8 );
  port (
    dout                 : out std_logic_vector(n-1 downto 0);
    dir                  : in  std_logic;
    clk, arst, srst, en  : in  std_logic );
end;
-- ~ --
architecture rtl of cnt_bindir is
  -- declaration of signals inside this block
  signal reg_cnt, nxt_cnt : std_logic_vector(n-1 downto 0) :=(others => '0');
begin
--
  dff_cnt: process(arst, clk)
  begin
    if (arst = '1') then reg_cnt <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (srst = '1') then reg_cnt <= (others => '0');
      else
        if (en = '1') then
          reg_cnt <= nxt_cnt;
        end if;
      end if;
    end if;
  end process;

  cmb_cnt: process(reg_cnt, dir)
  begin
    if (dir = '0') then
      nxt_cnt <= reg_cnt + 1;
    else
      nxt_cnt <= reg_cnt - 1;
    end if;
  end process;

  -- outputs --
  dout <= reg_cnt;
  -- ~ --
end rtl;


