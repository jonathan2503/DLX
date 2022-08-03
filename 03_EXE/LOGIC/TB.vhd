----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.08.2022 11:27:28
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

component Logic is
Port ( 
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
s0: in std_logic;
s1: in std_logic;
s2: in std_logic;
s3: in std_logic;
Y: out std_logic_vector(31 downto 0)
);
end component;

SIGNAL A,B,Y: std_logic_vector(31 downto 0);
Signal s0,s1,s2,s3: std_logic;
begin

L: Logic PORT MAP(A,B,s0,s1,s2,s3,Y);

process
begin
A<= "10000000000000000000000000000100";
B<= "00000000000000000000000000000100";

--AND 
s0 <= '0';
s1 <= '0';
s2 <= '0';
s3 <= '1';

WAIT FOR 5 NS;

--NAND 
s0 <= '1';
s1 <= '1';
s2 <= '1';
s3 <= '0';

WAIT FOR 5 NS;

--OR 
s0 <= '0';
s1 <= '1';
s2 <= '1';
s3 <= '1';

WAIT FOR 5 NS;

--NOR 
s0 <= '1';
s1 <= '0';
s2 <= '0';
s3 <= '0';

WAIT FOR 5 NS;

--XOR 
s0 <= '0';
s1 <= '1';
s2 <= '1';
s3 <= '0';

WAIT FOR 5 NS;

--NXOR 
s0 <= '1';
s1 <= '0';
s2 <= '0';
s3 <= '1';
WAIT;
END PROCESS;

end Behavioral;
