--only for sum

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SUM_PC is
Port ( 
PC: 	IN std_logic_vector(31 DOWNTO 0);
NPC:    OUT std_logic_vector(31 DOWNTO 0)
);
end SUM_PC;

architecture Behavioral of SUM_PC is

begin


PROCESS(PC)
begin
 NPC <= std_logic_vector(UNSIGNED(PC)+1);
END PROCESS;
end Behavioral;
