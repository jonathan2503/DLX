----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.08.2022 18:40:19
-- Design Name: 
-- Module Name: zero_detector - Behavioral
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

entity zero_detector is
Port (
X : in std_logic_vector(31 downto 0);
rst: in std_logic;
Z : out std_logic
 );
end zero_detector;

architecture Behavioral of zero_detector is

begin

process(X,rst)
variable k: std_logic;
begin
if (rst='1') then
z <= '0';
else
k := '0';
for i in 0 to 31 loop
k := k or X(i);
end loop;
Z <= not (K);
end if;
end process;

end Behavioral;
