
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity HZ is
Port (
RESET: in std_logic;
CLK: in std_logic;
--input IR
RS_IN_1:   in  std_logic_vector( 4 downto 0);
RS_IN_2:   in  std_logic_vector( 4 downto 0);
--INPUT STAGE
RD_EXE:     in  std_logic_vector( 4 downto 0);
RD_MEM:     in  std_logic_vector( 4 downto 0);
RD_WB :     in  std_logic_vector( 4 downto 0); --

--CU
ADD_EN_1_HZ:   in  std_logic;
ADD_EN_2_HZ:   in  std_logic;
EN_EXE     :   in  std_logic;
EN_MEM     :   in  std_logic;
EN_WB      :   in  std_logic; --
HZ         :   OUT  std_logic
);
 
end HZ;

architecture detection of HZ is
type status is (DETECTING,MEM_HAZARD,EXE_HAZARD_1,EXE_HAZARD_2,STOP_MEM);
signal current_status: status:=DETECTING;
signal next_status: status:=DETECTING;	
begin
--a FSM has been implemented

process (RS_IN_1,RS_IN_2,RD_EXE,RD_MEM,ADD_EN_1_HZ,ADD_EN_2_HZ,EN_MEM,EN_EXE,current_status) 

begin 

if (reset = '1') then 
	next_status <= DETECTING; 
else
case current_status is

when DETECTING =>

--comparisons between the addresses to write and the adresses to read (and their enable signal) are done
--exe
if (RS_IN_1 = RD_EXE and ADD_EN_1_HZ= '1' and EN_EXE = '1')or (RS_IN_2 = RD_EXE and ADD_EN_2_HZ= '1' and EN_EXE = '1')then
   	next_status <= EXE_HAZARD_1; 
--mem   
elsif (RS_IN_1 = RD_MEM and ADD_EN_1_HZ= '1' and EN_MEM = '1')or (RS_IN_2 = RD_MEM and ADD_EN_2_HZ= '1' and EN_MEM = '1') then
	next_status <= MEM_HAZARD; 
else 
	next_status <= DETECTING;
end if;

when MEM_HAZARD =>--it's necessary to wait a clock cycle
	next_status <= STOP_MEM;
when EXE_HAZARD_1 => --it's necessary to wait two clock cycles
	next_status <= EXE_HAZARD_2;
when EXE_HAZARD_2 => --it's necessary to wait a clock cycle more
	next_status <= STOP_MEM;
when STOP_MEM => --the pipe can be filled again with a new instruction but the MEM stage has to be ignored regarding the hazards.
	if (RS_IN_1 = RD_EXE and ADD_EN_1_HZ= '1' and EN_EXE = '1')or (RS_IN_2 = RD_EXE and ADD_EN_2_HZ= '1' and EN_EXE = '1')then
   	next_status <= EXE_HAZARD_1; 
	else
	next_status <= DETECTING;
	end if;
end case;
end if;
end process;



--depending on the next_status the output is selected
process (next_status)
begin

case next_status is

when DETECTING => HZ <= '0';
when MEM_HAZARD => HZ <= '1';
when EXE_HAZARD_1 => HZ <= '1';
when EXE_HAZARD_2 => HZ <= '1';
when STOP_MEM => HZ <= '0';
end case;
END PROCESS;


--at each rising edge the current status is updated
process(clk,reset)
begin 
if reset = '1'then
current_status <= DETECTING;
elsif (rising_edge(clk)) then
current_status <= next_status;
end if;
end process;

end detection;
