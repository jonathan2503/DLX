library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity SUM_GENERATOR is 

		generic (
			NBIT_PER_BLOCK: integer := N_BIT;
			NBLOCKS:	integer := N_Block);
		port (
			A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			Ci:	in	std_logic_vector(NBLOCKS-1 downto 0);
			S:	out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end SUM_GENERATOR; 

architecture STRUCTURAL of SUM_GENERATOR is

	component csb --define block adder
		generic ( ANBIT : integer := NBIT_PER_BLOCK
	);
	
	Port (
		A_c:	In	std_logic_vector(ANBIT-1 downto 0);
		B_c:	In	std_logic_vector(ANBIT-1 downto 0);
		Ci_c:	In	std_logic;
		So_c:	Out	std_logic_vector(ANBIT-1 downto 0));
   

  end component; 

  
begin
      blo:  for I in 1 to NBLOCKS  generate      --compute sum of each block
       cbl : csb
			Port Map ( 
				A(NBIT_PER_BLOCK*I-1 downto NBIT_PER_BLOCK*(I-1)), 
				B(NBIT_PER_BLOCK*I-1 downto NBIT_PER_BLOCK*(I-1)), 
				Ci(I-1), S(NBIT_PER_BLOCK*I-1 downto NBIT_PER_BLOCK*(I-1))
			); 
            end generate;
			
end STRUCTURAL;



------------------------------------------------------------------------------------------------------------------------------------------------
--                                              sparse tree look-ahead adder                                                                  --
------------------------------------------------------------------------------------------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use work.high_math.all;

entity CARRY_GENERATOR is 

   GENERIC(
		NBIT : integer := ALL_BITS;
		NBIT_PER_BLOCK: integer := N_subdiv
	);
	
	Port (
		A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1  downto 0);
		Cin:	In	std_logic;
		C30:   Out	std_logic;
		Co:	Out	std_logic_vector(NBIT/NBIT_PER_BLOCK downto 0)
		
	);
end CARRY_GENERATOR; 


architecture STRUCTURAL of CARRY_GENERATOR is

 
 ---------------- FIRST adder of basic adder---------------------------
  component f_add  
	Port (	
	    f_a:	In	std_logic;  --variable of upper block left
		f_b:	In	std_logic;  --variable of upper block reight
		G:	Out	std_logic;  --output of first
		P:	Out	std_logic  --output of second
		);
	
  end component; 
  
  ----------------END FIRST adder of basic adder------------------------
  
 
 
 
---------------------- g adder ----------------------------------------- 
  component g 
	Port (	
	    Ga:	In	std_logic;
		Gb:	In	std_logic;
		P:	In	std_logic;
		G_out:	Out	std_logic
		);
  end component; 
  
 ---------------END g --------------------------------- 
  
  
  
 
 ---------------------- pg adder ----------------------------------------  
  component pg 

	Port (	
	    Ga:	In	std_logic;  --variable of upper block left
		Gb:	In	std_logic;  --variable of upper block reight
		P1:	In	std_logic;  -- immediate vicinance ci
		P2:	In	std_logic; --shifted of two curry
		G_out:	Out	std_logic;  --output of first
		P_out:	Out	std_logic  --output of second
		);
  end component; 
  
 ---------------END g adder basic adder--------------------------------- 
 type SignalVector is array(NBIT downto 1) of std_logic_vector(NBIT downto 1);
 signal P_1 : std_logic_vector(NBIT downto 1);
 signal G_1 : std_logic_vector(NBIT downto 1);
 signal C_G : SignalVector;
 signal C_P : SignalVector;
 signal C30_WIRE_G : std_logic;
 constant layers : integer := log2(NBIT);
 
 begin
	--step1 get pg net work
	R0: for i in 0 to NBIT-1  generate
         R0_0: f_add Port Map ( f_a=> A(i),f_b => B(i) , G =>C_G(i+1)(i+1), P =>C_P(i+1)(i+1));
    end generate R0;
	Co(0) <= Cin;
   --need overflow 
   ov0: g 
        Port Map(
				Ga => A(NBIT-2),
				Gb => B(NBIT-2),
				P  => '0',						
				G_out => C30_WIRE_G  );
      c30 <= C30_WIRE_G;
   --step 3 get g
------############################################################################
	
		R1: for i in 1 to layers generate
			R2: for j in 1 to NBIT generate
				-- get G block
				IFG: if ((j mod 2**i = 0 or j mod NBIT_PER_BLOCK = 0) and j> 2**(i-1) and j <= 2**i) generate
					G_B: g 
						Port Map(
							Ga => C_G(j)(2**(i-1)+1),
							Gb => C_G(2**(i-1))(1),
							P  => C_P(j)(2**(i-1)+1),						
							G_out => C_G(j)(1) );
				


------############################################################################
					res1: if j mod NBIT_PER_BLOCK = 0 generate   --output G of each block
						Co(j/NBIT_PER_BLOCK) <= C_G(j)(1);
					end generate res1;
				end generate IFG;
				IFP0: if j/2**i >= 1 and j mod 2**i > 0 and ((j - 2**i) > 2**(i-1)) and j < 2**(i+1)and (j mod NBIT_PER_BLOCK = 0)generate   --compute PG which is not at n*2**(layer) bit,n=1,2,3...
					PG_B0: pg
						Port Map(
							Ga => C_G(j)((j/2**(i-1))*2**(i-1)+1),  --G of upper block left
							Gb => C_G((j/2**(i-1))*2**(i-1))((j/2**(i-1))*2**(i-1)-2**(i-1)+1),  --G of upper block right
							P1 => C_P(j)((j/2**(i-1))*2**(i-1)+1),  --P of upper block left
							P2 => C_P((j/2**(i-1))*2**(i-1))((j/2**(i-1))*2**(i-1)-2**(i-1)+1),  --P of upper block right
							G_out => C_G(j)((j/2**(i-1))*2**(i-1)-2**(i-1)+1),   --output of G of PG block
							P_out => C_P(j)((j/2**(i-1))*2**(i-1)-2**(i-1)+1)    --output of P of PG block
						);
				end generate IFP0;
				ifP1: if j/2**i > 1 and j mod 2**i =0 generate   --compute PG which is at n*2**(layer) bit,n=1,2,3...
					PG_B1:pg
						Port Map(
							Ga => C_G(j)(j-2**(i-1)+1),    --G of upper block left
							Gb => C_G(j-2**(i-1))(j-2**i+1),  --G of upper block right
							P1 => C_P(j)(j-2**(i-1)+1),    --P of upper block left
							P2 => C_P(j-2**(i-1))(j-2**i+1),  --P of upper block right
							G_out => C_G(j)(j-2**i+1),
							P_out => C_P(j)(j-2**i+1)
						);
				end generate IFP1;
			end generate R2;
		end generate R1;
end STRUCTURAL;





------------------------------------------------------------------------------------------------------------------------------------------------
--                                              P4 ADDER                                                               --
------------------------------------------------------------------------------------------------------------------------------------------------




library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;


entity P4_ADDER is 

   GENERIC(
		NBIT : integer := ALL_BITS 
	);
	
	Port (
		A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1  downto 0);
		Cin:	In	std_logic;
		C30:    Out	std_logic;
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Cout:	Out	std_logic
	);
		
		
end P4_ADDER; 



architecture STRUCTURAL of P4_ADDER is


component SUM_GENERATOR 

		generic (
			NBIT_PER_BLOCK: integer := N_BIT;
			NBLOCKS:	integer := N_Block
		);
		port (
			A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			Ci:	in	std_logic_vector(NBLOCKS-1 downto 0);
			S:	out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0)
		);
end component; 




component CARRY_GENERATOR 
   GENERIC(
		NBIT : integer := NBIT;
		NBIT_PER_BLOCK: integer := N_subdiv
	);
	
	Port (
		A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1  downto 0);
		Cin:	In	std_logic;
		C30:    OUT	std_logic;
		Co:	Out	std_logic_vector(NBIT/NBIT_PER_BLOCK downto 0)
	);
end component; 



 signal C_TMP : std_logic_vector(NBIT/N_subdiv downto 0); --bufferof all carry
 signal A_TMP : std_logic_vector(NBIT-1 downto 0);-- buffer temporary sum
 signal B_TMP : std_logic_vector(NBIT-1 downto 0);-- buffer temporary sum
          
  
begin


	UCARRY : CARRY_GENERATOR

		Port Map(
			A => A, 
			B => B, 
			Cin =>Cin, 
			Co => C_TMP,
			C30 => C30
		);
		
	USUM : SUM_GENERATOR

		Port Map ( 
			A => A,
            B => B,
            Ci =>c_TMP(NBIT/N_subdiv-1 downto 0),  
			S => S 
		);		

	Cout <= c_TMP(NBIT/N_subdiv);
      
end STRUCTURAL;





------------------------------------------------------------------------------------------------------------------------------------------------
--                                              P4 ADDER/SUBTRACTOR                                                               --
------------------------------------------------------------------------------------------------------------------------------------------------




library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;


entity P4_ADDER_SUB is 

   GENERIC(
		NBIT : integer := ALL_BITS 
	);
	
	Port (
		A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1  downto 0);
		ADD_SUB: In std_logic;     --0 add, 1 sub
		Cin:	In	std_logic;
		C30:    Out	std_logic;
		B_2:   Out	std_logic_vector(NBIT-1  downto 0);
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Cout:	Out	std_logic
	);
		
		
end P4_ADDER_SUB; 



architecture STRUCTURAL of P4_ADDER_SUB is

component P4_ADDER is 

   GENERIC(
		NBIT : integer := ALL_BITS 
	);
	
	Port (
		A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1  downto 0);
		Cin:	In	std_logic;
		C30:    Out	std_logic;
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Cout:	Out	std_logic
	);
		
		
end component; 


component MUX21 is
 GENERIC(
		N : integer := ALL_BITS 
	);
	
port(
A: IN std_logic_vector( NBIT -1 DOWNTO 0);
B: IN std_logic_vector( NBIT -1 DOWNTO 0);
SEL: IN std_logic;
Y: OUT std_logic_vector( NBIT -1 DOWNTO 0)
);
END component;

Signal s_B_2: std_logic_vector( NBIT -1 DOWNTO 0);
signal med_std99: std_logic_vector( NBIT -1 DOWNTO 0);
signal C30_WIRE: std_logic;

begin
med_std99 <= std_logic_vector(unsigned(NOT(B))+1);    --complement of B

m: MUX21 
          generic map(N=>32)
		  port map  (A =>B,
		  			 B =>med_std99,
					 SEL => ADD_SUB,
					 Y =>s_B_2);
a2: P4_ADDER PORT MAP (A =>A,
					   B =>s_B_2,
					   Cin=>Cin,
					   C30=> C30_WIRE,
					   S => S,
					   Cout => Cout);
C30     <=   C30_WIRE;
B_2     <=   s_B_2;
end STRUCTURAL;
