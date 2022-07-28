library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity orr is
    port(
A: in std_logic;
B: in std_logic;
Y: out std_logic);
end orr;

architecture Behavioral of orr is
begin
process(A,B)
begin

Y <= A or B;

end process;
end Behavioral;