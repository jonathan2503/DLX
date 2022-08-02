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
	IR : IN std_logic_vector(0 to 31);
    --ctrl signals for id
    RF1: 		IN std_logic;
    RF2: 		IN std_logic;
    WF1: 		IN std_logic;
    EN1: 		IN std_logic;
    SEL_IMM:    IN std_logic;--TO SELECT IMM
    SEL_RD:    	IN std_logic; -- TO SELECT RD(2 CHOISES)
	ADD_WR: 	IN std_logic_vector(0 to 4);
	
	CALL: 		IN std_logic;
	RETURN_S: 	IN std_logic;
	FILL:		OUT std_logic;
	SPILL: 		OUT std_logic;
    
    --ctrl signals for exe
    S3_1:    in  std_logic ;
    S3_2:    in  std_logic ;
    ALU1:    in  std_logic ;
    ALU2:    in  std_logic ;
    S3_3:    in  std_logic ;
    en:      in  std_logic ;
    holds:   in  std_logic ;

    --ctrl signals for mem
	en4 :    in  std_logic ;
	s4  :    in  std_logic ;
	w_r4:    in  std_logic ;
    --ctrl signals for wb
    CTR_MUX: IN std_logic;
	TEST_MEM_OUTPUT : IN std_logic_vector(31 downto 0)  --just for test, need to delete final
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

component memory_stage is 
	Port (
	--input from exe
	alu_out:  in  std_logic_vector( 31 downto 0);
	mem_out: in  std_logic_vector( 31 downto 0);
	-- output from stage
	Dout_mem:  OUT  std_logic_vector( 31 downto 0);
	--input from cu
	en4 :    in  std_logic ;
	s4  :    in  std_logic ;
	w_r4:    in  std_logic ;
	clk:    in  std_logic 
);
end component;

component WB_stage is
    Port (
    CLK,RST,CTR_MUX: IN std_logic;
    ALU_OUTPUT: IN std_logic_vector(31 downto 0);
    MEM_OUTPUT: IN std_logic_vector(31 downto 0);
    OUTPUT: OUT std_logic_vector(31 downto 0)
);
    
end component;

SIGNAL S_PC_IN, S_NPC_EXT_1: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
SIGNAL S_PC_OUT, S_IR, S_IR_EXT, S_A, S_B, S_IN_2, S_ALU_OUT,S_ALU_MEMS,S_COND,S_DOUT_MEM,S_WB_OUTPUT : std_logic_vector(31 downto 0);
SIGNAL S_RD : std_logic_vector(4 downto 0);
SIGNAL S_NPC_EXT_2 : std_logic_vector(31 downto 0);
begin 

fs: fetch_stage port map  (
    CLK=>Clk,
	RST=>rst,
	EN_LATCH_PC=>EN_LATCH_PC,
	EN_LATCH_NPC=>EN_LATCH_NPC,
	EN_LATCH_IR=>EN_LATCH_IR,
    PC_IN => S_NPC_EXT_1,
    PC_OUT  => S_PC_OUT,
    IR => IR,
    IR_EXT => S_IR_EXT,
    NPC_EXT => S_NPC_EXT_1
);
id: decode_stage port map (
	CLK => Clk,
    RESET => rst,
    IR => S_IR_EXT,

    RF1 => RF1,
    RF2 => RF2,
    WF1 => WF1,
    EN1 => EN1,
    
  
    SEL_IMM => SEL_IMM,
    SEL_RD => SEL_RD,
    ADD_WR => ADD_WR,
    DATAIN => S_WB_OUTPUT,
    NPC	=> S_NPC_EXT_1,
    
    A => S_A,
    B => S_B,
    IN1 => S_NPC_EXT_2,
    IN2 => S_IN_2,
    RD => S_RD,

    CALL => CALL,
    RETURN_S => RETURN_S,
    FILL => FILL,
    SPILL => SPILL
);

ex: exe_stage port map (
	in1 => S_NPC_EXT_2,
	A => S_A,
	in2 => S_IN_2,
	B => S_B,
	S3_1 => S3_1,
	S3_2 => S3_2,
	ALU1 => ALU1,
	ALU2 => ALU2,
	S3_3 => S3_3,
	en => en,
	holds => holds,
	clk => Clk,

	alu_out => S_ALU_OUT,
	alu_mems => S_ALU_MEMS
);

mem: memory_stage port map (
	alu_out => S_ALU_OUT,
	mem_out => S_ALU_MEMS,
	Dout_mem => S_DOUT_MEM,
	en4 => en4,
	s4 => s4,
	w_r4 => w_r4,
	clk => Clk
);

wb: WB_stage port map (
	CLK => Clk,
	RST => Rst,
	CTR_MUX => CTR_MUX,
    ALU_OUTPUT => S_ALU_OUT,
    MEM_OUTPUT => TEST_MEM_OUTPUT,    --the correct signal is S_DOUT_MEM,but for test, change to TEST_MEM_OUTPUT
    OUTPUT => S_WB_OUTPUT
);

end structural;
