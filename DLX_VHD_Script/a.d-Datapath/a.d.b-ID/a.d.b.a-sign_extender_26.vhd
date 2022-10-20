

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sign_extender_26 is
Port (A: in std_logic_vector(25 downto 0);
      B: out std_logic_vector(31 downto 0));
end sign_extender_26;

architecture Behavioral of sign_extender_26 is

begin
--sign extender
process (A)
BEGIN
IF (A(25)= '0') then
B <= "000000"&A;
ELSIF (A(25) = '1') THEN
B <= "111111"&A;
END IF;
END PROCESS;

end Behavioral;

