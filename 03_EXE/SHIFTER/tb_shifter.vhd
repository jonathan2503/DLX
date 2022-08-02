----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.08.2022 12:24:36
-- Design Name: 
-- Module Name: TB - Behavioral
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

entity TB is
end TB;

architecture Behavioral of TB is
COMPONENT Shifter is
Port (
A: IN std_logic_vector(31 DOWNTO 0);--valore da shiftare
B: IN std_logic_vector(31 DOWNTO 0);--quanto shiftare il valore
R_L : IN std_logic;--destra o sinistra
L_A: IN std_logic;--logic or arithmetic
S_R: IN std_logic; --shift or rotate
Y: OUT std_logic_vector(31 downto 0)--output
 );
end COMPONENT;

SIGNAL A,B,Y: std_logic_vector(31 DOWNTO 0);
SIGNAL R_L,L_A,S_R : std_logic;

begin

Q: Shifter PORT MAP (A,B,R_L,L_A,S_R,Y);



process
begin
--ROTATE
A <= "11000000000000000000000000000011";
B <= "00000000000000000000000000000011";
R_L <= '0';
S_R <= '1';
L_A <= '0';
WAIT FOR 10 NS;
R_L <= '1';
S_R <= '1';
L_A <= '0';
WAIT FOR 10 NS;
--SHIFT LOGIC
R_L <= '0';
S_R <= '0';
L_A <= '0';
WAIT FOR 10 NS;
R_L <= '1';
S_R <= '0';
L_A <= '0';
WAIT FOR 10 NS;
--SHIFT ARITH
R_L <= '0';
S_R <= '0';
L_A <= '1';
WAIT FOR 10 NS;
R_L <= '1';
S_R <= '0';
L_A <= '1';
WAIT;
END PROCESS;

end Behavioral;
