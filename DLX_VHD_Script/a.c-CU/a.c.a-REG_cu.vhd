

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity REG_CU is
generic (LBIT_UP:INTEGER ; LBIT_DOWN:INTEGER ;RBIT_UP:INTEGER ;RBIT_DOWN:INTEGER   );
Port ( 
RF_IN: IN std_logic_vector(LBIT_UP DOWNTO LBIT_DOWN);
CLK: IN std_logic;
RST: IN std_logic;
ENABLE: IN std_logic;
RF_OUT: OUT std_logic_vector(RBIT_UP DOWNTO RBIT_DOWN)
);
end REG_CU;

architecture Behavioral of REG_CU is

begin


PROCESS(CLK,RF_IN,RST,ENABLE)
begin
IF (RST = '1')THEN
RF_OUT <= (others => '0');
ELSIF (rising_edge(CLK)AND ENABLE = '1') THEN
RF_OUT <= RF_IN(RBIT_UP DOWNTO RBIT_DOWN);
END IF;
END PROCESS;
end Behavioral;
