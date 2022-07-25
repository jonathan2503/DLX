library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity tri_stage_tb is
end;

architecture bench of tri_stage_tb is

  component tri_stage
       Port (
       in1:       in  std_logic_vector( 31 downto 0);
       A:         in  std_logic_vector( 31 downto 0);
       in2:       in  std_logic_vector( 31 downto 0);
       B:         in  std_logic_vector( 31 downto 0);
       S3_1:       in  std_logic ;
       S3_2:       in  std_logic ;
       ALU1:       in  std_logic ;
       ALU2:       in  std_logic ;
       S3_3:       in  std_logic ;
       en:         in  std_logic ;
       holds:      in  std_logic ;
       en4 :       in  std_logic ;
       s4  :       in  std_logic ;
       w_r4:       in  std_logic ;
       CTR_MUX :   in  std_logic;
       clk:        in  std_logic ;
       EN5 :       in  std_logic;
  TRI_OUT:         OUT  std_logic_vector( 31 downto 0)
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
  signal en5: std_logic;
  signal en: std_logic;
  signal holds: std_logic;
  signal en4: std_logic;
  signal s4: std_logic;
  signal w_r4: std_logic;
  signal CTR_MUX: std_logic;
  signal ALU_OUTPUT: std_logic;
  signal MEM_OUTPUT: std_logic;
  signal clk: std_logic;
  signal TRI_OUT: std_logic_vector( 31 downto 0) ;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;
begin

  uut: tri_stage port map ( in1        => in1,
                            A          => A,
                            in2        => in2,
                            B          => B,
                            S3_1       => S3_1,
                            S3_2       => S3_2,
                            ALU1       => ALU1,
                            ALU2       => ALU2,
                            S3_3       => S3_3,
                            en         => en,
                            holds      => holds,
                            en4        => en4,
                            s4         => s4,
                            w_r4       => w_r4,
                            CTR_MUX    => CTR_MUX,
                            clk        => clk,
                            en5 => en5 ,
                            TRI_OUT    => TRI_OUT );

  stimulus: process
  begin
  
    in1       <= B"00000_00000_00000_00000_00000_00000_00";
    A         <= B"00000_00000_00000_00000_00000_00000_01";
    in2       <= B"00000_00000_00000_00000_00000_00000_10";
    B         <= B"00000_00000_00000_00000_00000_00000_11";
    S3_1      <=   '0';                                 
    S3_2      <=   '0';   
    ALU1      <=   '0';   
    ALU2      <=   '0';   
    S3_3      <=   '0';   
    en        <=   '0';   
    holds     <=   '0';   
    en4       <=   '0';   
    s4        <=   '0';   
    w_r4      <=   '0';   
    CTR_MUX   <=   '0';   
    en5 <= '0';  

 wait for 10 ns;
--EXE
 S3_1      <=   '0';                                 
 S3_2      <=   '0';   
 ALU1      <=   '0';   
 ALU2      <=   '0';   
 S3_3      <=   '0';   
 en        <=   '1';   
 holds     <=   '0';   
 --mem
 en4       <=   '0';   
 s4        <=   '0';   
 w_r4      <=   '0';  
 
 --wb 
 CTR_MUX   <=   '0';   
 en5 <= '0';  
 wait for 10 ns;


--EXE
 S3_1      <=   '0';                                 
 S3_2      <=   '0';   
 ALU1      <=   '0';   
 ALU2      <=   '0';   
 S3_3      <=   '0';   
 en        <=   '0';   
 holds     <=   '0';   
 --mem
 en4       <=   '1';   
 s4        <=   '0';   
 w_r4      <=   '0';  
 --wb 
 CTR_MUX   <=   '0'; 

 CTR_MUX   <=   '0';   
 wait for 10 ns;
--EXE
 S3_1      <=   '0';                                 
 S3_2      <=   '0';   
 ALU1      <=   '0';   
 ALU2      <=   '0';   
 S3_3      <=   '0';   
 en        <=   '0';   
 holds     <=   '0';   
 --mem
 en4       <=   '1';   
 s4        <=   '0';   
 w_r4      <=   '1';  
 --wb 
 CTR_MUX   <=   '0'; 
 en5 <= '0';  

 wait for 10 ns;
 --mem
 en4       <=   '0';   
 s4        <=   '0';   
 w_r4      <=   '0';  
 --wb 
 CTR_MUX   <=   '1'; 
 en5 <= '1';  


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
  