----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.08.2022 10:30:50
-- Design Name: 
-- Module Name: MUX21_single - Behavioral
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

entity MUX21_single is
 generic(N: integer:=32);
 Port (
       A: in std_logic;
       B: in std_logic;
       sel: in std_logic;
       Y: out std_logic);
end MUX21_single;

architecture Behavioral of MUX21_single is

begin

process(A,B,Sel)
begin
if (Sel = '0') then
Y <= a;
elsif (Sel = '1')then
y <= b;
end if;
end process;
end Behavioral;

