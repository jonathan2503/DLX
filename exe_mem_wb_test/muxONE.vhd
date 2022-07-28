library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity MUXone is
Port (
A: in std_logic ;
B: in std_logic ;
sel: in std_logic;
Y: out std_logic );
end MUXone;

architecture Behavioral of MUXone is
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