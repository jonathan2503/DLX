--DOVREBBE IMPIEGARE DUE CICLI DI CLOCK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.log_function.all;


entity decode_stage is
port(
CLK: 		IN std_logic;
RST: 	    IN std_logic;
IR:         IN std_logic_vector(31 downto 0);
--DA IR SI DEDUCONO TUTTE GLI ALTRI INPUT

--CTR SIGNALS IN SLIDES
READ_EN_ONE: 	IN std_logic;
READ_EN_TWO: 	IN std_logic;
WRITE_EN: 		IN std_logic;
ENABLE: 		IN std_logic;

--MY CTR SIGNALS
SEL_IMM:    IN std_logic;--TO SELECT IMM
SEL_RD:    IN std_logic; -- TO SELECT RD
ADD_WB: 	IN std_logic_vector(4 downto 0); --ADDRESS WRITING COMING FROM WB STAGE
PC: 	    IN std_logic_vector(31 downto 0);
DATA_WB: 	IN std_logic_vector(31 downto 0);--DATA IN COMING FROM WB STAGE
NPC: 	    IN std_logic_vector(31 downto 0); -- NEW PROGRAM COUNTER
S_U_ID: 	IN std_logic;


OPCODE: 	OUT std_logic_vector(5 downto 0);
FUNC: 	    OUT std_logic_vector(10 downto 0);
A: 	        OUT std_logic_vector(31 downto 0);
B: 	        OUT std_logic_vector(31 downto 0);
NPC_ID_OUT:  OUT std_logic_vector(31 downto 0); --NPC
IN1:        OUT std_logic_vector(31 downto 0); --PC
IN2: 	    OUT std_logic_vector(31 downto 0); --PROPER IMMEDIATE
RD:         OUT std_logic_vector(4 downto 0);
ADDR_READ_ONE	:OUT std_logic_vector(4 downto 0);
ADDR_READ_TWO	:OUT std_logic_vector(4 downto 0)
);
end decode_stage;



architecture Behavioral of decode_stage is

component register_file is
	generic(
		size_word : integer := 32;
		addr: integer := 5;
		addr_num : integer := 32
	);
	port ( 
		--CONTROL SIGNAL
		CLK			:IN std_logic;
		RESET		:IN std_logic;
		READ_EN_ONE	:IN std_logic;
		READ_EN_TWO	:IN std_logic;
		WRITE_EN	:IN std_logic;
		--GENERAL SIGNAL
		ADDR_READ_ONE	:IN std_logic_vector(addr-1 downto 0);
		ADDR_READ_TWO	:IN std_logic_vector(addr-1 downto 0);
		ADDR_WRITE	:IN std_logic_vector(addr-1 downto 0);
		DATA_WRITE	:IN std_logic_vector(size_word-1 downto 0);
		DATA_OUT_ONE:OUT std_logic_vector(size_word-1 downto 0);
		DATA_OUT_TWO:OUT std_logic_vector(size_word-1 downto 0)
	);
end component; 

component MUX21 is
generic(N: integer:=32);
Port (
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
sel: in std_logic;
Y: out std_logic_vector(N-1 downto 0));
end component;

component REG is
	generic (NBIT:INTEGER);
    Port ( 
		RF_IN: 	IN std_logic_vector(NBIT-1 DOWNTO 0);
		CLK:    IN std_logic;
		RST: 	IN std_logic;
		ENABLE: IN std_logic;
		RF_OUT: OUT std_logic_vector(NBIT-1 DOWNTO 0)
    );
end component;

COMPONENT sign_extender_16 is
Port (A: in std_logic_vector(15 downto 0);
	  S_U_ID: in std_logic;
      B: out std_logic_vector(31 downto 0));
end COMPONENT;


COMPONENT sign_extender_26 is
Port (A: in std_logic_vector(25 downto 0);
      B: out std_logic_vector(31 downto 0));
end COMPONENT;

SIGNAL RD_EXT: std_logic_vector(4 downto 0);
SIGNAL IMM1_EXT, IMM2_EXT,IMM_EXT,OUT1,OUT2: std_logic_vector(31 downto 0);



begin

--Outputs entering into the CU
	OPCODE <= IR(31 downto 26);
	FUNC <= IR(10 downto 0);

-- Registers used to synchronized the output with the clock
	R_NPC:  REG GENERIC MAP(NBIT=>32)
	PORT MAP( 
		RF_IN => PC,
		CLK => CLK,
		RST => RST,
		ENABLE => ENABLE,
		RF_OUT => IN1
	); 

	R_PC:  REG GENERIC MAP(NBIT=>32)
	PORT MAP( 
		RF_IN => NPC,
		CLK => CLK,
		RST => RST,
		ENABLE => ENABLE,
		RF_OUT => NPC_ID_OUT
	); 	



--This component extends the imm16 IR(15 downto 0) to 32 bits
EX1: sign_extender_16 PORT MAP(
                                A => IR(15 downto 0),
				S_U_ID => S_U_ID,
                                B =>IMM1_EXT);
 
--This component extends the imm26 IR(25 downto 0) to 32 bits                               
EX2: sign_extender_26 PORT MAP(
                                A => IR(25 downto 0),
                                B =>IMM2_EXT);  
                        
--one of the two possible rd is selected                                
MUX_1: MUX21 PORT MAP (
                        A=>IMM1_EXT,
                        B=>IMM2_EXT,
                        SEL=>SEL_IMM,
                        Y=> IMM_EXT);
                        


--one of the two imediates is selected
MUX_2: MUX21 GENERIC MAP(N=>5)
             PORT MAP (
                        A=>IR(20 downto 16),
                        B=>IR(15 downto 11),
                        SEL=>SEL_RD,
                        Y=> RD_EXT);     
                                           
		
		

R1:  REG GENERIC MAP(NBIT=>5)
        PORT MAP( 
			RF_IN => RD_EXT,
			CLK => CLK,
			RST => RST,
			ENABLE => ENABLE,
			RF_OUT => RD
		); 
		
                                         
R2: REG GENERIC MAP(NBIT=>32)
        PORT MAP( RF_IN => IMM_EXT,
                  CLK => CLK,
                  RST => RST,
                  ENABLE => ENABLE,
                  RF_OUT => IN2);
                
R3: REG GENERIC MAP(NBIT=>32)
        PORT MAP( RF_IN => OUT1,
                  CLK => CLK,
                  RST => RST,
                  ENABLE => ENABLE,
                  RF_OUT => A);
               
R4: REG GENERIC MAP(NBIT=>32)
        PORT MAP( 
				  RF_IN => OUT2,
                  CLK => CLK,
                  RST => RST,
                  ENABLE => ENABLE,
                  RF_OUT => B
				);
--register file takes the input values from the control signals and from IR           
WR: register_file GENERIC MAP (
					size_word => 32,
					addr => 5,
					addr_num => 32
				)
		        PORT MAP (
					CLK => Clk,
					RESET=>RST,
					READ_EN_ONE=>READ_EN_ONE,
					READ_EN_TWO=>READ_EN_TWO,
					WRITE_EN=>WRITE_EN,
					ADDR_READ_ONE=>IR(25 downto 21), 
					ADDR_READ_TWO => IR(20 downto 16),
					ADDR_WRITE	=> ADD_WB,
					DATA_WRITE	=> DATA_WB,
					DATA_OUT_ONE => OUT1,
					DATA_OUT_TWO => OUT2
				);





	ADDR_READ_ONE <= IR(25 downto 21);	
	ADDR_READ_TWO <= IR(20 downto 16);			
end Behavioral;
