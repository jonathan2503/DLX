

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Nand3_2 is
Port (
A: IN std_logic_vector(31 DOWNTO 0);
B: IN std_logic_vector(31 DOWNTO 0);
C: IN std_logic_vector(31 DOWNTO 0);
D: IN std_logic_vector(31 DOWNTO 0);
Y: out std_logic_vector(31 DOWNTO 0)

 );
end Nand3_2;

architecture Behavioral of Nand3_2 is

begin
Y <= not (A AND B AND C AND D);

end Behavioral;
