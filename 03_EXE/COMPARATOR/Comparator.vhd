
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Comparator is
Port ( 
SLE_SGE: IN std_logic; -- '0' ->LE , '1'->GE
SEQ_SNE: IN std_logic; -- '0' ->EQ , '1' ->NE

-- 4 operations -> 2 ctrl signals
CTR1: IN std_logic; 
CTR2: IN std_logic;

Y: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);

end Comparator;

architecture Behavioral of Comparator is
component MUX21 is
generic(N: integer:=32);
Port (
A: in std_logic;
B: in std_logic;
sel: in std_logic;
Y: out std_logic);
end component;

Signal s0: std_logic;
begin
--ctr1, ctr2 ->LE           ---> NOT(SLE_SGE)
--ctr1,not(ctr2) ->GE       ---> SLE_SGE
--not(ctr1),ctr2 ->EQ       ---> NOT(SEQ_SNE)
--not(ctr1),not(ctr2) ->NE  ---> SEQ_SNE

Y <= (OTHERS => '0');
m1: MUX21 PORT MAP (SEQ_SNE,SLE_SGE,CTR1,s0); 
m2: MUX21 PORT MAP (not(s0),s0, CTR2,Y(0)); 

end Behavioral;
