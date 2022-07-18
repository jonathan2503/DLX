library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity memory_stage_tb is
end;

architecture bench of memory_stage_tb is

  component memory_stage  
  Port (
  alu_out:  in  std_logic_vector( 31 downto 0);
  mem_out: in  std_logic_vector( 31 downto 0);
  Dout_mem:  OUT  std_logic_vector( 31 downto 0);
  en4 :    in  std_logic ;
  s4  :    in  std_logic ;
  w_r4:    in  std_logic ;
  Clk:    in  std_logic 
  );
  end component;

  signal alu_out: std_logic_vector( 31 downto 0);
  signal mem_out: std_logic_vector( 31 downto 0);
  signal Dout_mem: std_logic_vector( 31 downto 0);
  signal en4: std_logic;
  signal s4: std_logic;
  signal w_r4: std_logic;
  signal Clk: std_logic ;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: memory_stage port map ( alu_out  => alu_out,
                               mem_out  => mem_out,
                               Dout_mem => Dout_mem,
                               en4      => en4,
                               s4       => s4,
                               w_r4     => w_r4,
                               Clk      => Clk );

                               stimulus: process
                               begin
                               
-- Put initialisation code here
--test--


-------------------------ALU1 e RAM------------------------------
alu_out <= B"00000_00000_00000_00000_00000_00000_11";
mem_out <= B"00000_00000_00000_00000_00000_00000_01";

 ---------------------------------------------------------
-------------------------cu0------------------------------
en4 <= '0';
s4  <= '0';
w_r4 <= '1';
---------------------------------------------------------
wait for 10 ns;
en4 <= '0';
s4  <= '1';
                             
---------------------------------------------------------
wait for 10 ns;
en4 <= '1';
s4  <= '0';
---------------------------------------------------------
wait for 10 ns;
en4 <= '1';
s4  <= '1';
                               
                             
                             
-- Put test bench stimulus code here
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

  

  












