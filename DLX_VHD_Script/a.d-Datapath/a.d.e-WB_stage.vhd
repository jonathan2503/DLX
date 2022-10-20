library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity WB_stage is
Port (
CLK: IN std_logic;
RST: IN std_logic;
CTR_MUX: IN std_logic;
ALU_OUTPUT: IN std_logic_vector(31 downto 0);
MEM_OUTPUT: IN std_logic_vector(31 downto 0);
RD:   in  std_logic_vector( 4 downto 0);
OUTPUT: OUT std_logic_vector(31 downto 0);
RD_EXE: OUT std_logic_vector(4 downto 0)
);
 
end WB_stage;

architecture Behavioral of WB_stage is

COMPONENT MUX21 is
generic(N: integer:=32);
Port (
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
sel: in std_logic;
Y: out std_logic_vector(N-1 downto 0));
end COMPONENT;

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
	
	
begin

--simple mux
MUX1: MUX21 PORT MAP (
                        A=>ALU_OUTPUT,
                        B=>MEM_OUTPUT,
                        SEL=>CTR_MUX,
                        Y=> OUTPUT
                    );
--RD and RD_EXE could be omitted from this stage, we kept them anyway for a clearer design
RD_EXE <= RD;





end Behavioral;
