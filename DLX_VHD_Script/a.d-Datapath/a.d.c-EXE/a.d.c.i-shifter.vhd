

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shifter is
Port (
A: IN std_logic_vector(31 DOWNTO 0);--valore da shiftare
B: IN std_logic_vector(31 DOWNTO 0);--quanto shiftare il valore
R_L : IN std_logic;--destra o sinistra
L_A: IN std_logic;--logic or arithmetic
S_R: IN std_logic; --shift or rotate
Y: OUT std_logic_vector(31 downto 0)--output
 );
end Shifter;

architecture Behavioral of Shifter is
constant K: INTEGER:= 4;
constant ones: std_logic_vector(31 downto 0):= (others => '1');
constant zeros : std_logic_vector(31 downto 0):= (others => '0');
SIGNAL TO_SHIFT: integer;
begin
--into this signal is saved the amount of the shift
TO_SHIFT <= to_integer(unsigned(B(K downto 0)));

PROCESS(A,B,R_L,L_A,S_R,TO_SHIFT)
BEGIN

IF (S_R = '0') THEN --SHIFT
    IF (L_A = '0') then --LOGIC
        IF ( R_L  = '1') THEN --LEFT
            Y <= A(31 - TO_SHIFT DOWNTO 0) & zeros(31 DOWNTO 32-TO_SHIFT);
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
