

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BR_MUX is
Port (
clk : in std_logic;
--source of branch 
IF_PC : in std_logic_vector(31 downto 0);
EXE_PC : in std_logic_vector(31 downto 0);
--source of flag
Z : IN std_logic;
C : IN std_logic;
V : IN std_logic;
N : IN std_logic;
--source of CONTROL
EQ: IN std_logic;
NE: IN std_logic;
GT: IN std_logic;
LD: IN std_logic;
j_and_jal: IN std_logic;
--output
JUMP_NOTJUMP: OUT std_logic;
NPC_OUT: OUT std_logic_vector(31 downto 0)
 );
end BR_MUX;

architecture Behavioral of BR_MUX is
type state IS (WORKING,JUMP);
signal current_state, next_state: state := WORKING;

begin

--it acts as a FSM. Into the WORKING state it detects if a jump has to be performed. Into the JUMP state it does nothing
process(IF_PC,EXE_PC,Z,EQ,NE,j_and_jal,current_state)
begin
--TUTTA LA LOGICA DA DEFINIRE 
CASE current_state is 
when working => 


-----------------------------------
--              EQ 
-----------------------------------
IF (NE = '0' and EQ = '1' and j_and_jal = '1' and GT = '0' and LD = '0')
then 
  IF (Z = '1' ) then 
     NPC_OUT <= EXE_PC;
	JUMP_NOTJUMP <= '1';
	next_state <= JUMP;
	
  else 
     NPC_OUT <= IF_PC;
	JUMP_NOTJUMP <= '0';
	next_state <= WORKING;
  end if;
-----------------------------------
--              NEQ 
-----------------------------------
elsif (       NE = '1' and EQ = '0' and j_and_jal = '1' and GT = '0' and LD = '0' ) then                                
  IF (Z = '0' ) then 
   NPC_OUT <= EXE_PC;
   JUMP_NOTJUMP <= '1';
   next_state <= JUMP;
else 
   NPC_OUT <= IF_PC;
   JUMP_NOTJUMP <= '0';
   next_state <= WORKING;
end if;
-----------------------------------
--              >=
-----------------------------------
elsif (NE = '0' and EQ = '1' and j_and_jal = '1' and GT = '1' and LD = '0') then                                
 IF (C = '0' ) then 
   NPC_OUT <= EXE_PC;
   JUMP_NOTJUMP <= '1';
   next_state <= JUMP;
else 
   NPC_OUT <= IF_PC;
   JUMP_NOTJUMP <= '0';
   next_state <= WORKING;
end if;
-----------------------------------
--             >
-----------------------------------
elsif (NE = '0' and  EQ = '0' and j_and_jal = '1' and GT = '1' and  LD = '0' ) then                                
  IF (C = '1' AND Z= '0') then 
   NPC_OUT <= EXE_PC;
   JUMP_NOTJUMP <= '1';
   next_state <= JUMP;
else 
   NPC_OUT <= IF_PC;
   JUMP_NOTJUMP <= '0';
   next_state <= WORKING;
end if;
-----------------------------------
--              <
-----------------------------------
elsif ( NE = '0' and EQ = '0' and j_and_jal = '1' and GT = '0' and LD = '1' ) then                                
  IF (C = '0' ) then 
   NPC_OUT <= EXE_PC;
   JUMP_NOTJUMP <= '1';
   next_state <= JUMP;
else 
   NPC_OUT <= IF_PC;
JUMP_NOTJUMP <= '0';
next_state <= WORKING;
end if;
-----------------------------------
--              NEGATIV
-----------------------------------
elsif ( NE = '1' and EQ = '1' and j_and_jal = '1' and GT = '0' and LD = '0') then                                
  IF (N = '1' ) then 
   NPC_OUT <= EXE_PC;
   JUMP_NOTJUMP <= '1';
   next_state <= JUMP;
else 
   NPC_OUT <= IF_PC;
JUMP_NOTJUMP <= '0';
next_state <= WORKING;
end if;
-----------------------------------
--              <=
-----------------------------------
elsif (NE = '0' and EQ = '1' and j_and_jal = '1' and GT = '0' and LD = '1' ) then                                
 IF (C = '1' AND Z= '1') then 
   NPC_OUT <= EXE_PC;
   JUMP_NOTJUMP <= '1';
   next_state <= JUMP;
else 
   NPC_OUT <= IF_PC;
JUMP_NOTJUMP <= '0';
next_state <= WORKING;
end if;

-----------------------------------
--              <=
-----------------------------------
elsif (NE = '0' and  EQ = '1' and  j_and_jal = '1' and GT = '0' and LD = '1' ) then                                
  IF (C = '1' AND Z= '1') then 
   NPC_OUT <= EXE_PC;
   JUMP_NOTJUMP <= '1';
   next_state <= JUMP;
  else 
    NPC_OUT <= IF_PC;
	JUMP_NOTJUMP <= '0';
	next_state <= WORKING;
  end if;

-----------------------------------
--            J
-----------------------------------
elsif (   j_and_jal = '1'  ) then         
  NPC_OUT <= EXE_PC;
 JUMP_NOTJUMP <= '1';
  next_state <= JUMP;


else
 NPC_OUT <= IF_PC;
JUMP_NOTJUMP <= '0';
next_state <= WORKING;
end if ;

when JUMP =>
 next_state <= WORKING;
 JUMP_NOTJUMP <= '0';

END CASE;
end process;


PROCESS(CLK)
BEGIN
IF RISING_EDGE(CLK) THEN
current_state <= next_state;
end if;
end process;



end Behavioral;


