library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity exe_stage_tb is
end;

architecture bench of exe_stage_tb is

  component exe_stage
      port (
  in1:  in  std_logic_vector( 31 downto 0);
  A:    in  std_logic_vector( 31 downto 0);
  in2:  in  std_logic_vector( 31 downto 0);
  B:    in  std_logic_vector( 31 downto 0);
  S3_1:    in  std_logic ;
  S3_2:    in  std_logic ;
  ALU1:    in  std_logic ;
  ALU2:    in  std_logic ;
  S3_3:    in  std_logic ;
  en:      in  std_logic ;
  holds:   in  std_logic ;
  clk:     in  std_logic ;
  alu_out:  OUT  std_logic_vector( 31 downto 0);
  alu_mems:  OUT  std_logic_vector( 31 downto 0)
      );
  end component;

  signal in1: std_logic_vector( 31 downto 0);
  signal A: std_logic_vector( 31 downto 0);
  signal in2: std_logic_vector( 31 downto 0);
  signal B: std_logic_vector( 31 downto 0);
  signal S3_1: std_logic;
  signal S3_2: std_logic;
  signal ALU1: std_logic;
  signal ALU2: std_logic;
  signal S3_3: std_logic;
  signal en: std_logic;
  signal holds: std_logic;
  signal clk: std_logic;
  signal alu_out: std_logic_vector( 31 downto 0) ;
  signal alu_mems: std_logic_vector( 31 downto 0) ;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;
begin

  uut: exe_stage port map ( in1     => in1,
                            A       => A,
                            in2     => in2,
                            B       => B,
                            S3_1    => S3_1,
                            S3_2    => S3_2,
                            ALU1    => ALU1,
                            ALU2    => ALU2,
                            S3_3    => S3_3,
                            en      => en,
                            holds   => holds,
                            clk     => clk,
                            alu_out => alu_out,
                            alu_mems => alu_mems  );

  stimulus: process
  begin
  
    -- Put initialisation code here
    in1   <= B"0000_0000_0000_0000_0000_0000_0000_0001";
    A     <= B"0000_0000_0000_0000_0000_0000_0000_0010";
    in2   <= B"0000_0000_0000_0000_0000_0000_0000_0011";
    B     <= B"0000_0000_0000_0000_0000_0000_0000_0100";
    S3_1  <= '0';
    S3_2  <= '0' ;
    ALU1  <= '0';
    ALU2  <= '0';
    S3_3  <= '0' ;
    en    <= '0' ;
    holds <= '0' ;

   wait for 10 ns;
       -- Put initialisation code here
       in1   <= B"0000_0000_0000_0000_0000_0000_0000_0001";
       A     <= B"0000_0000_0000_0000_0000_0000_0000_0010";
       in2   <= B"0000_0000_0000_0000_0000_0000_0000_0011";
       B     <= B"0000_0000_0000_0000_0000_0000_0000_0100";
       S3_1  <= '0';
       S3_2  <= '0' ;
       ALU1  <= '0';
       ALU2  <= '0';
       S3_3  <= '0' ;
       en    <= '1' ;
       holds <= '0' ;
   
      wait for 10 ns;
      in1   <= B"0000_0000_0000_0000_0000_0000_0000_0001";
      A     <= (others => '1');
      in2   <= B"0000_0000_0000_0000_0000_0000_0000_0011";
      B     <= B"0000_0000_0000_0000_0000_0000_0000_0100";
      S3_1  <= '0';
      S3_2  <= '0' ;
      ALU1  <= '0';
      ALU2  <= '0';
      S3_3  <= '0' ;
      en    <= '1' ;
      holds <= '0' ;
  
      wait for 10 ns;
      S3_1  <= '0';
      S3_2  <= '0' ;
      wait for 10 ns;
      S3_1  <= '1';
      S3_2  <= '1' ;
     wait for 10 ns;
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
  