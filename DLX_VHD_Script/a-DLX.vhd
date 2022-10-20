library ieee;
use ieee.std_logic_1164.all;


entity DLX2 is  
  generic (IRAM_SIZE: integer:=32);
  port (
    Clk : in std_logic;
    Rst : in std_logic;
	Addr_to_IRAM: out std_logic_vector(IRAM_SIZE - 1 downto 0);
	Data_from_IRAM: IN std_logic_vector(IRAM_SIZE - 1 downto 0);
	ADDR_to_RAM:  out std_logic_vector(31 downto 0);
  	Data_from_RAM:	in	std_logic_vector(31  downto 0);
  	Data_to_RAM:	out	std_logic_vector(31  downto 0);
  	w_r:	out	std_logic;
  	en_ram:    out  std_logic );               
end DLX2;


architecture dlx_rtl of DLX2 is







  component cu_stage is
    port(
      Clk: IN std_logic;
      RESET: IN std_logic;
      OPCODE : IN std_logic_vector(5 downto 0);
      FUNC : IN std_logic_vector(10 downto 0);
      HZ   : IN std_logic;
	  JUMP_NOTJUMP	: IN std_logic;
      --if stage --2
      EN_IF : OUT std_logic;
      SEL_PC : OUT std_logic;
      --id stage --5
      READ_EN_ONE : OUT std_logic;
      READ_EN_TWO : OUT std_logic;
      
      ENABLE		: OUT std_logic;
      SEL_IMM : OUT std_logic;
      SEL_RD : OUT std_logic;
	  S_U_ID:OUT std_logic;
      
      --EXE STAGE --24
      S3_0 : OUT std_logic;
      S3_1 : OUT std_logic;
      ADD_SUB : OUT std_logic;
      flag_en : OUT std_logic;
      C_EN : OUT std_logic;
      R_L : OUT std_logic;
      L_A : OUT std_logic;
      S_R : OUT std_logic; --16
      L_s_cho : OUT std_logic_vector(3 downto 0); --20
      z_enab : OUT std_logic; --21
      C3 : OUT std_logic_vector(2 DOWNTO 0); --24
      SEL42 : OUT std_logic_vector(2 DOWNTO 0);--27
      EQ :  OUT std_logic; 
      NE :  OUT std_logic; 
      j_and_jal: OUT std_logic; --30
      GT: OUT std_logic;
      LD: OUT std_logic;
      S_U :OUT std_logic;
      -- mem stage --3
	  s4: OUT std_logic_vector(2 downto 0);
      en4 :    OUT  std_logic;
      w_r4:    OUT  std_logic;
      en_ram:    OUT  std_logic;
      --wb stage --2
      CTR_MUX	:    OUT  std_logic;
      WRITE_EN	: OUT std_logic;
      WRITE_EN_EXE :    OUT  std_logic ;
      WRITE_EN_MEM :    OUT  std_logic 
      
    );
  end component; 



  component DataPath 
  port(
  IR_IN:             IN std_logic_vector(31 downto 0);
  EN_IF:    		IN std_logic;
  SEL_PC : 		IN std_logic;
  PC_EXT_IRAM:  OUT std_logic_vector(31 downto 0);
  READ_EN_ONE : IN std_logic;
  READ_EN_TWO : IN std_logic;
  WRITE_EN	: IN std_logic;
  ENABLE		: IN std_logic;
  SEL_IMM     : IN std_logic;
  SEL_RD      : IN std_logic;
  S_U_ID	  :IN std_logic;
  OPCODE      :OUT std_logic_vector(5 downto 0);
  FUNC        :OUT std_logic_vector(10 downto 0);
	
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
s4: IN std_logic_vector(2 downto 0);
  en4 :    IN   std_logic;
  ADRESS_RAM:   OUT  std_logic_vector( 31 downto 0);
  DIN_TO_RAM:   OUT  std_logic_vector( 31 downto 0);	
  DOUT_FROM_RAM: in std_logic_vector( 31 downto 0);
  CTR_MUX	:    IN   std_logic;
 CLK:            IN std_logic;
 RST:            IN std_logic;
 HZ_O:             OUT std_logic;
 WRITE_EN_EXE :    IN  std_logic ;
 WRITE_EN_MEM :    IN  std_logic 
  );
end component;

----------------------------------------------------------------
--   SIGNAL   SIGNAL    SIGNAL    SIGNAL    SIGNAL    SIGNAL  
---------------------------------------------------------------- 









--DATAPATH - CU_STAGE
CONSTANT I_SIZE : INTEGER := 32;
signal EN_IF: std_logic;
signal SEL_PC: std_logic;
signal READ_EN_ONE: std_logic;
signal READ_EN_TWO: std_logic;
signal WRITE_EN: std_logic;
signal ENABLE: std_logic;
signal S_U_ID: std_logic;
signal SEL_IMM: std_logic;
signal SEL_RD: std_logic;
signal OPCODE: std_logic_vector(5 downto 0);
signal FUNC: std_logic_vector(10 downto 0);
--signal EN_3: std_logic;
signal S3_0: std_logic;
signal S3_1: std_logic;
signal ADD_SUB: std_logic;
signal flag_en: std_logic;
signal C_EN: std_logic;
signal R_L: std_logic;
signal L_A: std_logic;
signal S_R: std_logic;
signal L_s_cho: std_logic_vector(3 downto 0);
signal z_enab: std_logic;
signal C3: std_logic_vector(2 DOWNTO 0);
signal SEL42: std_logic_vector(2 DOWNTO 0);
signal EQ: std_logic;
signal NE: std_logic;
signal j_and_jal: std_logic;
signal GT: std_logic;
signal LD: std_logic;
signal S_U: std_logic;
signal s4: std_logic_vector(2 DOWNTO 0);
signal en4: std_logic;
signal CTR_MUX: std_logic;


signal JUMP_NOTJUMP :     std_logic ;
--WHit s
signal S_IR_IN:      std_logic_vector(31 downto 0);
signal S_ADRESS_RAM: std_logic_vector( 31 downto 0);
signal S_DIN_TO_RAM: std_logic_vector( 31 downto 0);
signal S_DIN_FROM_RAM: std_logic_vector( 31 downto 0);
signal S_ir_OPCODE:     std_logic_vector(5 downto 0);  ---THIS IS USED  FOR  DATA HZ DETECTION
signal S_ir_FUNC:       std_logic_vector(10 downto 0);  ---THIS IS USED FOR DATA HZ DETECTIONù



-- DATAPATH/CU -> DRAM
SIGNAL hz_wire :         std_logic;
signal WRITE_EN_EXE :    std_logic ;
signal WRITE_EN_MEM :     std_logic ;



signal CLK_IRAM: std_logic;



----------------------------------------------------------------
--    Begin          Begin         Begin            Begin 
---------------------------------------------------------------- 
begin
 



    DP_C: DataPath port map ( 
                           IR_IN       => Data_from_IRAM, ---CONNECTED TO IRAM
                           EN_IF       => EN_IF,
                           SEL_PC      => SEL_PC,
                           READ_EN_ONE => READ_EN_ONE,
                           READ_EN_TWO => READ_EN_TWO,
                           WRITE_EN    => WRITE_EN,
                           ENABLE      => ENABLE,
                           SEL_IMM     => SEL_IMM,
                           SEL_RD      => SEL_RD,
						   S_U_ID	   => S_U_ID,
                           OPCODE      => OPCODE,
                           FUNC        => FUNC,
                           --EN_3        => EN_3,
                           DOUT_FROM_RAM => DATA_FROM_RAM, --SEGNALE DRAM -> DATAPATH
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
                           j_and_jal   => j_and_jal,
                           GT          => GT,
                           LD          => LD,
                           S_U         => S_U,
						   s4 		   => s4,
                           en4         => en4,
                           CTR_MUX     => CTR_MUX,
                           CLK         => CLK,
                           RST         => RST,
                           ADRESS_RAM  => ADDR_to_RAM,  --ADDRESS DATAPATH -> DRAM
                           DIN_TO_RAM  => DATA_TO_RAM ,  --SEGNALE DATAPATH -> DRAM        
						   PC_EXT_IRAM => ADDR_TO_IRAM ,--CONNECTED TO IRAM
                           HZ_O        =>  hz_wire,
                           WRITE_EN_EXE  =>  WRITE_EN_EXE        ,
                            WRITE_EN_MEM  => WRITE_EN_MEM,
							JUMP_NOTJUMP => JUMP_NOTJUMP
                            );


 
 


CU_C: cu_stage port map ( 
                           Clk          => Clk,
                           RESET       => RST,
                           OPCODE      => OPCODE, 
                           FUNC        => FUNC,   
                           EN_IF       => EN_IF,
                           SEL_PC      => SEL_PC,
                           READ_EN_ONE => READ_EN_ONE,
                           READ_EN_TWO => READ_EN_TWO,
                           ENABLE      => ENABLE,
						   S_U_ID	   => S_U_ID,
                           SEL_IMM     => SEL_IMM,
                           SEL_RD      => SEL_RD,
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
                           j_and_jal   => j_and_jal,
                           GT          => GT,
                           LD          => LD,
                           S_U         => S_U,
						   s4 		   => s4,
                           en4         => en4,
                           w_r4        => w_r,
                           CTR_MUX     => CTR_MUX,
                           WRITE_EN    => WRITE_EN,
                           HZ          =>  hz_wire  ,
                           WRITE_EN_EXE  =>  WRITE_EN_EXE        ,
                           WRITE_EN_MEM  =>  WRITE_EN_MEM  ,
                           en_ram  => en_ram,
							JUMP_NOTJUMP => JUMP_NOTJUMP
                            );

  end dlx_rtl;
