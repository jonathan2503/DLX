library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.constants.all;


entity exe_stage is

    port (
--input from ID stage
in1:  in  std_logic_vector( 31 downto 0);
A:    in  std_logic_vector( 31 downto 0);
in2:  in  std_logic_vector( 31 downto 0);
B:    in  std_logic_vector( 31 downto 0);
--input from CU
S3_1:    in  std_logic ;
S3_2:    in  std_logic ;
ALU1:    in  std_logic ;
ALU2:    in  std_logic ;
S3_3:    in  std_logic ;
en:      in  std_logic ;
holds:   in  std_logic ;
clk:     in  std_logic ;


-- output from stage
alu_out:  OUT  std_logic_vector( 31 downto 0)
    );
end  exe_stage;



architecture structural of exe_stage is


    component MUXone
    Port (
        A: in std_logic ;
        B: in std_logic ;
        sel: in std_logic;
        Y: out std_logic );
    end component;

component P4_ADDER 
    GENERIC(
         NBIT : integer := 32 
     );
     Port (
         A:	In	std_logic_vector(NBIT-1 downto 0);
         B:	In	std_logic_vector(NBIT-1  downto 0);
         Cin:	In	std_logic;
         S:	Out	std_logic_vector(NBIT-1 downto 0);
         Cout:	Out	std_logic
     );
 end component;

 component DEMUX1N
 Port (
 iin: in std_logic_vector( 31 downto 0);
 oout: out std_logic_vector( 63 downto 0);
 sel: in std_logic
 );
 end component;

 component rf 
 port (
       RF_i: in  std_logic_vector (31 downto 0);
       en  : in  std_logic ;
       Rf_o: out std_logic_vector (31 downto 0);	
       clk: in std_logic)		;
 end component;


 component flag 
 port (
       en:   in  std_logic ;  
       Hold:   in  std_logic ;  
       C :   in  std_logic ;        
       Z :   in  std_logic ;
       C_o :   OUT  std_logic ;        
       Z_o :  OUT  std_logic 
       );
 end component;

 component MUX21
 generic(N: integer:=32);
 Port (
       A: in std_logic_vector(N-1 downto 0);
       B: in std_logic_vector(N-1 downto 0);
       sel: in std_logic;
       Y: out std_logic_vector(N-1 downto 0));
 end component;

--------------------------------------------------
--                   signal
--------------------------------------------------


signal Mux_in1_A_out : std_logic_vector (31 downto 0);
signal Mux_in2_B_out : std_logic_vector (31 downto 0);
signal DEMuxA      :  std_logic_vector( 63 downto 0);
signal DEMuxB      :  std_logic_vector( 63 downto 0);
signal mux_CARRY  :   std_logic;
signal c_out      :  std_logic;
signal Z_out      :  std_logic;
signal c_out_add      :  std_logic;
signal adder_out : std_logic_vector (31 downto 0);
signal RF_adder_out : std_logic_vector (31 downto 0);
signal RF_MEM_out : std_logic_vector (31 downto 0);
SIGNAL gnd:      std_logic;
begin
    Mux_in1_AA: MUX21 generic map ( N   => 32  )
    port map ( A   => in1,
               B   => A,
               sel => S3_1,
               Y   =>Mux_in1_A_out ); 

    Mux_in2_BB: MUX21 generic map ( N   => 32  )
    port map ( A   => in2 ,
               B   => B,
               sel => S3_2,
               Y   =>Mux_in2_B_out ); 


     DEMUXAA: DEMUX1N port map ( iin  => Mux_in2_B_out,
    oout => DEMuxA  ,
    sel  => ALU1 );

    DEMUXBB: DEMUX1N port map (
         iin  => Mux_in2_B_out,
         oout => DEMuxB  ,
         sel  => ALU2 );

    uut: P4_ADDER generic map ( NBIT => 32  )
                   port map ( A    => DEMuxA(31 downto 0),
                              B    => DEMuxB(31 downto 0),
                              Cin  => mux_CARRY ,
                              S    => adder_out,
                              Cout => c_out_add );


    Mux_flag: MUXone
    port map ( A   => C_out ,
               B   => gnd,
               sel => S3_3,
               Y   => mux_CARRY ); 
                             
     flags: flag port map ( en   => en ,
                         Hold => holds ,
                         C    => c_out_add,
                         Z    => Z_out, --to gnd
                         C_o  => C_out,
                         Z_o  => Z_out );      --to gnd                        

    alu_outs: rf port map ( 
                        RF_i => adder_out,
                        en   => en,
                        Rf_o => RF_adder_out ,
                        clk => clk
                         );

 

    alu_out   <=    RF_adder_out;

    Z_out <= '0';

    gnd <= '0' ;


end structural;