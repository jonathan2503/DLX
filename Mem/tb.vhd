library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use WORK.constants.all;
entity RAM_tb is
end;

architecture bench of RAM_tb is

  component RAM 
  		port (
  			ADDR:	in	std_logic_vector(19 downto 0);
  			 Din:	in	std_logic_vector(ALL_BITS-1 downto 0);
  			Dout:	out	std_logic_vector( 31 downto 0);
  			w_r:	in	std_logic;
  			r  :    in  std_logic;
  			en :    in  std_logic );
  end component;

  signal ADDR: std_logic_vector(19 downto 0);
  signal Din: std_logic_vector(ALL_BITS-1 downto 0);
  signal Dout: std_logic_vector( 31 downto 0);
  signal w_r: std_logic;
  signal r: std_logic;
  signal en: std_logic ;

begin

  uut: RAM port map ( 
	ADDR => ADDR,
                      Din  => Din,
                      Dout => Dout,
                      w_r  => w_r,
                      r    => r,
                      en   => en );

  stimulus: process
  begin
  
    -- Put initialisation code here
	wait for 10 ns;
	-- en <= '1'  ;
	-- wait for 10 ns;
	-- en <= '0' ; 	
	--ADDR <= B"0000_0000_0000_0000_0000";
--	Din  <= B"0000_0000_0000_0000_0000_0000_0000_0000";
--	w_r <= '0';
--	wait for 10 ns;
--	en <= '0' ; 	
 --  ADDR <= B"0000_0000_0000_0000_0000";
 
--   w_r <= '1';
	

    -- Put test bench stimulus code here

    wait;
  end process;


end;