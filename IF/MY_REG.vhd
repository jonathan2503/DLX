--RESET POSITIVO, ENABLE POSITIVO

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MY_REG is
generic (NBIT:INTEGER:=32);
Port ( 
D: IN std_logic_vector(NBIT-1 DOWNTO 0);
CLK: IN std_logic;
RESET: IN std_logic;
ENABLE: IN std_logic;
Q: OUT std_logic_vector(NBIT-1 DOWNTO 0)
);
end MY_REG;

architecture Behavioral of MY_REG is

begin

PROCESS(D,CLK,RESET,ENABLE)
begin
IF RESET <= '1' then
Q <= (OTHERS => '0');
ELSIF rising_edge(CLK) AND ENABLE <= '1'then
Q <= D;
END IF;
END PROCESS;

end Behavioral;
