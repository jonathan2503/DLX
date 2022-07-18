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
  
    --initialization of the test
	wait for 10 ns;
  --non operation zone
	 en <= '1'  ;	
	w_r <= '0';
  --read zone   
 wait for 1 ns;
 --imposition of adress that i want to check 
   ADDR <= B"0000_0000_0000_0000_0000";
    wait for 10 ns;
    --enable reading of adrex X"0"
    en <= '1'  ;
    w_r <= '1';
--next step is to see if the program take an input

--writing
  wait for 10 ns;
  w_r <= '0';
  en <= '0';
  Din  <= B"0000_0000_0000_0000_0000_0000_0010_0000";
  ADDR <= B"0000_0000_0000_0000_0001";
-- NOP operation
wait for 10 ns;
en <= '1'; --READ MODE
wait for 10 ns;
--read operation:
en <= '1';
w_r <= '1'; --read mode
ADDR <= B"0000_0000_0000_0000_0001";
en <= '1';
 
  
 wait for 10 ns;



    wait for 10 ns;
    wait;
  end process;


end;
--	Din  <= B"0000_0000_0000_0000_0000_0000_0000_0000";
--	wait for 10 ns;
--	en <= '0' ; 	
 --  ADDR <= B"0000_0000_0000_0000_0000";