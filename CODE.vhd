-- 8 std_logic ALU
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity ALUdesign is
port(a : in std_logic_vector(7 downto 0);
b : in std_logic_vector(7 downto 0);
o  : out std_logic_vector(15 downto 0);
s : in std_logic_vector(2 downto 0);
overflow : out std_logic;
zeroflg : out std_logic;
cyflg : out std_logic);
end entity;

architecture add of ALUdesign is

signal i : std_logic_vector(8 downto 0);
signal y : std_logic_vector(8 downto 0);
signal z : std_logic_vector(8 downto 0);
begin

process(a,b,s)
variable pv,bp : std_logic_vector(15 downto 0);
begin

if s = "000" then -- Addition
i <= ('0' & a) + ('0' & b);
o <= "0000000" & i;

if i(8) = '1' then
cyflg <= '1';
else
cyflg <= '0';
end if;

if i = "000000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

if a > 0 and b > 0 then -- Overflow Check

if i < 0 then -- For negative overflow
overflow <= '1';
else
overflow <= '0';
end if;

elsif a < 0 and b < 0 then

if i > 0 then -- For positive overflow
overflow <= '1';
else
overflow <= '0';
end if;
end if;


elsif s = "001" then -- And
i <= ('0' & a) and ('0' & b);
o <= "0000000" & i;
cyflg <= i(8);
overflow <= '0';
if i = "000000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

elsif s = "010" then -- OR
i <= ('0' & a) or ('0' & b);
o <= "0000000" & i;
cyflg <= i(8);
overflow <= '0';
if i = "000000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

elsif s = "011" then -- Xor
i <= ('0' & a) xor ('0' & b);
o <= "0000000" & i;
cyflg <= i(8);
overflow <= '0';
if i = "000000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

elsif s = "100" then -- Sub
i <= ('0' & a) - ('0' & b);
o <= "0000000" & i;

y <= ('0' & not(b)) + '1';
z <= ('0' & a) + y;

if z(8) = '1' then
cyflg <= '1';
else
cyflg <= '0';
end if;

if a > b then -- Overflow Check 1
if i < 0 then
overflow <= '1';
else 
overflow <= '0';
end if;
end if;

if i = "000000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

elsif s = "101" then -- Multiply
pv := "0000000000000000";
bp := "00000000" & b;
for i in 0 to 7 loop
     if a(i) = '1' then
	  pv := pv + bp;
	  end if;
	  bp := bp(14 downto 0) & '0';
	  end loop;
	  o <= pv;
	  cyflg <= '0';
	  if pv = "0000000000000000" then
	  zeroflg <= '1';
	  else 
	  zeroflg <= '0';
	  end if;
	  overflow <= '0';
end if;
end process;
end add;


