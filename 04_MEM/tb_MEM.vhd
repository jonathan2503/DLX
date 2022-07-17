library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity memory_stage_tb is
end;

architecture bench of memory_stage_tb is

  component memory_stage
      generic(addrs: integer:=20);    
  Port (
  alu_out:  in  std_logic_vector( 31 downto 0);
  addr_out: in  std_logic_vector( addrs-1 downto 0);
  ADDR_ram:	out	std_logic_vector(addrs-1 downto 0);
  Din_ram:	out	std_logic_vector(31 downto 0);
  Dout_ram:	in	std_logic_vector( 31 downto 0);
  w_r_ram:	out	std_logic;
  en_ram :    out  std_logic ;
  Dout_mem:  OUT  std_logic_vector( 31 downto 0);
  en4 :    in  std_logic ;
  s4  :    in  std_logic ;
  w_r4:    in  std_logic ;
  CLK:    in  std_logic 
  );
  end component;

  signal alu_out: std_logic_vector( 31 downto 0);
  signal addr_out: std_logic_vector( 20-1 downto 0);
  signal ADDR_ram: std_logic_vector(20-1 downto 0);
  signal Din_ram: std_logic_vector(31 downto 0);
  signal Dout_ram: std_logic_vector( 31 downto 0);
  signal w_r_ram: std_logic;
  signal en_ram: std_logic;
  signal Dout_mem: std_logic_vector( 31 downto 0);
  signal en4: std_logic;
  signal s4: std_logic;
  signal w_r4: std_logic;
  signal CLK: std_logic ;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;
begin

  -- Insert values for generic parameters !!
  uut: memory_stage generic map ( addrs    => 20 )
                       port map ( alu_out  => alu_out,
                                  addr_out => addr_out,
                                  ADDR_ram => ADDR_ram,
                                  Din_ram  => Din_ram,
                                  Dout_ram => Dout_ram,
                                  w_r_ram  => w_r_ram,
                                  en_ram   => en_ram,
                                  Dout_mem => Dout_mem,
                                  en4      => en4,
                                  s4       => s4,
                                  w_r4     => w_r4,
                                  CLK      => CLK );

  stimulus: process
  begin

  --test--
  -------------------------cu0------------------------------
  en4 <= '0';
  s4  <= '0';
  w_r4 <= '0';
  ---------------------------------------------------------

   -------------------------ALU1 e RAM------------------------------
    alu_out <= B"00000_00000_00000_00000_00000_00000_00";
    addr_out <= B"0000_0000_0000_0000_0000";
    Dout_ram	<= B"00000_00000_00000_00000_00000_00000_00";
   ---------------------------------------------------------


    

    wait for 10 ns ;
    stop_the_clock <= true;
    wait;
  end process;



  clocking: process
  begin
    while not stop_the_clock loop
      ClK <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;