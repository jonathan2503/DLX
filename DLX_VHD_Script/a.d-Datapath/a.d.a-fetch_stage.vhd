library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fetch_stage is
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
end fetch_stage;

architecture structural  of fetch_stage is

component REG is
    generic ( NBIT : INTEGER );
    Port ( 
		RF_IN: 	IN std_logic_vector(NBIT-1 DOWNTO 0);
		CLK:    IN std_logic;
		RST: 	IN std_logic;
		ENABLE: IN std_logic;
		RF_OUT: OUT std_logic_vector(NBIT-1 DOWNTO 0)
    );
end component; 

component SUM_PC is
Port ( 
PC: 	IN std_logic_vector  (31 DOWNTO 0);
NPC:    OUT std_logic_vector (31 DOWNTO 0)
);
end component;

component MUX21 is
	generic(N: integer:=32);
	Port (
		A: in std_logic_vector(0 TO N-1);
		B: in std_logic_vector(0 TO N-1);
		sel: in std_logic;
		Y: out std_logic_vector(0 TO N-1)
	);
	end component;

SIGNAL PC_WIRE: std_logic_vector(31 DOWNTO 0):= (others =>'0');
SIGNAL IR_WIRE: std_logic_vector(31 DOWNTO 0):= (others =>'0');--inutilizzato
SIGNAL NPC_WIRE: std_logic_vector(31 DOWNTO 0):= (others =>'0');

begin

PC_EXT_IRAM <= PC_WIRE;
mux_PC :  MUX21 
			generic map(N  => 32)
			Port Map (
				A => PC_IN_IF,
				B => EXE_NPC_IF,
				sel => SEL_PC,
				Y => PC_WIRE
			);

reg1: REG  generic map(NBIT  => 32 )
		PORT MAP  ( 
			RF_IN => PC_WIRE,
			CLK   => CLK ,
			RST =>	RST ,
			ENABLE => EN_IF,
			RF_OUT => PC_EXT
		);
			


adderfor: SUM_PC  PORT MAP  
                 ( PC  => PC_WIRE ,
                   NPC => NPC_WIRE
                 );

reg2: REG  generic map(NBIT  => 32 )
		PORT MAP  ( 
			RF_IN => NPC_WIRE,
			CLK   => CLK ,
			RST =>	RST ,
			ENABLE => EN_IF,
			RF_OUT => NPC_EXT
		);

reg3: REG  generic map(NBIT  => 32 )
		PORT MAP  ( 
			RF_IN => IR_IN,
			CLK   => CLK ,
			RST =>	RST ,
			ENABLE => EN_IF,
			RF_OUT => IR_EXT
		);
			



end structural;
