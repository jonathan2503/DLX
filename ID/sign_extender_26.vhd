----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.07.2022 10:06:59
-- Design Name: 
-- Module Name: sign_extender - Behavioral
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

entity sign_extender_26 is
Port (A: in std_logic_vector(25 downto 0);
      B: out std_logic_vector(31 downto 0));
end sign_extender_26;

architecture Behavioral of sign_extender_26 is

begin

process (A)
BEGIN
IF (A(25)= '0') then
B <= "000000"&A;
ELSIF (A(25) = '1') THEN
B <= "111111"&A;
END IF;
END PROCESS;

end Behavioral;

