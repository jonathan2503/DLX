
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.constants.all;


entity TB2 is
end TB2;

architecture Behavioral of TB2 is

component DLX2 is  
  generic (IRAM_SIZE: integer:=32);
  port (
    Clk : in std_logic;
    Rst : in std_logic;
	Addr_to_IRAM: out std_logic_vector(IRAM_SIZE - 1 downto 0);
	Data_from_IRAM: IN std_logic_vector(IRAM_SIZE - 1 downto 0);
	ADDR_to_RAM:  out std_logic_vector(31 downto 0);
  	Data_from_RAM:	in	std_logic_vector(31  downto 0);
  	Data_to_RAM:	out	std_logic_vector(31 downto 0);
  	w_r:	out	std_logic;
  	en_ram:    out  std_logic );               
end component;

component RAM is 

		port (
	    --input--
			CLK :   in  std_logic;
			RST : 	in	std_logic;
			ADDR:	in	std_logic_vector(31 downto 0); ---
			Din:	in	std_logic_vector(ALL_BITS-1 downto 0); --32 BIT
		--output--
			Dout:	out	std_logic_vector(ALL_BITS-1 downto 0);
		--Control--
			
			w_r:	in	std_logic;  -- control if w_r=0 w mode ; r=>1 r mode;
			en :    in  std_logic ); -- enable )
end component ; 

component IRAM is
  generic (
    RAM_DEPTH : integer := 48;
    I_SIZE : integer := 32);
  port (
	CLK  : in std_logic;
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );

end component;

SIGNAL CLK,CLK_MEM,RST,W_R,EN_RAM: std_logic;

SIGNAL Addr_to_IRAM,Data_from_IRAM,ADDR_to_RAM,Data_from_RAM,Data_to_RAM:std_logic_vector(31  downto 0);
  	


begin
DLX_T: DLX2 PORT MAP (CLK=>CLK, 
				  	RST=>RST,
				  	Addr_to_IRAM=>Addr_to_IRAM,
					Data_from_IRAM => Data_from_IRAM,
					ADDR_to_RAM => ADDR_to_RAM, 
  					Data_from_RAM => Data_from_RAM,
  					Data_to_RAM => Data_to_RAM, 
  					w_r=> w_r,
  					en_ram=> en_ram ); 

RAM_T: RAM PORT MAP(
			CLK => CLK_MEM,
			RST => RST,
			ADDR => ADDR_TO_RAM,
			Din=> DATA_TO_RAM,
			Dout=> DATA_FROM_RAM,
			w_r => W_R,
			en => EN_RAM);
 
IRAM_T: IRAM PORT MAP(
	CLK => CLK_MEM,
    Rst => RST,
    Addr => ADDR_TO_IRAM,
    Dout => DATA_FROM_IRAM
    );


CLK_MEM <= NOT(CLK);

PROCESS
begin
RST <= '1';
WAIT FOR 10 NS;
RST <= '0';
WAIT;
END PROCESS;

PROCESS
begin
CLK <= '0';
WAIT FOR 5 NS;
CLK <= '1';
WAIT FOR 5 NS;
END PROCESS;

end Behavioral;
