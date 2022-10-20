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
NPC:    in  std_logic_vector( 31 downto 0);
RD:   in  std_logic_vector( 4 downto 0);
--input from IF stage

-------------------------------------
--input from CU
-------------------------------------
RST : in std_logic;  
--EN_3 : in std_logic;  
S3_0 : in std_logic;  -- upper mux
S3_1 : in std_logic;  -- lower mux
--adder
ADD_SUB: in std_logic;
flag_en: in std_logic;-- attiva o disattiva i flag
C_EN   : in std_logic;--scegli tra leggere il carry oppure no
--SHIFT
R_L  :IN std_logic;-- keft or right
L_A : IN std_logic;--logic or arithmetic
S_R : IN std_logic; --shift or rotate
--logic
L_s_cho:   in  std_logic_vector( 3 downto 0);
--zero
z_enab : IN std_logic; --enable the zero detection

--DEMUX
C3:    in std_logic_vector(2 DOWNTO 0);
--FINAL
SEL42: in std_logic_vector(2 DOWNTO 0);
--branch
S_U: IN std_logic; --signed(0) or unsigned(1) numbers
EQ :  IN std_logic;
NE :  IN std_logic; 
j_and_jal: IN std_logic; 
GT: IN std_logic;
LD: IN std_logic;
--external
clk: in std_logic;


-------------------------------------
--out
-------------------------------------
JUMP_NOTJUMP: OUT std_logic;
EXE_ALU_OUT:OUT std_logic_vector( 31 downto 0);
EXE_MEM_DIN:OUT std_logic_vector( 31 downto 0);
RD_EXE: OUT std_logic_vector(4 downto 0);
EXE_NPC_IF:OUT std_logic_vector( 31 downto 0)
);
end ExeStage;





architecture Behavioral of ExeStage is

component REG is
    generic (NBIT:INTEGER);
    Port ( 
    RF_IN: 	IN std_logic_vector(NBIT-1 DOWNTO 0);
    CLK:    IN std_logic;
    RST: 	IN std_logic;
    ENABLE: IN std_logic;
    RF_OUT: OUT std_logic_vector(NBIT-1 DOWNTO 0)
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

component demuxer21 is
        PORT(
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31  downto 0);
        --control signal
        sel: in std_logic_vector(2 downto 0);
        --output
        to_adder: out std_logic_vector(31  downto 0);
        to_twocmp: out std_logic_vector(31  downto 0);
        to_A_logic: out std_logic_vector(31  downto 0);
        to_B_logic: out std_logic_vector(31  downto 0);
        to_A_shifter: out std_logic_vector(31  downto 0);
        to_B_shifter: out std_logic_vector(31  downto 0);
        R31_PC: out std_logic_vector(31  downto 0)
        );
end component;


component P4_ADDER_SUB is 
   GENERIC(
                NBIT : integer := 32);
   Port (       A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1  downto 0);
		ADD_SUB: In std_logic;
		Cin:	In	std_logic;
        C30:    Out	std_logic;
		B_2:   Out	std_logic_vector(NBIT-1  downto 0);
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Cout:	Out	std_logic);			
end component; 

component flag is 
port (
	  en:   in  std_logic ;   
	  C :   in  std_logic ;        
	  Z :   in  std_logic ;
	  V :   in  std_logic ;
	  N :   in  std_logic ;
	  C_o :   OUT  std_logic ;        
	  Z_o :   OUT  std_logic ;
	  V_o :   OUT   std_logic ;
	  N_o :   OUT  std_logic 
	  );
end component; 

component MUXone
Port (
      A: in std_logic;
      B: in std_logic;
      sel: in std_logic;
      Y: out std_logic);
end component;


component demuxer42 
        PORT (
        A: in std_logic_vector(31 downto 0);
        B: in std_logic_vector(31  downto 0);
        C: in std_logic_vector(31  downto 0);
        D: in std_logic_vector(31  downto 0);
        E: in std_logic_vector(31  downto 0);
        F: in std_logic_vector(31  downto 0);
        G: in std_logic_vector(31  downto 0);
        --control signal
        sel: in std_logic_vector(2 downto 0);
        --output
        MUXB: out std_logic_vector(31  downto 0);
        NPC: out std_logic_vector(31  downto 0)
        
        );
end component;

component Shifter is
        Port (
        A: IN std_logic_vector(31 DOWNTO 0);-- the value that i have to shift
        B: IN std_logic_vector(31 DOWNTO 0);--how many
        R_L : IN std_logic;-- keft or right
        L_A: IN std_logic;--logic or arithmetic
        S_R: IN std_logic; --shift or rotate
        Y: OUT std_logic_vector(31 downto 0)--output
         );
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


component zero_detector is
        Port (
        X : in std_logic_vector(31 downto 0);
        en: IN std_logic;
        Z : out std_logic
         );
        end component;
       
        
component BR_MUX is
                Port (
                --source of branch 
				clk: in std_logic;
                IF_PC : in std_logic_vector(31 downto 0);
                EXE_PC : in std_logic_vector(31 downto 0);
                --source of flag
                Z : IN std_logic;
                C : IN std_logic;
                V : IN std_logic;
                N : IN std_logic;
                --source of CONTROL
                EQ: IN std_logic;
                NE: IN std_logic;
                GT: IN std_logic;
                 LD: IN std_logic;
                j_and_jal: IN std_logic;
                --output
				JUMP_NOTJUMP: OUT std_logic;
                NPC_OUT: OUT std_logic_vector(31 downto 0)
                 );
        
 end component;

component cmp is
Port (
S_U: IN std_logic;
--source of flag
Z : IN std_logic;
C : IN std_logic;
V : IN std_logic;
N : IN std_logic;
--source of CONTROL
EQ: IN std_logic;
NE: IN std_logic;
GT: IN std_logic;
LD: IN std_logic;

--output
Y: OUT std_logic_vector(31 downto 0)
 );
        end component;







--------------------------------------------------------------------
--         SIGNAL        SIGNAL             SIGNAL  
--------------------------------------------------------------------




-- MUX SIGNAL
signal UMUX_EXE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal LMUX_EXE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
-- DEMUX SIGNAL
signal ADDER_WIRE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal TWOCMP_WIRE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
-- adder 
signal adder_out: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal carry_wire: std_logic := '0';
signal carry_out_wire: std_logic := '0';
signal Cmux_to_add: std_logic := '0'; 
--SHIFTER
signal A_SHIFT_WIRE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal B_SHIFT_WIRE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal SHOFT_OUT_WIRE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal R31_WIRE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
--logic
signal Logic_out_wire: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal A_LOGIC_WIRE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal B_LOGIC_WIRE: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
--zero detect
signal zero_out_wire: std_logic := '0';
signal MUX_zero_out_wire: std_logic := '0';
--final
signal NPC_wire: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
--other
signal GND: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal JAL_31: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
--flag
signal V_wire: std_logic := '0';
--branch
signal c30_wire: std_logic := '0';
signal s_B_2 : std_logic_vector(31 downto 0);
signal zero_wire: std_logic := '0';
signal negativ_out_wire: std_logic := '0';
signal overflow_out_wire: std_logic := '0';
signal BB_OR: std_logic := '0';
--signal A_zero: std_logic;
signal a_zero_wire: std_logic := '0';
signal cmp_wire: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal S_EXE_ALU_OUT,S_EXE_NPC_IF : std_logic_vector(31 downto 0);
signal S_RD: std_logic_vector(4 downto 0);

--------------------------------------------------------------------
--         BEGIN             BEGIN           BEGIN
--------------------------------------------------------------------
begin



------------------------------------------------
--                 REGISTERS
------------------------------------------------
--outputs are synchronized with the clock
REG_EXE_ALU_OUT: REG generic map (NBIT   => 32 )
        Port map ( 
        RF_IN   => S_EXE_ALU_OUT,
        CLK     => clk ,
        RST     => RST,
        ENABLE  => '1',
        RF_OUT  => EXE_ALU_OUT
        );
    
REG_EXE_MEM_DIN : REG generic map (NBIT   => 32 )
        Port map (
        RF_IN   => B,
        CLK     => clk ,
        RST     => RST,
        ENABLE  => '1',
        RF_OUT  => EXE_MEM_DIN
        );
    

--this output is not synchronized with the clock beacuse it has to be delivered immediatly to the fetch unit
EXE_NPC_IF <= S_EXE_NPC_IF;

REG_RD_EXE : REG generic map (NBIT   => 5 )
        Port map (
        RF_IN   => S_RD ,
        CLK     => clk ,
        RST     => RST,
        ENABLE  => '1',
        RF_OUT  => RD_EXE
        ); 
       
------------------------------------------------
--                 MUXES 
------------------------------------------------
--used to select if the first operand is the PC or the first value read by the register file
umux: MUX21 generic MAP (N => 32)
             Port MAP (
             A => in1 ,
             B => A ,
             sel => S3_0,
             Y => UMUX_EXE );
--used to select if the second operand is the immediate or the second value read by the register file
LMUX: MUX21 generic MAP (N => 32)
             Port MAP (
             A => IN2 ,
             B => B  ,
             sel => S3_1,
             Y => LMUX_EXE ); 

--used to select which address is going to be written between the one extracted by the IR or r31(in case of jr or jalr) 
RD_MUX: MUX21 generic MAP (N => 5)
             Port MAP (
             A => RD ,
             B => "11111"  ,
             sel => j_and_jal,
             Y => S_RD );           
------------------------------------------------
--                 DEMUXER
------------------------------------------------
--It selects whcih components will recive the new operands in inputs
DEMUX1:  demuxer21
        PORT MAP (
        A =>UMUX_EXE,
        B =>LMUX_EXE,
        --control signal
        sel => C3,
        --output
        to_adder => ADDER_WIRE ,
        to_twocmp => TWOCMP_WIRE,
        to_A_logic => A_LOGIC_WIRE,
        to_B_logic=>  B_LOGIC_WIRE,
        to_A_shifter=>  A_SHIFT_WIRE,
        to_B_shifter => B_SHIFT_WIRE,
        R31_PC => R31_WIRE
        
        );

------------------------------------------------
--                ADDER
------------------------------------------------
--the extra outputs are needed for the flags
ADDER: P4_ADDER_SUB 
        GENERIC MAP (NBIT => 32)
        PORT MAP (
        A => ADDER_WIRE,
		B=> TWOCMP_WIRE,
		ADD_SUB=> ADD_SUB,
		Cin => Cmux_to_add,
        C30 =>  c30_wire ,
		B_2 =>  s_B_2, 
		S => adder_out, --output della somma
		Cout=> carry_wire
                );			




------------------------------------------------
--               Flag
------------------------------------------------
--computed based on the input and the outputs of the adder
V_wire <=  (A(31) and s_B_2(31) and (not adder_out(31))) or ((not A(31)) and (not s_B_2(31)) and adder_out(31));

Flagoo: flag 
        port MAP (
	  en=> flag_en           ,   
	  C => carry_wire        ,        
	  Z => zero_wire         ,
      V   => V_wire,           
	  N   => adder_out(31),
	  C_o =>carry_out_wire   ,          
	  Z_o => zero_out_wire   ,
	  V_o =>negativ_out_wire,
	  N_o =>overflow_out_wire
	  );

--used to select if we want to set the Cin of the adder to 0 or to the carry of a previous operation
carry_mux: MUXone
 Port  map(
       A=> '0',
       B=> carry_out_wire,
       sel=> C_EN,
       Y=>  Cmux_to_add  );
------------------------------------------------
--               shifter
------------------------------------------------
SHI: Shifter 
        Port MAP (
        A=>  A_SHIFT_WIRE, 
        B=>  B_SHIFT_WIRE,
        R_L => R_L,  
        L_A => L_A,  
        S_R=> S_R, 
        Y => SHOFT_OUT_WIRE
         );
       

------------------------------------------------
--               Logic
------------------------------------------------

LOGICS: Logic 
        Port MAP ( 
         A => A_LOGIC_WIRE,
         B => B_LOGIC_WIRE,
        s0 => L_s_cho(0),
        s1 => L_s_cho(1),
        s2 => L_s_cho(2),
        s3 => L_s_cho(3),
        Y  => Logic_out_wire
);

------------------------------------------------
--               Branch
------------------------------------------------
--in case of comparison between two operand, their difference is evaluated
ZETA    : zero_detector 
        Port MAP (        
        X  => adder_out ,
        en => z_enab,
        Z => zero_wire
         );

--in case it's needed to perform a compariosn between an operand and zero 
ZETA_A    : zero_detector 
        Port MAP (        
        X  => A ,
        en => z_enab,
        Z => a_zero_wire
         );
--active and useful only in case of conditional branches(BEQZ,BNEZ) 
bb_or <= EQ OR NE;

--selects an input of BR_MUX
Zero_mux: MUXone
 Port  map(
       A=> zero_out_wire,
       B=> a_zero_wire,
       sel=> bb_or,
       Y=>  mux_zero_out_wire);
--takes as inputs only the flags and the control signals
 branch_control   : BR_MUX 
                Port map (
		clk => clk,
                --source of branch 
                IF_PC  => NPC,
                EXE_PC  => NPC_wire,
                --source of flag
                Z => mux_zero_out_wire, 
                C => carry_out_wire ,
                N => negativ_out_wire,
                v => overflow_out_wire,
                --source of CONTROL
                EQ => EQ,
                NE => NE,
                GT=>GT,
                LD=>LD,
                j_and_jal=> j_and_jal,
                --output
                NPC_OUT => S_EXE_NPC_IF,
				JUMP_NOTJUMP=>JUMP_NOTJUMP
                 );

------------------------------------------------
--                 CMP
------------------------------------------------   

--the comparator recives all the current flags independenlty from flag_en. In particular it recives always zero_wire becuse the comparison is always between two elements
CMPo: cmp 
        Port Map (
        Z  =>  zero_wire,
        C  =>  carry_wire,
        V  =>  V_wire,
        N  =>  adder_out(31),
        EQ =>  EQ ,
        NE =>  NE ,
        GT =>  GT ,
        LD =>  LD ,
        Y  =>  cmp_wire,
        S_U => S_U
		);

------------------------------------------------
--               FINAL COMPONENT
------------------------------------------------

--selects properly the future valeu of the output and the signal entering into the BR_MUX
DEMUX42: demuxer42 
       PORT map (
       A=> adder_out ,
       B=> Logic_out_wire,
       C=> SHOFT_OUT_WIRE,
       D=> NPC,
       E => UMUX_EXE,
       F=> cmp_wire,
       G => LMUX_EXE,
       --control signal
       sel=> SEL42,
       --output
       MUXB=>S_EXE_ALU_OUT,
       NPC=> NPC_wire
       );

end Behavioral;
