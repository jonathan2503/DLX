library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity demuxer21 is
PORT (
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31  downto 0);
--control signal
sel: in std_logic_vector(2 downto 0);
--output
to_adder: out std_logic_vector(31  downto 0);
to_twocmp: out std_logic_vector(31  downto 0);
to_A_logic: out std_logic_vector(31  downto 0);
to_B_logic: out std_logic_vector(31  downto 0);
to_A_shifter: out std_logic_vector(31  downto 0);
to_B_shifter: out std_logic_vector(31  downto 0);
R31_PC: out std_logic_vector(31  downto 0)
);
end demuxer21;


--based on sel some outputs change
architecture Behavioral of demuxer21 is
begin
process(A,B,sel)
begin
case sel is 
    
    when "000" =>to_adder  <=A  ;
                 to_twocmp <=B ;
    when "001" => 
                 to_A_logic  <=A  ;
                 to_B_logic <=B ; 
    when "010" => 
				 to_A_shifter  <=A  ;
                 to_B_shifter  <=B ; 
    when "011" => 
                 to_adder   <=A  ;
                 to_twocmp   <=B ; 
                 R31_PC      <=A ;

    when others =>  
 end case;
 
end process;
end Behavioral;
