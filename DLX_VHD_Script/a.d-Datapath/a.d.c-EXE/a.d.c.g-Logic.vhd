

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Logic is
Port ( 
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
s0: in std_logic;
s1: in std_logic;
s2: in std_logic;
s3: in std_logic;
Y: out std_logic_vector(31 downto 0)
);
end Logic;

architecture Behavioral of Logic is

component Nand3 is
Port ( 
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
S: in std_logic;
y: out std_logic_vector(31 downto 0)
);
end component;


component Nand3_2 is
Port (
A: IN std_logic_vector(31 DOWNTO 0);
B: IN std_logic_vector(31 DOWNTO 0);
C: IN std_logic_vector(31 DOWNTO 0);
D: IN std_logic_vector(31 DOWNTO 0);
Y: out std_logic_vector(31 DOWNTO 0)

 );
end component;
Signal l0,l1,l2,l3: std_logic_vector(31 downto 0);
signal a_n : std_logic_vector(31 downto 0);
signal b_n : std_logic_vector(31 downto 0);
begin
--same simple logi of the T2 Logic
a_n <= not(a);
b_n <= not(b);
n0: Nand3 PORT MAP(a_n,b_n,s0,l0);
n1: Nand3 PORT MAP(a_n,b,s1,l1);
n2: Nand3 PORT MAP(a,b_n,s2,l2);
n3: Nand3 PORT MAP(a,b,s3,l3);
n4: Nand3_2 PORT MAP(l0,l1,l2,l3,Y);

end Behavioral;
