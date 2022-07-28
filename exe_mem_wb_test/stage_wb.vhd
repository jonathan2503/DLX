library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity WB_stage is
Port (
CLK: IN std_logic;
en5: IN std_logic;
CTR_MUX: IN std_logic;
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
signal WIRE: std_logic_vector(31 downto 0) ;
signal MIDD: std_logic_vector(31 downto 0) ;

begin


MUX1: MUX21 PORT MAP (
                        A=> ALU_OUTPUT,
                        B=> MEM_OUTPUT ,
                        SEL=>CTR_MUX,
                        Y=> WIRE
                        );

MEM_RF0: rf  
port MAP  (    RF_i => WIRE ,
               en  => EN5  ,
               Rf_o => OUTPUT ,	
               clk => CLK );


end Behavioral;