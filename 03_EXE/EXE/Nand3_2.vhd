----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.08.2022 11:10:03
-- Design Name: 
-- Module Name: Nand3_2 - Behavioral
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

entity Nand3_2 is
Port (
A: IN std_logic_vector(31 DOWNTO 0);
B: IN std_logic_vector(31 DOWNTO 0);
C: IN std_logic_vector(31 DOWNTO 0);
D: IN std_logic_vector(31 DOWNTO 0);
Y: out std_logic_vector(31 DOWNTO 0)

 );
end Nand3_2;

architecture Behavioral of Nand3_2 is

begin
Y <= not (A AND B AND C AND D);

end Behavioral;
