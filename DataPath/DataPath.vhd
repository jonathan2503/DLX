library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity DataPath is 
    port(
    Clk: in std_logic;
    Rst: in std_logic;

    --ctrl signals for if
    EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: in std_logic;

    --ctrl signals for id
    RF1: 		IN std_logic;
    RF2: 		IN std_logic;
    WF1: 		IN std_logic;
    EN1: 		IN std_logic;
    SEL_IMM:    IN std_logic;--TO SELECT IMM
    SEL_RD:    IN std_logic; -- TO SELECT RD(2 CHOISES)
    
    --ctrl signals for exe
    S3_1:    in  std_logic ;
    S3_2:    in  std_logic ;
    ALU1:    in  std_logic ;
    ALU2:    in  std_logic ;
    S3_3:    in  std_logic ;
    en:      in  std_logic ;
    holds:   in  std_logic ;

    --ctrl signals for mem
    --ctrl signals for wb
    CTR_MUX: IN std_logic;

    );
end DataPath;

architecture structural of DataPath is

component fetch_stage is
    Port (
    CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: IN std_logic;
    PC_IN: IN std_logic_vector(31 downto 0);
    PC_OUT : out std_logic_vector(31 downto 0);
    IR: in std_logic_vector(31 downto 0);
    IR_EXT: OUT std_logic_vector(31 downto 0);
    NPC_EXT: OUT std_logic_vector(31 downto 0)
     );
end component;

component decode_stage is
    port(
    CLK: 		IN std_logic;
    RESET: 	    IN std_logic;
    
    
    IR:         IN std_logic_vector(0 TO 31);

    RF1: 		IN std_logic;
    RF2: 		IN std_logic;
    WF1: 		IN std_logic;
    EN1: 		IN std_logic;
    
  
    SEL_IMM:    IN std_logic;--TO SELECT IMM
    SEL_RD:    IN std_logic; -- TO SELECT RD(2 CHOISES)
    ADD_WR: 	IN std_logic_vector(0 to 4); --ADDRESS WRITING COMING FROM WB STAGE
    DATAIN: 	IN std_logic_vector(0 to 31);--DATA IN COMING FROM WB STAGE
    NPC: 	    IN std_logic_vector(0 to 31); -- NEW PROGRAM COUNTER
    
    A: 	        OUT std_logic_vector(0 to 31);
    B: 	        OUT std_logic_vector(0 to 31);
    IN1: 	    OUT std_logic_vector(0 to 31); --NPC
    IN2: 	    OUT std_logic_vector(0 to 31); --PROPER IMMEDIATE
    RD:         OUT std_logic_vector(0 to 4);
    
    CALL: 		IN std_logic;
    RETURN_S: 	IN std_logic;
    FILL:	OUT std_logic;
    SPILL: OUT std_logic
    
    );
end component;


component exe_stage is

port (
--input from ID stage
in1:  in  std_logic_vector( 31 downto 0);
A:    in  std_logic_vector( 31 downto 0);
in2:  in  std_logic_vector( 31 downto 0);
B:    in  std_logic_vector( 31 downto 0);
--input from CU
S3_1:    in  std_logic ;
S3_2:    in  std_logic ;
ALU1:    in  std_logic ;
ALU2:    in  std_logic ;
S3_3:    in  std_logic ;
en:      in  std_logic ;
holds:   in  std_logic ;
clk:     in  std_logic ;


-- output from stage
alu_out:  OUT  std_logic_vector( 31 downto 0) ;
alu_mems:  OUT  std_logic_vector( 31 downto 0)
    );
end  component;



component WB_stage is
    Port (
    CLK,RST,CTR_MUX: IN std_logic;
    ALU_OUTPUT: IN std_logic_vector(31 downto 0);
    MEM_OUTPUT: IN std_logic_vector(31 downto 0);
    OUTPUT: OUT std_logic_vector(31 downto 0));
    
end component;

begin 

fs: fetch_stage port map  (
    CLK=>Clk,RST=>rst,EN_LATCH_PC=>EN_LATCH_PC,EN_LATCH_NPC=>EN_LATCH_NPC,EN_LATCH_IR=>EN_LATCH_IR,

    PC_IN: IN std_logic_vector(31 downto 0);
    PC_OUT : out std_logic_vector(31 downto 0);
    IR: in std_logic_vector(31 downto 0);
    IR_EXT: OUT std_logic_vector(31 downto 0);
    NPC_EXT: OUT std_logic_vector(31 downto 0)
     );   



end structural;
