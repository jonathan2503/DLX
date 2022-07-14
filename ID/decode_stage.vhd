
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.log_function.all;


entity decode_stage is
port(
CLK: 		IN std_logic;
RESET: 	    IN std_logic;


IR:         IN std_logic_vector(31 downto 0);
--DA IR SI DEDUCONO TUTTE GLI ALTRI INPUT

--CTR SIGNALS IN SLIDES
RF1: 		IN std_logic;
RF2: 		IN std_logic;
WF1: 		IN std_logic;
EN1: 		IN std_logic;

--MY CTR SIGNALS
SEL_IMM:    IN std_logic;--TO SELECT IMM
SEL_RD:    IN std_logic; -- TO SELECT RD(2 CHOISES)
ADD_WR: 	IN std_logic_vector(4 downto 0); --ADDRESS WRITING COMING FROM WB STAGE
DATAIN: 	IN std_logic_vector(31 downto 0);--DATA IN COMING FROM WB STAGE
NPC: 	    IN std_logic_vector(31 downto 0); -- NEW PROGRAM COUNTER

A: 	        OUT std_logic_vector(31 downto 0);
B: 	        OUT std_logic_vector(31 downto 0);
IN1: 	    OUT std_logic_vector(31 downto 0); --NPC
IN2: 	    OUT std_logic_vector(31 downto 0); --PROPER IMMEDIATE
RD:         OUT std_logic_vector(4 downto 0);

CALL: 		IN std_logic;
RETURN_S: 	IN std_logic;
FILL:	OUT std_logic;
SPILL: OUT std_logic

);
end decode_stage;

architecture Behavioral of decode_stage is

component windowed_rf is
generic (M: natural := 8; --number of global
		 N: natural := 8; --number of in/out/local
         F: natural := 4;	--number of windows
		 NBIT : natural := 64);

 port ( 
	 CLK: 		IN std_logic;
     RESET: 	IN std_logic;
	 ENABLE: 	IN std_logic;
	 RD1: 		IN std_logic;
	 RD2: 		IN std_logic;
	 WR: 		IN std_logic; 
	 
	 ADD_WR: 	IN std_logic_vector(log2(N * 3 + M)-1 downto 0); 
	 ADD_RD1: 	IN std_logic_vector(log2(N * 3 + M)-1 downto 0);
	 ADD_RD2: 	IN std_logic_vector(log2(N * 3 + M)-1 downto 0);
	 DATAIN: 	IN std_logic_vector(NBIT-1 downto 0);
     OUT1: 		OUT std_logic_vector(NBIT-1  downto 0);
	 OUT2: 		OUT std_logic_vector(NBIT-1  downto 0);
	
	CALL: 		IN std_logic;
	 RETURN_S: 	IN std_logic;
	FILL:	OUT std_logic;
	SPILL: OUT std_logic);
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
    Generic(NBIT: integer);
	Port  ( 
	    D:	IN	std_logic_vector(NBIT-1 downto 0);
		CK:	IN	std_logic;
		EN : IN std_logic;
		RESET:	IN	std_logic;
		Q:	OUT	std_logic_vector(NBIT-1 downto 0));
end component;

COMPONENT sign_extender_16 is
Port (A: in std_logic_vector(15 downto 0);
      B: out std_logic_vector(31 downto 0));
end COMPONENT;


COMPONENT sign_extender_26 is
Port (A: in std_logic_vector(25 downto 0);
      B: out std_logic_vector(31 downto 0));
end COMPONENT;

SIGNAL RD_EXT: std_logic_vector(4 downto 0);
SIGNAL IMM1_EXT, IMM2_EXT,IMM_EXT,OUT1,OUT2: std_logic_vector(31 downto 0);



begin
IN1 <= NPC;


EX1: sign_extender_16 PORT MAP(
                                A => IR(31 DOWNTO 16),
                                B =>IMM1_EXT);
                                
EX2: sign_extender_26 PORT MAP(
                                A => IR(31 DOWNTO 6),
                                B =>IMM2_EXT);                          
                                
MUX_1: MUX21 PORT MAP (
                        A=>IMM1_EXT,
                        B=>IMM2_EXT,
                        SEL=>SEL_IMM,
                        Y=> IMM_EXT);
                        
MUX_2: MUX21 GENERIC MAP(N=>5)
             PORT MAP (
                        A=>IR(15 DOWNTO 11),
                        B=>IR(20 DOWNTO 16),
                        SEL=>SEL_RD,
                        Y=> RD_EXT);     
                                           
                        
R1: REG GENERIC MAP(NBIT=>4)
        PORT MAP( D => RD_EXT,
                  CK => CLK,
                  EN => EN1,
                  RESET => RESET,
                  Q => RD); 
                                         
R2: REG GENERIC MAP(NBIT=>32)
        PORT MAP( D => IMM_EXT,
                  CK => CLK,
                  EN => EN1,
                  RESET => RESET,
                  Q => IN2);
                
R3: REG GENERIC MAP(NBIT=>32)
        PORT MAP( D => OUT1,
                  CK => CLK,
                  EN => EN1,
                  RESET => RESET,
                  Q => A);
               
R4: REG GENERIC MAP(NBIT=>32)
        PORT MAP( D => OUT2,
                  CK => CLK,
                  EN => EN1,
                  RESET => RESET,
                  Q => B);
           
WR: windowed_rf GENERIC MAP (
                                M=> 8,
		                        N=>8,
                                F=> 4,
		                        NBIT=>64)
		        PORT MAP (
	CLK => CLK,
     RESET=>RESET,
	 ENABLE=>EN1,
	 RD1=>RF1,
	 RD2=>RF2,
	 WR=>WF1,
	 ADD_WR=>ADD_WR, 
	 ADD_RD1 => IR(10 DOWNTO 6),
	 ADD_RD2 => IR(15 DOWNTO 11),
	 DATAIN => DATAIN,
     OUT1 => OUT1,
	 OUT2 => OUT2,
	
	CALL => CALL,
	RETURN_S => RETURN_S,
	FILL	=> FILL,
	SPILL      => SPILL);
                  

end Behavioral;
