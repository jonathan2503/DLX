library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use WORK.constants.all;

entity P4_ADDER_tb is
end;

architecture bench of P4_ADDER_tb is

  component P4_ADDER 
     GENERIC(
  		NBIT : integer := ALL_BITS 
  	);
  	Port (
  		A:	In	std_logic_vector(NBIT-1 downto 0);
  		B:	In	std_logic_vector(NBIT-1  downto 0);
  		Cin:	In	std_logic;
  		S:	Out	std_logic_vector(NBIT-1 downto 0);
  		Cout:	Out	std_logic
  	);
  end component;

  signal A: std_logic_vector(31 downto 0);
  signal B: std_logic_vector(31 downto 0);
  signal Cin: std_logic;
  signal S: std_logic_vector(31 downto 0);
  signal Cout: std_logic ;

begin

  -- Insert values for generic parameters !!
  uut: P4_ADDER generic map ( NBIT => 32  )
                   port map ( A    => A,
                              B    => B,
                              Cin  => Cin,
                              S    => S,
                              Cout => Cout );

  stimulus: process
  begin
	wait for 2 ns;
    -- Put initialisation code here
    A    <= "00000000000000000000000000000000";
    B    <= "00000000000000000000000000000000";
    Cin  <= '0';
	wait for 1 ns;
	A    <= "00000000000000000000000000000001";
    B   <= "00000000000000000000000000000001";
    Cin  <= '0';
	wait for 1 ns;
	A    <= "10000000000000000000000000000001";
    B   <= "10000000000000000000000000000001";
    Cin  <= '0';
	wait for 1 ns;
                             

    -- Put test bench stimulus code here

    wait;
  end process;


end;