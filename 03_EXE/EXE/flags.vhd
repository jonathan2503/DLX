----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.08.2022 15:33:18
-- Design Name: 
-- Module Name: Flags_Generator - Behavioral
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

entity Flags is
port ( 

C: in std_logic; --cary in
Z: in std_logic; --zero

c0:      in std_logic; --GE
c1:      in std_logic; --GT
c2:      in std_logic; --LE
c3:      in std_logic; --LT
c4:      in std_logic; --EQ
c5:      in std_logic; --NE
Comp_out: out std_logic_vector(31 downto 0)
);
end Flags;

architecture Behavioral of Flags is

begin


Comp_out(1) <='0';
Comp_out(2) <='0';
Comp_out(3) <='0';
Comp_out(4) <='0';
Comp_out(5) <='0';
Comp_out(6) <='0';
Comp_out(6) <='0';
Comp_out(7) <='0';
Comp_out(8) <='0';
Comp_out(9) <='0';
Comp_out(10) <='0';
Comp_out(11) <='0';
Comp_out(12) <='0';
Comp_out(13) <='0';
Comp_out(14) <='0';
Comp_out(15) <='0';
Comp_out(16) <='0';
Comp_out(17) <='0';
Comp_out(18) <='0';
Comp_out(19) <='0';
Comp_out(20) <='0';
Comp_out(21) <='0';
Comp_out(22) <='0';
Comp_out(23) <='0';
Comp_out(24) <='0';
Comp_out(25) <='0';
Comp_out(26) <='0';
Comp_out(27) <='0';
Comp_out(28) <='0';
Comp_out(29) <='0';
Comp_out(30) <='0';
Comp_out(31) <='0';
Comp_out(0) <= (c0 and (C or Z)) or (c1 and not(Z) and C) or (c2 and (not(C) or Z)) or (c3 and not(c0) and not(z))
    or (c4 and Z) or (c5 and not(Z)); 
end Behavioral;
