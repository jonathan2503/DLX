




-- INPUTS,MUXES
                --LOGIC
                --SHIFTER 
                --ADDER/SUB 
                 --ADDER/SUB-COMPATATOR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.constants.all;


entity ExeStage is
Port (
--input from ID stage
in1:  in  std_logic_vector( 31 downto 0);
A:    in  std_logic_vector( 31 downto 0);
in2:  in  std_logic_vector( 31 downto 0);
B:    in  std_logic_vector( 31 downto 0);

-- ctr signals multiplexer
S3_1:    in  std_logic ;
S3_2:    in  std_logic ;


ALU1:    in  std_logic ;
ALU2:    in  std_logic ;
S3_3:    in  std_logic ;
en:      in  std_logic ;
holds:   in  std_logic ;
rst:     in std_logic;
clk:     in  std_logic ;

--LOGIC
l0:      in std_logic;
l1:      in std_logic;
l2:      in std_logic;
l3:      in std_logic;

--COMPARATOR
c0:      in std_logic; --GE
c1:      in std_logic; --GT
c2:      in std_logic; --LE
c3:      in std_logic; --LT
c4:      in std_logic; --EQ
c5:      in std_logic; --NE

--SHIFTER
R_L:      in std_logic; 
L_A:      in std_logic; 
S_R:      in std_logic; 

--DECIDE WHICH OUTPUT, ALU1 AND ALU2 can be used for this purpose
s1_out:   in std_logic;
s2_out:  in std_logic;

--ENABLE THE OUTPUT
en_out:  in std_logic;

--addition_subtraction
a_s:      in std_logic;
Cin_sel:  in std_logic;

alu_out:  OUT  std_logic_vector( 31 downto 0) ;
alu_mems:  OUT  std_logic_vector( 31 downto 0)


);
end ExeStage;

architecture Behavioral of ExeStage is

component P4_ADDER_SUB is 

   GENERIC(
		NBIT : integer := ALL_BITS 
	);
	
	Port (
		A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1  downto 0);
		ADD_SUB: In std_logic;
		Cin:	In	std_logic;
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Cout:	Out	std_logic
	);
		
		
end component; 


 component MUX21
 generic(NBIT: integer:=32);
 Port (
       A: in std_logic_vector(NBIT-1 downto 0);
       B: in std_logic_vector(NBIT-1 downto 0);
       s: in std_logic;
       Y: out std_logic_vector(NBIT-1 downto 0));
 end component;
 
  component MUX21_single
 generic(N: integer:=32);
 Port (
       A: in std_logic;
       B: in std_logic;
       sel: in std_logic;
       Y: out std_logic);
 end component;
 
component Logic is
Port ( 
A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
s0: in std_logic;
s1: in std_logic;
s2: in std_logic;
s3: in std_logic;
Y: out std_logic_vector(31 downto 0)
);
end component;


component MY_REG is
generic (NBIT:INTEGER:=32);
Port ( 
D: IN std_logic_vector(NBIT-1 DOWNTO 0);
CLK: IN std_logic;
RESET: IN std_logic;
ENABLE: IN std_logic;
Q: OUT std_logic_vector(NBIT-1 DOWNTO 0)
);
end component;

component MY_REG_single is
Port ( 
D: IN std_logic;
CLK: IN std_logic;
RESET: IN std_logic;
ENABLE: IN std_logic;
Q: OUT std_logic
);
end component;

component zero_detector is
Port (
X : in std_logic_vector(31 downto 0);
rst : in std_logic;
Z : out std_logic
 );
end component;


Component Flags is
port ( 

C: in std_logic; --cary in
Z: in std_logic; --zero

c0:      in std_logic; --GE
c1:      in std_logic; --GT
c2:      in std_logic; --LE
c3:      in std_logic; --LT
c4:      in std_logic; --EQ
c5:      in std_logic; --NE

Comp_out: out std_logic_vector(31 downto 0)
);
end component;

component Shifter is
Port (
A: IN std_logic_vector(31 DOWNTO 0);--valore da shiftare
B: IN std_logic_vector(31 DOWNTO 0);--quanto shiftare il valore
R_L : IN std_logic;--destra o sinistra
L_A: IN std_logic;--logic or arithmetic
S_R: IN std_logic; --shift or rotate
Y: OUT std_logic_vector(31 downto 0)--output
 );
end component;


Signal o1,o2: std_logic_vector(31 downto 0);
Signal logic_out,adder_out,comparator_out,shifter_out,out1,out2,final_out: std_logic_vector(31 downto 0);
Signal C,Z,S: std_logic;
Signal c_in_in,c_out: std_logic;

begin

    Mux_in1_AA: MUX21 generic map ( NBIT   => 32  )
    port map ( A   => in1,
               B   => A,
               s => S3_1,
               Y   =>o1 ); 

    Mux_in2_BB: MUX21 generic map ( NBIT   => 32  )
    port map ( A   => in2 ,
               B   => B,
               s => S3_2,
               Y   =>o2);
               
    shifter1:  Shifter 
Port map (
A=> o1,
B=> o2,
R_L => R_L,
L_A=> L_A,
S_R=> S_R,
Y=> shifter_out
 );


    Logic1: Logic 
    port map( 
            A=>o1,
            B=>o2,
            s0=>l0,
            s1=>l1,
            s2=>l2,
            s3=>l3,
            Y=>logic_out
);

    Ad_Su:  P4_ADDER_SUB  

   GENERIC map(
		NBIT=>32
	)
	
	Port map (
		A => o1,
		B => o2,
		ADD_SUB => a_s,
		Cin => c_in_in,
		S => adder_out,
		Cout=> C  --
	);
	
	 Mux_C: MUX21_single generic map ( N   => 1  )
        port map ( A   => '0' ,
               B   => C,
               sel => Cin_sel,
               Y   =>c_out);
     
     reg_C: MY_REG_single port map(
     D=> c_out,
     CLK=>clk,
     RESET=> rst,
     ENABLE => '1',
     Q=> c_in_in);
     
     
     zd: zero_detector 
    Port Map(
        X =>adder_out,
        rst => rst,
        Z =>Z
        );
        
        
      Flags1: Flags
port map ( 

C=>C,
Z=> Z,

c0=> c0,
c1=> c1,
c2=>c2,
c3=>c3,
c4=> c4,
c5=> c5,
Comp_out=> comparator_out
);


    MUX_OUT_1: MUX21 PORT MAP (
                A   => shifter_out,
               B   => logic_out,
               s => s1_out,
               Y   => out1 ); 
               
    MUX_OUT_2: MUX21 PORT MAP (
                A   => adder_out,
               B   => comparator_out,
               s => s1_out,
               Y   => out2);
               
    MUX_OUT: MUX21 PORT MAP (
                A   => out1,
               B   => out2,
               s => s2_out,
               Y   => final_out);
    
    REG_OUT1: MY_REG PORT MAP (
    D=> final_out,
CLK=> clk,
RESET=> rst,
ENABLE=> en_out,
Q=> alu_out);


  REG_OUT2: MY_REG PORT MAP (
    D=> B,
CLK=> clk,
RESET=> rst,
ENABLE=> en_out,
Q=> alu_mems);
    

end Behavioral;
