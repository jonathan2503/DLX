----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.07.2022 17:25:59
-- Design Name: 
-- Module Name: TB_IF - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_IF is
end TB_IF;

architecture Behavioral of TB_IF is
COMPONENT fetch_stage is
Port (
CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: IN std_logic;
PC_IN: IN std_logic_vector(31 downto 0);
PC_OUT : out std_logic_vector(31 downto 0);
IR: in std_logic_vector(31 downto 0);
IR_EXT: OUT std_logic_vector(31 downto 0);
NPC_EXT: OUT std_logic_vector(31 downto 0)
 );
end COMPONENT;

SIGNAL CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: std_logic;
SIGNAL PC_IN,PC_OUT,IR,IR_EXT,NPC_EXT: std_logic_vector(31 downto 0);

begin

FS: fetch_stage PORT MAP (CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR,PC_IN,PC_OUT,IR,IR_EXT,NPC_EXT);


process
begin
CLK <= '0';
WAIT FOR 5 NS;
CLK <= '1';
WAIT FOR 5 NS;
END PROCESS;

process
begin
RST<= '1';EN_LATCH_PC<='1';EN_LATCH_NPC<='1';EN_LATCH_IR<='1';
WAIT FOR 5 NS;
RST <= '0';
PC_IN<="00001011111111111111111111100100";
IR <="01010100000000000000000000000000";
WAIT FOR 30 NS;
PC_IN<="00001011111111111111111111100110";
IR <="01010100000000000000000000000001";
WAIT FOR 30 NS;
PC_IN<="00001011111111111111111111100111";
IR <="01010100000000000000000000000010";
WAIT;
END PROCESS;


end Behavioral;
