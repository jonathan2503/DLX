----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.07.2022 18:11:19
-- Design Name: 
-- Module Name: TB_REG - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TB_REG is
end TB_REG;

architecture Behavioral of TB_REG is
component MY_REG is
generic (NBIT:INTEGER:=32);
Port ( 
D: IN std_logic_vector(NBIT-1 DOWNTO 0);
CLK: IN std_logic;
RESET: IN std_logic;
ENABLE: IN std_logic;
Q: OUT std_logic_vector(NBIT-1 DOWNTO 0)
);
end COMPONENT;

SIGNAL D,Q: std_logic_vector(31 DOWNTO 0);
SIGNAL CLK,RESET,ENABLE: std_logic;

begin

a: MY_REG port map (D,CLK,RESET,ENABLE,Q);

process
begin
clk <= '0';
wait for 5 ns;
clk <= '1';
wait for 5 ns;
end process;

process 
BEGIN 
RESET <= '0';
ENABLE <= '1';
D <= "01010100000000000000000000000000";
WAIT FOR 10 NS;
D <="01010100000000000000000000000010";
WAIT FOR 10 NS;
D <="01010100000000000000000000010010";
WAIT ;
END PROCESS;
end Behavioral;
