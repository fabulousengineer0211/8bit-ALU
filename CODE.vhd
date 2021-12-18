-- 8 std_logic ALU
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity div84 is
port(a : in std_logic_vector(7 downto 0);
b : in std_logic_vector(7 downto 0);
o  : out std_logic_vector(15 downto 0);
s : in std_logic_vector(2 downto 0);
overflow : out std_logic;
zeroflg : out std_logic;
cyflg : out std_logic);
end entity;

architecture add of div84 is

signal i : std_logic_vector(8 downto 0);
signal y : std_logic_vector(8 downto 0);
signal z : std_logic_vector(8 downto 0);

procedure div4( -- Division procedure Starts
numer : in std_logic_vector(7 downto 0);
denom : in std_logic_vector(3 downto 0);
quotient : out std_logic_vector(3 downto 0);
remainder : out std_logic_vector(3 downto 0)) is
variable d,n1: std_logic_vector(4 downto 0);
variable n2: std_logic_vector(3 downto 0);
begin
d := '0' & denom;
n2 := numer(3 downto 0);
n1 := '0' & numer(7 downto 4);
for i in 0 to 3 loop
     n1 := n1(3 downto 0) & n2(3);
	  n2 := n2(2 downto 0) & '0';
	  if n1 >= d then
	         n1 := n1 - d;
				n2(0) := '1';
		end if;		
end loop;
quotient := n2;
remainder := n1(3 downto 0);
end procedure;	-- Division Procedure Ends

begin
process(a,b,s)
variable remH,remL,quotL,quotH: std_logic_vector(3 downto 0);
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

elsif s = "110" then -- division

div4("0000" & a(7 downto 4),b(3 downto 0),quotH,remH);
div4(remH & a(3 downto 0),b(3 downto 0),quotL,remL);

o(15 downto 8) <= "00000000";
o(7 downto 4) <= quotH;
o(3 downto 0) <= quotL;
--	 remainder <= remL;
	 
end if;	 
end process;
end add;


