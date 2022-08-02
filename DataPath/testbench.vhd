library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
end testbench;

architecture Behavioral of testbench is

component DataPath is
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
    SEL_RD:    IN std_logic; -- TO SELECT RD(2 CHOISES)
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
	TEST_MEM_OUTPUT : IN std_logic_vector(31 downto 0) --just for test, need to delete final
    );
end component;


--control signal
SIGNAL Clk,Rst,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR,RF1,RF2,WF1,EN1,SEL_IMM,SEL_RD,CALL,RETURN_S,FILL,SPILL,S3_1,S3_2,ALU1,ALU2,S3_3,en,holds,en4,s4,w_r4,CTR_MUX : std_logic;
--data signal
SIGNAL S_IR,S_TEST_MEM_OUTPUT : std_logic_vector(31 downto 0);
SIGNAL S_ADD_WR : std_logic_vector(4 downto 0);
constant CLOCKPERIOD : TIME := 10 NS;
begin
DP : DataPath PORT MAP (
	Clk => Clk,
	Rst => Rst,
	EN_LATCH_PC => EN_LATCH_PC,
	EN_LATCH_NPC => EN_LATCH_NPC,
	EN_LATCH_IR => EN_LATCH_IR,
	IR => S_IR,
	RF1 => RF1,
	RF2 => RF2,
	WF1 => WF1,
	EN1 => EN1,
	SEL_IMM => SEL_IMM,
	SEL_RD => SEL_RD,
	ADD_WR => S_ADD_WR,
	CALL => CALL,
	RETURN_S => RETURN_S,
	FILL => FILL,
	SPILL => SPILL,
	
	S3_1 => S3_1,
	S3_2 => S3_2,
	ALU1 => ALU1,
	ALU2 => ALU2,
	S3_3 => S3_3,
	en => en,
	holds => holds,
	
	en4 => en4,
	s4 => s4,
	w_r4 => w_r4,
	CTR_MUX => CTR_MUX,
	TEST_MEM_OUTPUT => S_TEST_MEM_OUTPUT
);

process
begin
Clk <= '1';
WAIT FOR CLOCKPERIOD/2;
Clk <= '0';
WAIT FOR CLOCKPERIOD/2;
END PROCESS;

process
begin
RST<= '1';
WAIT FOR CLOCKPERIOD;
RST<= '0';
--initial data
S_IR <= (OTHERS =>'0');
RF1<='0';
RF2<='0';
SEL_IMM<= '0';
SEL_RD<='0';

WF1<='1';
EN1<='1';
CTR_MUX <= '1';
EN_LATCH_PC<='1';EN_LATCH_NPC<='1';EN_LATCH_IR<='1';
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR CLOCKPERIOD;

S_ADD_WR <= "00001";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "00010";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "00011";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "00100";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "00101";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "00110";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "00111";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "01000";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "01001";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "01010";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "01011";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "01100";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "01101";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "01110";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "01111";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "10000";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "10001";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "10010";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "10011";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "10100";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "10101";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "10110";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "10111";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "11000";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "11001";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "11010";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "11011";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "11100";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "11101";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;
S_ADD_WR <= "11110";
S_TEST_MEM_OUTPUT <= "00000000000000000000000000000001";
WAIT FOR 10 NS;


	--1th cycle
		--CONTROL SIGNAL
		--1th
		
		--2th
		CALL <= '0';RETURN_S <= '0';
		WF1<='0';RF1<='0';
		--3th
		S3_1 <= '0';S3_2 <= '0';ALU1 <= '0';ALU2 <= '0';S3_3 <= '0';en <= '0';holds <= '0';  
		--4th
		en4 <= '0';s4 <= '0';w_r4 <= '0';
		--5th
		CTR_MUX <= '0';
		--DATA SIGNAL
		S_IR <= "10000100001000100001100100100111";
		WAIT FOR CLOCKPERIOD;
	--2th cycle
		--CONTROL SIGNAL
		--1th
		--EN_LATCH_PC<='1';EN_LATCH_NPC<='1';EN_LATCH_IR<='1';
		--2th
		WF1<='0';RF1<='1';RF2<='1';
		--3th
		S3_1 <= '0';S3_2 <= '0';ALU1 <= '0';ALU2 <= '0';S3_3 <= '0';en <= '0';holds <= '0'; 
		--4th
		en4 <= '0';s4 <= '0';w_r4 <= '0';
		--5th
		CTR_MUX <= '0';
		--DATA SIGNAL
		S_IR <= "10000100100001010011000100100111";
		WAIT FOR CLOCKPERIOD;
	--3th cycle
		--CONTROL SIGNAL
		--1th
		--EN_LATCH_PC<='1';EN_LATCH_NPC<='1';EN_LATCH_IR<='1';
		--2th
		--CALL <= '0';RETURN_S <= '0';
		--WF1<='0';RF1<='1';RF2<='1';
		--3th
		S3_1 <= '1';S3_2 <= '1';ALU1 <= '0';ALU2 <= '0';S3_3 <= '0';en <= '1';holds <= '0'; 
		--4th
		en4 <= '0';s4 <= '0';w_r4 <= '0';
		--5th
		CTR_MUX <= '0';
		--DATA SIGNAL
		S_IR <= "10000100111010000100100100100111";
		WAIT FOR CLOCKPERIOD;
	--4th cycle
		--CONTROL SIGNAL
		--1th
		--EN_LATCH_PC<='1';EN_LATCH_NPC<='1';EN_LATCH_IR<='1';
		--2th
		CALL <= '0';RETURN_S <= '0';
		WF1<='0';RF1<='1';
		--3th
		--S3_1 <= '1';S3_2 <= '1';ALU1 <= '0';S3_3 <= '0';en <= '1';holds <= '0'; 
		--4th
		en4 <= '1';s4 <= '1';w_r4 <= '1';
		--5th
		CTR_MUX <= '0';
		--DATA SIGNAL
		S_IR <= "10000101010010110110000100100111";
		WAIT FOR CLOCKPERIOD;
	--5th cycle
		--CONTROL SIGNAL
		--1th
		EN_LATCH_PC<='1';EN_LATCH_NPC<='1';EN_LATCH_IR<='1';
		--2th
		CALL <= '0';RETURN_S <= '0';
		WF1<='0';RF1<='0';
		--3th
		S3_1 <= '1';S3_2 <= '1';ALU1 <= '0';S3_3 <= '0';en <= '1';holds <= '0'; 
		--4th
		--en4 <= '0';s4 <= '0';w_r4 <= '0';
		--5th
		CTR_MUX <= '0';
		--DATA SIGNAL
		S_IR <= "10000101101011100111100100100111";
		WAIT FOR CLOCKPERIOD;
	--6th cycle
		--DATA SIGNAL
		S_IR <= "10000110000100011001000100100111";
		WAIT FOR CLOCKPERIOD;
	--7th cycle
		--DATA SIGNAL
		S_IR <= "10000110011101001010100100100111";
		WAIT FOR CLOCKPERIOD;
	--8th cycle
		--DATA SIGNAL
		S_IR <= "10000110110101111100000100100111";
		WAIT FOR CLOCKPERIOD;
	--9th cycle
		--DATA SIGNAL
		S_IR <= "10000111001110101101100100100111";
		WAIT FOR CLOCKPERIOD;
	--10th cycle
		--DATA SIGNAL
		S_IR <= "10000111100111011111000100100111";
		WAIT FOR CLOCKPERIOD;
END PROCESS;
end Behavioral;