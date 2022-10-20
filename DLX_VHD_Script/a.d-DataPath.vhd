library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity DataPath is 
	port(
---------------------------------------------
--                INPUT
---------------------------------------------	
	IR_IN:             IN std_logic_vector(31 downto 0);	
	
---------------------------------------------
--                IF STAGE
---------------------------------------------
-- Control unit
	EN_IF:    		IN std_logic;
	SEL_PC : 		IN std_logic;
	PC_EXT_IRAM:  OUT std_logic_vector(31 downto 0);
 ---------------------------------------------
--                ID STAGE
---------------------------------------------
--id stage
	READ_EN_ONE : IN std_logic;
	READ_EN_TWO : IN std_logic;
	WRITE_EN	: IN std_logic;
	ENABLE		: IN std_logic;
	SEL_IMM     : IN std_logic;
	SEL_RD      : IN std_logic;
	S_U_ID		: IN std_logic;
	OPCODE      :OUT std_logic_vector(5 downto 0);
	FUNC        :OUT std_logic_vector(10 downto 0);
	
---------------------------------------------
--               EXE STAGE
---------------------------------------------	
--EXE STAGE
--EN_3 : IN std_logic;
S3_0 : IN std_logic;
S3_1 : IN std_logic;
ADD_SUB : IN std_logic;
flag_en : IN std_logic;
C_EN : IN std_logic;
R_L : IN std_logic;
L_A : IN std_logic;
S_R : IN std_logic;
L_s_cho : IN std_logic_vector(3 downto 0);
z_enab : IN std_logic;
C3 : IN std_logic_vector(2 DOWNTO 0);
SEL42 : IN std_logic_vector(2 DOWNTO 0);
EQ :  IN std_logic;
NE :  IN std_logic; 
j_and_jal: IN std_logic; 
GT: IN std_logic;
LD: IN std_logic;
S_U: IN std_logic;
JUMP_NOTJUMP: OUT std_logic;
---------------------------------------------
--               MEM STAGE
---------------------------------------------
-- mem stage
	s4	:    IN   std_logic_vector(2 downto 0);
	en4 :    IN   std_logic;
	ADRESS_RAM:   OUT  std_logic_vector( 31 downto 0);
	DIN_TO_RAM:   OUT  std_logic_vector( 31 downto 0);	
	DOUT_FROM_RAM: in std_logic_vector( 31 downto 0); --SEGNALE DRAM -> DATAPATH
--	w_r4:    OUT  std_logic; --THIS C.Signal is used externaly from DP
--  en_ram:     OUT  std_logic;--THIS C.Signal is used externaly from DP
---------------------------------------------
--               WB STAGE
---------------------------------------------
	CTR_MUX	:    IN   std_logic;
---------------------------------------------
--                 external
---------------------------------------------
 CLK:            IN std_logic;
 RST:            IN std_logic;
---------------------------------------------
--                 HZ
---------------------------------------------
 HZ_O:             OUT std_logic;
 WRITE_EN_EXE :    IN  std_logic ;
 WRITE_EN_MEM :    IN  std_logic 
	);
end DataPath;
















architecture structural of DataPath is



		

component fetch_stage is
	Port (
		-- Control unit
		CLK:            IN std_logic;
		EN_IF:    		IN std_logic;
		RST:            IN std_logic;
		SEL_PC : 		IN std_logic;
		--INPUT PORT
		PC_IN_IF:             IN std_logic_vector(31 downto 0);
		EXE_NPC_IF:              IN std_logic_vector(31 downto 0);
		IR_IN:                IN std_logic_vector(31 downto 0);
		--OUTPUT PORT
		--ADD_IR :        OUT std_logic_vector(31 downto 0);
		PC_EXT_IRAM: OUT std_logic_vector(31 downto 0);
		PC_EXT :        OUT std_logic_vector(31 downto 0);
		IR_EXT:         OUT std_logic_vector(31 downto 0);
		NPC_EXT:        OUT std_logic_vector(31 downto 0)
		 );
end component;

component decode_stage is
	port(
		CLK: 		IN std_logic;
		RST: 	    IN std_logic;
		IR:         IN std_logic_vector(31 downto 0);
		--CTR SIGNALS IN SLIDES
		READ_EN_ONE: 	IN std_logic;
		READ_EN_TWO: 	IN std_logic;
		WRITE_EN: 		IN std_logic;
		ENABLE: 		IN std_logic;
		
		--MY CTR SIGNALS
		SEL_IMM:    IN std_logic;
		SEL_RD:    IN std_logic; 
		ADD_WB: 	IN std_logic_vector(4 downto 0); 
		PC: 	    IN std_logic_vector(31 downto 0);
		DATA_WB: 	IN std_logic_vector(31 downto 0);
		NPC: 	    IN std_logic_vector(31 downto 0); 
		S_U_ID: 	IN std_logic;
		
		
		OPCODE: 	OUT std_logic_vector(5 downto 0);
		FUNC: 	    OUT std_logic_vector(10 downto 0);
		A: 	        OUT std_logic_vector(31 downto 0);
		B: 	        OUT std_logic_vector(31 downto 0);
		NPC_ID_OUT:  OUT std_logic_vector(31 downto 0); 
		IN1:        OUT std_logic_vector(31 downto 0); 
		IN2: 	    OUT std_logic_vector(31 downto 0); 
		RD:         OUT std_logic_vector(4 downto 0);
		ADDR_READ_ONE	:OUT std_logic_vector(4 downto 0);
        ADDR_READ_TWO	:OUT std_logic_vector(4 downto 0)
		);
end component;


component ExeStage is
	Port (
		--input from ID stage
		in1:  in  std_logic_vector( 31 downto 0);
		A:    in  std_logic_vector( 31 downto 0);
		in2:  in  std_logic_vector( 31 downto 0);
		B:    in  std_logic_vector( 31 downto 0);
		NPC:    in  std_logic_vector( 31 downto 0);
		RD:   in  std_logic_vector( 4 downto 0);
		--input from IF stage
		--input from CU
		RST : in std_logic;  
		--EN_3 : in std_logic;  
		S3_0 : in std_logic;  -- upper mux
		S3_1 : in std_logic;  -- lower mux
		--adder
		ADD_SUB: in std_logic;
		flag_en: in std_logic;-- attiva o disattiva i flag
		C_EN   : in std_logic;--scegli tra leggere il carry oppure no
		--SHIFT
		R_L  :IN std_logic;-- keft or right
		L_A : IN std_logic;--logic or arithmetic
		S_R : IN std_logic; --shift or rotate
		--logic
		L_s_cho:   in  std_logic_vector( 3 downto 0);
		--zero
		z_enab : IN std_logic; --enable the zero detection
		--DEMUX
		C3:    in std_logic_vector(2 DOWNTO 0);
		--FINAL
		SEL42: in std_logic_vector(2 DOWNTO 0);
		--branch
		S_U: IN std_logic; --signed(0) or unsigned(1) numbers
		EQ :  IN std_logic;
		NE :  IN std_logic; 
		j_and_jal: IN std_logic; 
		GT: IN std_logic;
		LD: IN std_logic;
		--external
		clk: in std_logic;
		--out
		JUMP_NOTJUMP: OUT std_logic;
		EXE_ALU_OUT:OUT std_logic_vector( 31 downto 0);
		EXE_MEM_DIN:OUT std_logic_vector( 31 downto 0);
		RD_EXE: OUT std_logic_vector(4 downto 0);
		EXE_NPC_IF:OUT std_logic_vector( 31 downto 0)
		);

end  component;

component memory_stage is 
Port (
		--input from exe
		RST : in  std_logic;
		alu_out:  in  std_logic_vector( 31 downto 0);
		mem_out: in  std_logic_vector( 31 downto 0);
		RD:   in  std_logic_vector( 4 downto 0);
		-- output from stage
		Dout_mem:  OUT  std_logic_vector( 31 downto 0);
		alu_out_ext:  out  std_logic_vector( 31 downto 0);
		RD_EXT_MEM: OUT std_logic_vector(4 downto 0);

		--input/OUTPUT fOR/to RAM
		ADDRESS_RAM:   OUT  std_logic_vector( 31 downto 0);
		DIN_TO_RAM:   OUT  std_logic_vector( 31 downto 0);
		DOUT_FROM_RAM:   in  std_logic_vector( 31 downto 0);
		--input from cu
		s4	:    in  std_logic_vector(2 downto 0);
		en4 :    in  std_logic ;
		clk :    in  std_logic 
);
end component;

component WB_stage is
	Port (
		CLK: IN std_logic;
		RST: IN std_logic;
		CTR_MUX: IN std_logic;
		ALU_OUTPUT: IN std_logic_vector(31 downto 0);
		MEM_OUTPUT: IN std_logic_vector(31 downto 0);
		RD:   in  std_logic_vector( 4 downto 0);
		OUTPUT: OUT std_logic_vector(31 downto 0);
		RD_EXE: OUT std_logic_vector(4 downto 0)
		);
    
end component;

  component HZ
  Port (
  RESET: in std_logic;
  Clk: in std_logic;
  RS_IN_1:   in  std_logic_vector( 4 downto 0);
  RS_IN_2:   in  std_logic_vector( 4 downto 0);
  RD_EXE:     in  std_logic_vector( 4 downto 0);
  RD_MEM:     in  std_logic_vector( 4 downto 0);
  RD_WB :     in  std_logic_vector( 4 downto 0);
  ADD_EN_1_HZ:   in  std_logic;
  ADD_EN_2_HZ:   in  std_logic;
  EN_EXE     :   in  std_logic;
  EN_MEM     :   in  std_logic;
  EN_WB      :   in  std_logic;
  HZ         :   OUT  std_logic
  );
  end component;



---------------------------------------------------------------------------------------------
---                               signal 
---------------------------------------------------------------------------------------













SIGNAL S_NPC_EXT_DP : std_logic_vector(31 downto 0):= (others => '0') ;
SIGNAL S_EXE_ALU_OUT: std_logic_vector( 31 downto 0);
SIGNAL S_EXE_MEM_DIN: std_logic_vector( 31 downto 0);
SIGNAL S_RD_EXE:  std_logic_vector(4 downto 0);
SIGNAL S_EXE_NPC_IF: std_logic_vector( 31 downto 0);
SIGNAL S_Dout_mem : std_logic_vector( 31 downto 0);
SIGNAL s_alu_out_ext_mem: std_logic_vector( 31 downto 0);
SIGNAL s_RD_EXT_MEM:  std_logic_vector(4 downto 0);
SIGNAL S_IR_EXT: std_logic_vector( 31 downto 0);
SIGNAL S_A: 	       std_logic_vector(31 downto 0);
SIGNAL S_B: 	       std_logic_vector(31 downto 0);
SIGNAL S_NPC_ID_OUT:    std_logic_vector(31 downto 0);
SIGNAL S_IN1:          std_logic_vector(31 downto 0); 
SIGNAL S_IN2: 	       std_logic_vector(31 downto 0); 
SIGNAL S_RD:           std_logic_vector(4 downto 0);
--WB
SIGNAL RD_WB:         std_logic_vector(4 downto 0);
SIGNAL S_OUTPUT_WB:   std_logic_vector(31 downto 0);
SIGNAL PC_EXT_DP:     std_logic_vector(31 downto 0);
SIGNAL s_RD_id :      std_logic_vector(4 downto 0);

--HZ

SIGNAL HZ_RS_1 :     std_logic_vector(4 downto 0);
SIGNAL HZ_RS_2 :     std_logic_vector(4 downto 0);







---------------------------------------------------------------------------------------------
---            begin            begin            begin            begin
---------------------------------------------------------------------------------------
--it's important to notice that the input PC_IN_IF and the output NPC_EXT are the same signal
begin 
IF_Stage: fetch_stage
PORT MAP (
		CLK                 => CLK,            
		EN_IF               => EN_IF ,   		 
		RST                 => RST ,           
		SEL_PC              => SEL_PC ,		 
	--INPUT PORT
	    PC_IN_IF            => s_NPC_EXT_DP,             
		EXE_NPC_IF          => S_EXE_NPC_IF,             
		IR_IN               => IR_IN ,             
	--OUTPUT PORT
		PC_EXT_IRAM			=> PC_EXT_IRAM,
		PC_EXT             =>PC_EXT_DP ,        
		IR_EXT             => S_IR_EXT ,         
		NPC_EXT            => s_NPC_EXT_DP     
);



ID_Stage: decode_stage
 port map ( 
	            CLK         => CLK,
                RST         => RST,
                IR          => S_IR_EXT,
				--CU signal 
                READ_EN_ONE => READ_EN_ONE,
                READ_EN_TWO => READ_EN_TWO,
                WRITE_EN    => WRITE_EN,
                ENABLE      => ENABLE,
                SEL_IMM     => SEL_IMM,
                SEL_RD      => SEL_RD,
				S_U_ID      => S_U_ID,
				--Registro
                ADD_WB      => RD_WB,          
                DATA_WB     => S_OUTPUT_WB,
			    PC          => PC_EXT_DP, 
                NPC         => s_NPC_EXT_DP,
				--to control unit
                OPCODE      => OPCODE,
                FUNC        => FUNC,
				--some exit
                A           => s_A,
                B           => s_B,
                NPC_ID_OUT   => s_NPC_ID_OUT,
                IN1         => s_IN1,
                IN2         => s_IN2,
                RD          => s_RD_id,
	ADDR_READ_ONE	=> HZ_RS_1      ,
	ADDR_READ_TWO	=> HZ_RS_2      
				 );


Exe_Stage: ExeStage
                  port map ( in1         => s_IN1 ,
                           A           => s_A ,
                           in2         => s_IN2,
                           B           =>  s_B,
                           RD          => s_RD_id ,
                           RST         => RST,
						   NPC         => s_NPC_ID_OUT,
						   -- CU
                           --EN_3        => EN_3,
                           S3_0        => S3_0,
                           S3_1        => S3_1,
                           ADD_SUB     => ADD_SUB,
                           flag_en     => flag_en,
                           C_EN        => C_EN,
                           R_L         => R_L,
                           L_A         => L_A,
                           S_R         => S_R,
                           L_s_cho     => L_s_cho,
                           z_enab      => z_enab,
                           C3          => C3,
                           SEL42       => SEL42,
                           EQ          => EQ,
                           NE          => NE,
						   GT          =>GT,
                           LD          =>LD,
                           j_and_jal   => j_and_jal,
						   S_U          => S_U ,
						   --  extern
                           clk         => clk,
						   --  OUTPUT
						   JUMP_NOTJUMP => JUMP_NOTJUMP,
                           EXE_ALU_OUT => S_EXE_ALU_OUT,
                           EXE_MEM_DIN => S_EXE_MEM_DIN,
                           RD_EXE      => S_RD_EXE,
                           EXE_NPC_IF  => S_EXE_NPC_IF);


MEM_Stage: memory_stage port map(
						--input from exe
						RST      => RST ,
						alu_out  => S_EXE_ALU_OUT   ,
						mem_out  => S_EXE_MEM_DIN  ,
						RD       =>  S_RD_EXE  ,
	
	
						-- output from stage
	 					Dout_mem     => s_Dout_mem ,
						alu_out_ext  =>  s_alu_out_ext_mem,
						RD_EXT_MEM   => s_RD_EXT_MEM ,
	
	
						--input/OUTPUT fOR RAM
						ADDRESS_RAM=> ADRESS_RAM  ,
						DIN_TO_RAM=> DIN_TO_RAM  ,
						DOUT_FROM_RAM=> DOUT_FROM_RAM,
						--input from cu
						s4 => s4,
						en4 =>  EN4    ,
						clk =>   clk    
	);


WBB_Stage: WB_stage port map ( 
	                       CLK        => CLK,
                           RST        => RST,
						   --CU
                           CTR_MUX    => CTR_MUX,
						   --OUTPUT
                           ALU_OUTPUT =>  s_alu_out_ext_mem,
                           MEM_OUTPUT =>  s_Dout_mem,
                           RD         =>  s_RD_EXT_MEM ,
                           OUTPUT     =>  S_OUTPUT_WB,
                           RD_EXE     =>  RD_WB );
 

DHZ: HZ port map (   RESET=> RST,
					 CLK => CLK,
	                 RS_IN_1  =>  HZ_RS_1          ,
					 RS_IN_2  =>  HZ_RS_2         ,
                     RD_WB    =>  s_RD_EXT_MEM,
                     RD_EXE   =>  s_RD_id,
                     RD_MEM   =>  S_RD_EXE,
                     HZ       =>  HZ_O,
					 --CU
					ADD_EN_1_HZ=> READ_EN_ONE ,
					ADD_EN_2_HZ=>READ_EN_TWO  ,
					EN_MEM  => WRITE_EN_MEM  ,
					EN_EXE  => WRITE_EN_EXE ,
					EN_WB   => WRITE_EN  
					 );




end structural;
