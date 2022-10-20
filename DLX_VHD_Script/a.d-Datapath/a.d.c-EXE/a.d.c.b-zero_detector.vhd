

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity zero_detector is
Port (
x : in std_logic_vector(31 downto 0);
en: IN std_logic;
Z : out std_logic
 );
end zero_detector;

architecture Behavioral of zero_detector is

begin

process(x,en)
variable k: std_logic;
begin
IF (en= '0') then
Z <= '0';
else
k := '0';
for i in 0 to 31 loop
k := k or X(i);
end loop;
Z <= not (K);
end if;
end process;

end Behavioral;
