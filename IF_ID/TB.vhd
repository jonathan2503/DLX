----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2022 18:28:26
-- Design Name: 
-- Module Name: TB2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB2 is
end TB2;

architecture Behavioral of TB2 is

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
--DA IR SI DEDUCONO TUTTE GLI ALTRI INPUT

--CTR SIGNALS IN SLIDES
RF1: 		IN std_logic;
RF2: 		IN std_logic;
WF1: 		IN std_logic;
EN1: 		IN std_logic;

--MY CTR SIGNALS
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

SIGNAL IR_EXT,NPC_ext: std_logic_vector(31 downto 0);

SIGNAL CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: std_logic;
SIGNAL PC_IN: std_logic_vector(31 downto 0);
SIGNAL PC_OUT :  std_logic_vector(31 downto 0);
SIGNAL IR:  std_logic_vector(31 downto 0);

--ctrl signals 
SIGNAL RF1: 		 std_logic;
SIGNAL RF2: 	 std_logic;
SIGNAL WF1: 	std_logic;
SIGNAL EN1: 		 std_logic;
SIGNAL SEL_IMM:    std_logic;--TO SELECT IMM
SIGNAL SEL_RD:     std_logic; -- TO SELECT RD(2 CHOISES)

SIGNAL ADD_WR,RD: 	 std_logic_vector(0 to 4); 
SIGNAL A,B,IN1,IN2,DATAIN: 	 std_logic_vector(0 to 31);
SIGNAL CALL,RETURN_S,FILL,SPILL:  std_logic;

constant CLOCKPERIOD:TIME:=10NS;

begin

f: fetch_stage PORT MAP 
(CLK=>CLK,RST=>RST,EN_LATCH_PC=>EN_LATCH_PC,EN_LATCH_NPC=>EN_LATCH_NPC,EN_LATCH_IR=>EN_LATCH_IR,
PC_IN=>PC_IN,
PC_OUT=>PC_OUT,
IR=>IR,
IR_EXT=>IR_EXT,
NPC_EXT=>NPC_ext);

d: decode_stage PORT MAP 
(
CLK=>CLK,RESET=>RST,
IR=>IR_EXT,

RF1=>RF1,
RF2=> RF2,
WF1=> WF1,
EN1=> EN1,

SEL_IMM=> SEL_IMM,  
SEL_RD=> SEL_RD,
ADD_WR=> ADD_WR, 
DATAIN=> DATAIN,
NPC=> NPC_ext,

A=>A,
B=> B,
IN1=> IN1,
IN2=> IN2,
RD=> RD,

CALL=> CALL,
RETURN_S=> RETURN_S,
FILL=> FILL,
SPILL=> SPILL

);


process
begin
CLK <= '0';
WAIT FOR CLOCKPERIOD/2;
CLK <= '1';
WAIT FOR CLOCKPERIOD/2;
END PROCESS;

process
begin
RST<= '1';
WAIT FOR CLOCKPERIOD;
RF1<= '0';
RF2<='0';
WF1<= '0';
RST <= '0';
EN_LATCH_PC <= '1';
EN_LATCH_NPC<= '1';
EN_LATCH_IR<='1';
CALL <= '0'; 
RETURN_S<= '0';
PC_IN <= "01010100000000000000000000000000";
WAIT FOR CLOCKPERIOD;


--SI GIOCA SU QUESTI
RF1<= '1';
RF2<='1';
WF1<= '1';
EN1<= '1';--PUO STARE SEMPRE SU 1
SEL_IMM <= '0';
SEL_RD <='0';
ADD_WR<= "01010";
DATAIN<= "01010100000000000000000000000000";

IR <= "10001100010001010000000000010100";

WAIT FOR CLOCKPERIOD*4;
RST <= '0';

--SI GIOCA SU QUESTI
RF1<= '1';
RF2<='1';
WF1<= '1';
EN1<= '1';--PUO STARE SEMPRE SU 1
SEL_IMM <= '1';
SEL_RD <='1';
ADD_WR<= "11111";
DATAIN<= "01010100000000000000000000000001";

IR <= "00000000000000000000000000000000";
WAIT;
 
END PROCESS;

end Behavioral;
