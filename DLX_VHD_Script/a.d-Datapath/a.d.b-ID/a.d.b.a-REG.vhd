--RESET POSITIVO, ENABLE POSITIVO

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;

entity REG is
generic (NBIT:INTEGER);
Port ( 
RF_IN: IN std_logic_vector(NBIT-1 DOWNTO 0);
CLK: IN std_logic;
RST: IN std_logic;
ENABLE: IN std_logic;
RF_OUT: OUT std_logic_vector(NBIT-1 DOWNTO 0)
);
end REG;

architecture Behavioral of REG is

begin


PROCESS(CLK,RF_IN,RST,ENABLE)
begin
IF (RST = '1')THEN
RF_OUT <= (others => '0');
ELSIF (rising_edge(CLK)AND ENABLE = '1') THEN
RF_OUT <= RF_IN;
END IF;
END PROCESS;
end Behavioral;
