----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.07.2022 18:41:42
-- Design Name: 
-- Module Name: fetch_stage - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity fetch_stage is
Port (
CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: IN std_logic;
PC_IN: IN std_logic_vector(31 downto 0);
PC_OUT : out std_logic_vector(31 downto 0);
IR: in std_logic_vector(31 downto 0);
IR_EXT: OUT std_logic_vector(31 downto 0);
NPC_EXT: OUT std_logic_vector(31 downto 0)
 );
end fetch_stage;

architecture Behavioral of fetch_stage is
component REG is
	GENERIC(
		NBIT : integer:=32 );
	PORT(
		INPUT : IN std_logic_vector(NBIT-1 downto 0);
		CLK : IN std_logic;
		ENABLE: IN std_logic;
		RESET : IN std_logic;
		OUTPUT : OUT std_logic_vector(NBIT-1 downto 0)
	);
end component;

SIGNAL NPC,PC: std_logic_vector(31 DOWNTO 0);

begin

reg1: REG PORT MAP(
                    INPUT=>PC_IN,
                    CLK => CLK, 
                    ENABLE=>EN_LATCH_PC, 
                    RESET=>RST,
                    OUTPUT=>PC );
                    
reg2: REG PORT MAP(
                    INPUT=>IR,
                    CLK => CLK, 
                    ENABLE=>EN_LATCH_IR, 
                    RESET=>RST,
                    OUTPUT=>IR_EXT );
              

reg3: REG PORT MAP(
                    INPUT=>NPC,
                    CLK => CLK, 
                    ENABLE=>EN_LATCH_NPC, 
                    RESET=>RST,
                    OUTPUT=>NPC_EXT);
                    
NPC <= std_logic_vector(UNSIGNED(PC)+4);
PC_OUT<= PC;
end Behavioral;
