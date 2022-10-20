library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity demuxer42 is
PORT (
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31  downto 0);
C: in std_logic_vector(31  downto 0);
D: in std_logic_vector(31  downto 0);
E: in std_logic_vector(31  downto 0);
F: in std_logic_vector(31  downto 0);
G: in std_logic_vector(31  downto 0);
--control signal
sel: in std_logic_vector(2 downto 0);
--output
MUXB: out std_logic_vector(31  downto 0);
NPC: out std_logic_vector(31  downto 0)

);
end demuxer42;

architecture Behavioral of demuxer42 is
begin
--based on sel some outputs chenge
process(A,B,C,D,E,F,G,sel)
begin
case sel is 
    
    when "000" =>
                    MUXB  <=A  ;
                    NPC <= A;
    when "001" => 
                    MUXB  <=B;   
                    NPC <= A;         
    when "010" => 
                    MUXB  <=C  ; 
                    NPC <= A;
    when "011" => 					-- R31 <-- PC + 4; PC <-- PC + imm26
                    MUXB  <=D  ;
                    NPC <= A;
    when "100" => 
                    MUXB  <=F  ;
                    NPC <= A;
          
    when "101" => 
                    MUXB  <=D;
                    NPC <= E;
                    
     when "110" => 
                    MUXB  <=G;
                    NPC <= A;

	when "111" => 	MUXB  <=D;-- R31 <-- PC + 4,  PC <-- immediate or regb 
                    NPC <= G;
      

    when others =>  
 end case;
 
end process;
end Behavioral;
