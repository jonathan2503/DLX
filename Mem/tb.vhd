library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity rf_tb is
end;

architecture bench of rf_tb is

  component rf 
  port (
  	  RF_i: in  std_logic_vector (31 downto 0);
  	  en  : in  std_logic ;
  	  Rf_o: out std_logic_vector (31 downto 0));			
  end component;

  signal RF_i: std_logic_vector (31 downto 0);
  signal en: std_logic;
  signal Rf_o: std_logic_vector (31 downto 0);

begin

  uut: rf port map ( RF_i => RF_i,
                     en   => en,
                     Rf_o => Rf_o );

  stimulus: process
  begin
  wait for 10 ns;
    -- Put initialisation code here
    RF_i <= B"00000_00000_00000_00000_00000_00000_00" ;
    wait for 10 ns;
    en <= '1' ;
    wait for 10 ns;
    RF_i <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" ;
    en <= '0' ;
    wait for 10 ns;
    en <= '1' ;
    wait for 10 ns;
    wait;
  end process;


end;