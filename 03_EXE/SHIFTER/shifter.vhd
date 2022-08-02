

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shifter is
Port (
A: IN std_logic_vector(31 DOWNTO 0);--value to shift
B: IN std_logic_vector(31 DOWNTO 0);--how much to shift
R_L : IN std_logic;--right->0, left->1
L_A: IN std_logic;--logic->0, arithmetic->1
S_R: IN std_logic; --shift->0, rotate->1
Y: OUT std_logic_vector(31 downto 0)--output
 );
end Shifter;

architecture Behavioral of Shifter is
constant K: INTEGER:= 5;
constant ones: std_logic_vector(31 downto 0):= (others => '1');
constant zeros : std_logic_vector(31 downto 0):= (others => '0');

begin



PROCESS(A,B,R_L,L_A,S_R)
variable TO_SHIFT: INTEGER;
BEGIN
TO_SHIFT := to_integer(unsigned(B(K downto 0)));
IF (S_R = '0') THEN --SHIFT

    IF (L_A = '0') then --LOGIC
        IF ( R_L  = '1') THEN --LEFT
            Y <= A(31 - TO_SHIFT DOWNTO 0) & zeros(31 DOWNTO 32- TO_SHIFT);
        ELSIF ( R_L  = '0') THEN --RIGHT
            Y <= zeros(TO_SHIFT - 1 DOWNTO 0) & A(31 DOWNTO TO_SHIFT);
        END IF;
        
        
    ELSIF (L_A = '1') THEN --ARITHMETIC 
    
        IF ( R_L  = '1') THEN --LEFT
            Y <= A(31 - TO_SHIFT DOWNTO 0) & zeros(31 DOWNTO 32- TO_SHIFT);
        ELSIF ( R_L  = '0') THEN --RIGHT
        
             IF (A(31)= '1') THEN
                Y <= ones(TO_SHIFT - 1 DOWNTO 0) & A(31 DOWNTO TO_SHIFT);
             ELSIF (A(31)='0') then
                Y <= zeros(TO_SHIFT - 1 DOWNTO 0) & A(31 DOWNTO TO_SHIFT);
             END IF;
        END IF;
   END IF;
    


ELSIF (S_R = '1') THEN --ROTATE

    IF (R_L = '0') THEN --LEFT
        Y <= A(31 - TO_SHIFT DOWNTO 0) & A(31 DOWNTO 32- TO_SHIFT);
    ELSIF (R_L = '1') THEN --RIGHT
        Y <= A(TO_SHIFT - 1 DOWNTO 0) & A(31 DOWNTO TO_SHIFT); 
    END IF;
    
END IF;
END PROCESS;

end Behavioral;
