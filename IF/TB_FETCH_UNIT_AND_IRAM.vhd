----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.07.2022 16:06:17
-- Design Name: 
-- Module Name: TB_FETCH_UNIT_AND_IRAM - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_FETCH_UNIT_AND_IRAM is
end TB_FETCH_UNIT_AND_IRAM;

architecture Behavioral of TB_FETCH_UNIT_AND_IRAM is

component fetch_stage is
Port (
CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: IN std_logic;
PC_IN: IN std_logic_vector(31 downto 0);
PC_OUT : out std_logic_vector(31 downto 0);
IR: in std_logic_vector(31 downto 0);
IR_EXT: OUT std_logic_vector(31 downto 0);
NPC_EXT: OUT std_logic_vector(31 downto 0)
 );
end component;

component IRAM is
  generic (
    RAM_DEPTH : integer := 48;
    I_SIZE : integer := 32);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );

end component;

Signal CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: std_logic;
Signal PC_IN,IR_EXT,NPC_EXT,PC_OUT,IR: std_logic_vector(31 downto 0);

begin

a: fetch_stage PORT map(CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR,PC_IN,PC_OUT,IR,IR_EXT,NPC_EXT);
b: IRAM PORT MAP (NOT(RST),PC_OUT,IR);

PROCESS
BEGIN
CLK<= '0';
WAIT FOR 5 NS;
CLK <= '1';
WAIT FOR 5NS;
END PROCESS;


process
BEGIN
RST <= '1';
WAIT FOR 10NS;
RST <= '0';
EN_LATCH_PC<= '1';EN_LATCH_NPC<= '1';EN_LATCH_IR<= '1';
PC_IN <= "00000000000000000000000000000000";
WAIT FOR 10 NS;
PC_IN <= std_logic_vector(UNSIGNED(PC_IN)+1);
WAIT FOR 10 NS;
PC_IN <= std_logic_vector(UNSIGNED(PC_IN)+1);
WAIT FOR 10 NS;
PC_IN <= std_logic_vector(UNSIGNED(PC_IN)+1);
WAIT FOR 10 NS;
PC_IN <= std_logic_vector(UNSIGNED(PC_IN)+1);
WAIT FOR 10 NS;
PC_IN<= std_logic_vector(UNSIGNED(PC_IN)+1);
WAIT;
END PROCESS;

end Behavioral;
