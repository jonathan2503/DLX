----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.07.2022 11:40:00
-- Design Name: 
-- Module Name: TB_DECODE - Behavioral
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

entity TB_DECODE is
end TB_DECODE;

architecture Behavioral of TB_DECODE is
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

SIGNAL CLK,RESET,RF1,RF2,WF1,EN1,SEL_IMM,SEL_RD,CALL,RETURN_S,FILL,SPILL: std_logic;
SIGNAL IR,DATAIN,NPC,A,B,IN1,IN2: std_logic_vector(0 to 31);
SIGNAL ADD_WR,RD: std_logic_vector(0 to 4);



begin

DS: decode_stage port MAP(CLK,
RESET,
IR,
RF1,
RF2,
WF1,
EN1,
SEL_IMM,
SEL_RD,
ADD_WR,
DATAIN,
NPC,
A,
B,
IN1,
IN2,
RD,
CALL,
RETURN_S,
FILL,SPILL);

CLOCK:PROCESS
begin
CLK <= '1';
WAIT FOR 5 NS;
CLK <= '0';
WAIT FOR 5 NS;
END PROCESS;


process
begin
RESET <= '1';
WAIT FOR 10 NS;
RESET <= '0';

CALL <= '0';
RETURN_S <= '0';
FILL <= '0';
SPILL <= '0';

--SEGNALI AL MOMENTO INUTILI
IR <= (OTHERS =>'0');
RF1<='0';
RF2<='0';
SEL_IMM<= '0';
SEL_RD<='0';
NPC <= (OTHERS =>'0');

--SIMULO UNA WRITE NEL REGISTRO 01010
WF1<='1';
EN1<='1';
ADD_WR <= "01010";
DATAIN <= "00000000000000000000000000000001";

WAIT FOR 10 NS; --ASPETTO UN CICLO DI CLOCK PER I RISULTATI
WF1<='0';
RF1<='1';
IR <= "00000001010111111111111111111111";
WAIT FOR 30 NS;
SEL_IMM<= '1';
WAIT;
END PROCESS;




end Behavioral;
