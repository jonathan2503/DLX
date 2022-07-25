library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.constants.all;


entity tri_stage is
     Port (
     --from sx
     in1:       in  std_logic_vector( 31 downto 0);
     A:         in  std_logic_vector( 31 downto 0);
     in2:       in  std_logic_vector( 31 downto 0);
     B:         in  std_logic_vector( 31 downto 0);

     --from CU
          --EXE
     S3_1:       in  std_logic ;
     S3_2:       in  std_logic ;
     ALU1:       in  std_logic ;
     ALU2:       in  std_logic ;
     S3_3:       in  std_logic ;
     en:         in  std_logic ;
     holds:      in  std_logic ;
          --MEM
     en4 :       in  std_logic ;
     s4  :       in  std_logic ;
     w_r4:       in  std_logic ;
          --WB
     CTR_MUX :   in  std_logic;
     EN5 :   in  std_logic;


     --extra
     clk:       in  std_logic ;
--from DX
TRI_OUT:         OUT  std_logic_vector( 31 downto 0)
     );
end  tri_stage;



architecture exe_mem_wb of tri_stage is

    component exe_stage
    port (
    in1:       in  std_logic_vector( 31 downto 0);
    A:         in  std_logic_vector( 31 downto 0);
    in2:       in  std_logic_vector( 31 downto 0);
    B:         in  std_logic_vector( 31 downto 0);
    S3_1:      in  std_logic ;
    S3_2:      in  std_logic ;
    ALU1:      in  std_logic ;
    ALU2:      in  std_logic ;
    S3_3:      in  std_logic ;
    en:        in  std_logic ;
    holds:     in  std_logic ;
    clk:       in  std_logic ;
    alu_out:   OUT  std_logic_vector( 31 downto 0);
    alu_mems:  OUT  std_logic_vector( 31 downto 0)
    );
   end component;

   component memory_stage  
   Port (
   alu_out:    in  std_logic_vector( 31 downto 0);
   mem_out:    in  std_logic_vector( 31 downto 0);
   Dout_mem:   OUT  std_logic_vector( 31 downto 0);
   en4 :       in  std_logic ;
   s4  :       in  std_logic ;
   w_r4:       in  std_logic ;
   Clk:        in  std_logic 
   );
   end component;

   component WB_stage
   Port (
        CLK,EN5,CTR_MUX:     IN std_logic;
        ALU_OUTPUT:          IN std_logic_vector(31 downto 0) ;
        MEM_OUTPUT:          IN std_logic_vector(31 downto 0) ;
        OUTPUT:              OUT std_logic_vector(31 downto 0)
   );
   end component;
 

   signal alu_outt:    std_logic_vector( 31 downto 0);
   signal alu_mems:   std_logic_vector( 31 downto 0);
   signal  Dout_mem:   std_logic_vector( 31 downto 0);
   signal  wire_out :  std_logic_vector( 31 downto 0);
   signal  gnd:  std_logic ;


begin
     gnd <= '0';

     exec_stage: exe_stage  
     port MAP  (   
     in1 => in1 ,
     A => A,
     in2=> in2,
     B => B,
     S3_1 => S3_1,
     S3_2 => S3_2 ,
     ALU1 => ALU1,
     ALU2 => ALU2 ,
     S3_3=>    S3_3 ,
     en=> en,
     holds=> holds ,
     clk => clk,
     alu_out=> alu_outt ,
     alu_mems=> alu_mems
     ); 


     MEM_stage: memory_stage  
     port MAP  (  
               alu_ouT  => alu_outt ,
               mem_out  => alu_mems,
               Dout_mem => Dout_mem , 
                en4 => en4,
                s4 => s4  ,
                w_r4=> w_r4 ,
               Clk=>  Clk
               );

  writeB_stage:WB_stage
   Port MAP (
        CLK => clk,
        en5  => en5,
        CTR_MUX => CTR_MUX,
        ALU_OUTPUT => alu_mems   ,
        MEM_OUTPUT => Dout_mem  ,
        OUTPUT     =>  wire_out    
   );
  

TRI_OUT <= wire_out ;





end exe_mem_wb;