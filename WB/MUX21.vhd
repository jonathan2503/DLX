library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity MUX21 is
generic(N: integer:=32);
Port (
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
sel: in std_logic;
Y: out std_logic_vector(N-1 downto 0));
end MUX21;

architecture Behavioral of MUX21 is
begin
process(sel,A,B)
begin
if (sel = '0') then
Y <= A;
elsif (sel = '1') then
Y <= B;
end if;
end process;
end Behavioral;
