----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.07.2022 19:19:30
-- Design Name: 
-- Module Name: WB_stage - Behavioral
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

entity WB_stage is
Port (
CLK,RST,CTR_MUX: IN std_logic;
ALU_OUTPUT: IN std_logic_vector(31 downto 0);
MEM_OUTPUT: IN std_logic_vector(31 downto 0);
OUTPUT: OUT std_logic_vector(31 downto 0));

end WB_stage;

architecture Behavioral of WB_stage is

COMPONENT MUX21 is
generic(N: integer:=32);
Port (
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
sel: in std_logic;
Y: out std_logic_vector(N-1 downto 0));
end COMPONENT;

begin

MUX1: MUX21 PORT MAP (
                        A=>ALU_OUTPUT,
                        B=>MEM_OUTPUT,
                        SEL=>CTR_MUX,
                        Y=> OUTPUT
                        );
end Behavioral;
