library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity WB_stage is
Port (
CLK,en5,CTR_MUX: IN std_logic;
ALU_OUTPUT: IN std_logic_vector(31 downto 0);
MEM_OUTPUT: IN std_logic_vector(31 downto 0);
OUTPUT: OUT std_logic_vector(31 downto 0));

end WB_stage;

architecture Behavioral of WB_stage is

COMPONENT MUX21 is
generic(N: integer:=32);
Port (
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
sel: in std_logic;
Y: out std_logic_vector(N-1 downto 0));
end COMPONENT;


component rf 
port (
      RF_i: in  std_logic_vector (31 downto 0);
      en  : in  std_logic ;
      Rf_o: out std_logic_vector (31 downto 0);	
      clk: in std_logic)		;
end component;

signal MEM_RF_out_S: std_logic_vector(31 downto 0) ;
signal alu_RF_out_S: std_logic_vector(31 downto 0) ;

begin
    MEM_RF: rf  
    port MAP  (    RF_i => MEM_OUTPUT ,
                     en  => EN5  ,
                     Rf_o => MEM_RF_out_S  ,	
                     clk => CLK );

    alu_RF: rf  
    port MAP  (    RF_i => ALU_OUTPUT,
                     en  => EN5  ,
                     Rf_o => alu_RF_out_S  ,	
                     clk => CLK );

MUX1: MUX21 PORT MAP (
                        A=> alu_RF_out_S,
                        B=> MEM_RF_out_S ,
                        SEL=>CTR_MUX,
                        Y=> OUTPUT
                        );
end Behavioral;