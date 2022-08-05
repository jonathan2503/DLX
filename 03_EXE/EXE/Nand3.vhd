----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.08.2022 11:03:47
-- Design Name: 
-- Module Name: Nand3 - Behavioral
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

entity Nand3 is
Port ( 
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
S: in std_logic;
y: out std_logic_vector(31 downto 0)
);
end Nand3;

architecture Behavioral of Nand3 is

begin

process(A,B,S)
begin
IF (S='0')then
Y <= (OTHERS => '1');
ELSIF (S='1') then
Y <= A NAND B;
END IF;
END PROCESS;

end Behavioral;
