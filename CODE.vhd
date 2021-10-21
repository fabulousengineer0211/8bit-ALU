-- 8 bit ALU
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_bit.all;
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

-- Division Starts Here
entity div84 is
Port(
Inp: IN bit_vector (7 downto 0);
Divider : In bit_vector(7 downto 0);
remi: OUT bit_vector (5 downto 0);
Quo: OUT bit_vector (2 downto 0)
);
end div84;

architecture Behavioral of div84  is
--CONSTANT Divider : std_logic_vector (7 downto 0) := "00110101";

begin
process(inp)
variable q : bit_vector (2 downto 0);
variable x: bit_vector (7 downto 0):= "00000000";
 begin 
  x := inp;
  q := "000";
  if (x>= Divider) then 
   x := x-Divider;
   q:=q+"001";
   if (x>= Divider) then
    x := x-Divider;
    q:=q+"001";
    if (x>= Divider)then
    x := x-Divider;
    q:=q+"001";
     if (x>= Divider)then
      x := x-Divider;
      remi<= x(5 downto 0);
      Quo<=q+"001";
     else
      remi<=x(5 downto 0);
      Quo<=q;
     end if;
    else
     remi<=x(5 downto 0);
     Quo<=q;
    end if;
   else
    remi<=x(5 downto 0);
    Quo<=q;
   end if;
  else
   remi<=x(5 downto 0);
   Quo<=q;
  end if;
 end process;
 
end Behavioral;

-- Division Ends Here

entity ALUdesign is
port(a : in bit_vector(7 downto 0);
b : in bit_vector(7 downto 0);
o  : out bit_vector(16 downto 0);
s : in bit_vector(2 downto 0);
overflow : out bit;
zeroflg : out bit;
cyflg : out bit);
end entity;

architecture add of ALUdesign is

component div84
port(inp : in bit_vector(7 downto 0);
Divider : in bit_vector(7 downto 0);
remi : out bit_vector (5 downto 0);
quo : out bit_vector (2 downto 0));
end component;

signal i : bit_vector(8 downto 0);
signal y : bit_vector(8 downto 0);
signal z : bit_vector(8 downto 0);
signal remis: bit_vector(5 downto 0);
signal quos: bit_vector(2 downto 0);
begin

process(a,b,s)
variable pv,bp : bit_vector(16 downto 0);
begin

if s = "000" then -- Addition
i <= ('0' & a) + ('0' & b);
o <= "00000000" & i;

if i(8) = '1' then
cyflg <= '1';
else
cyflg <= '0';
end if;

if i = "00000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

if a > 0 and b > 0 then -- Overflow Check

if a + b < 0 then -- For negative overflow
overflow <= '1';
else
overflow <= '0';
end if;

elsif a < 0 and b < 0 then

if a + b > 0 then -- For positive overflow
overflow <= '1';
else
overflow <= '0';
end if;

end if;


elsif s = "001" then -- And
i <= ('0' & a) and ('0' & b);
o <= "00000000" & i;
cyflg <= i(8);
overflow <= '0';
if i = "00000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

elsif s = "010" then -- OR
i <= ('0' & a) or ('0' & b);
o <= "00000000" & i;
cyflg <= i(8);
overflow <= '0';
if i = "00000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

elsif s = "011" then -- Xor
i <= ('0' & a) xor ('0' & b);
o <= "00000000" & i;
cyflg <= i(8);
overflow <= '0';
if i = "00000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

elsif s = "100" then -- Sub
i <= ('0' & a) - ('0' & b);
o <= "00000000" & i;

y <= ('0' & not(b)) + '1';
z <= ('0' & a) + y;

if z(8) = '1' then
cyflg <= '1';
else
cyflg <= '0';
end if;

if a > b then -- Overflow Check
if a - b < 0 then
overflow <= '1';
else 
overflow <= '0';
end if;
end if;

if i = "00000000" then -- Zero Check
zeroflg <= '1';
else
zeroflg <= '0';
end if;

elsif s = "101" then -- Multiply
pv := "00000000000000000";
bp := "000000000" & b;
for i in 0 to 7 loop
     if a(i) = '1' then
	  pv := pv + bp;
	  end if;
	  bp := bp(15 downto 0) & '0';
	  end loop;
	  o <= pv;
	  cyflg <= '0';
if pv(16)  = '1' then
overflow <= '1';
else
overflow <= '0';
end if;
elsif s = "110" then -- Divide -- Here pls check

 	  
end if;

end process;
end add;
