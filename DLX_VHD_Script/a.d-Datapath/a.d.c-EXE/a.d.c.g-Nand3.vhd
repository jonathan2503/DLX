


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



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
