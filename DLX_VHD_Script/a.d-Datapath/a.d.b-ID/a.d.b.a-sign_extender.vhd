
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sign_extender_16 is
Port (A: in std_logic_vector(15 downto 0);
	  S_U_ID: in std_logic;
      B: out std_logic_vector(31 downto 0));
end sign_extender_16;

architecture Behavioral of sign_extender_16 is

begin

--it extends the immediate depending if the value is signed or unsigned
process (A,S_U_ID)
BEGIN
IF S_U_ID = '0' then --it extends the MSB
IF (A(15)= '0') then
B <= "0000000000000000"&A;
ELSIF (A(15) = '1') THEN
B <= "1111111111111111"&A;
END IF;
ELSIF S_U_ID = '1' THEN --it introduce zeros into the most significant bits
B <= "0000000000000000"&A;
END IF;
END PROCESS;

end Behavioral;
