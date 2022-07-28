library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fetch_stage is
Port (
CLK,RST,EN_LATCH_PC,EN_LATCH_NPC,EN_LATCH_IR: IN std_logic;
PC_IN: IN std_logic_vector(31 downto 0);
PC_OUT : out std_logic_vector(31 downto 0);
IR: in std_logic_vector(31 downto 0);
IR_EXT: OUT std_logic_vector(31 downto 0);
NPC_EXT: OUT std_logic_vector(31 downto 0)
 );
end fetch_stage;

architecture Behavioral of fetch_stage is
component MY_REG is
	GENERIC(
		NBIT : integer:=32 );
	PORT(
		D : IN std_logic_vector(NBIT-1 downto 0);
		CLK : IN std_logic;
		RESET: IN std_logic;
		ENABLE : IN std_logic;
		Q: OUT std_logic_vector(NBIT-1 downto 0)
	);
end component;

SIGNAL NPC,PC: std_logic_vector(31 DOWNTO 0);

begin

reg1: MY_REG PORT MAP(
                    D=>PC_IN,
                    CLK => CLK, 
                    RESET=>RST,
                    ENABLE=>EN_LATCH_PC, 
                    Q=>PC );
                    
reg2: MY_REG PORT MAP(
                    D=>IR,
                    CLK => CLK, 
                    RESET=>RST,
                    ENABLE=>EN_LATCH_IR, 
                    Q=>IR_EXT );
              

reg3: MY_REG PORT MAP(
                    D=>NPC,
                    CLK => CLK,
                    RESET=>RST, 
                    ENABLE=>EN_LATCH_NPC, 
                    Q=>NPC_EXT);
                    
NPC <= std_logic_vector(UNSIGNED(PC)+4);
PC_OUT<= PC;
end Behavioral;
