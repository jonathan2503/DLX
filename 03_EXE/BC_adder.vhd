----------------------------------------------------------------------------------------------------
--                                            HIGH MATE                                           --
----------------------------------------------------------------------------------------------------

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

  --signal S_TMP : std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1  downto 0);-- buffer somma temporanea
 -- signal C_TMP : std_logic_vector(NBLOCKS-1  downto 0);               -- buffer di tutti i carry temporanei
  
begin
      blo:  for I in 1 to NBLOCKS  generate
       cbl : csb
			--generic map (ANBIT => NBIT_PER_BLOCK)
			Port Map ( 
				A(NBIT_PER_BLOCK*I-1 downto NBIT_PER_BLOCK*(I-1)), 
				B(NBIT_PER_BLOCK*I-1 downto NBIT_PER_BLOCK*(I-1)), 
				Ci(I-1), S(NBIT_PER_BLOCK*I-1 downto NBIT_PER_BLOCK*(I-1))
			); 
            end generate;
			
end STRUCTURAL;

configuration CFG_SUM_GENERATOR_STRUCTURAL of SUM_GENERATOR is
  for STRUCTURAL 
	for blo
		for all : csb
			use configuration work.CFG_CSB_STRUCTURAL;
		end for;
	end for;
  end for;
end CFG_SUM_GENERATOR_STRUCTURAL;


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
  
 ---------------END g adderbasic adder--------------------------------- 
 type SignalVector is array(NBIT downto 1) of std_logic_vector(NBIT downto 1);
 signal P_1 : std_logic_vector(NBIT downto 1);
 signal G_1 : std_logic_vector(NBIT downto 1);
 signal C_G : SignalVector;
 signal C_P : SignalVector;
 constant layers : integer := log2(NBIT);
 
 begin
	--step1 get pg net work
	R0: for i in 0 to NBIT-1  generate
         R0_0: f_add Port Map ( f_a=> A(i),f_b => B(i) , G =>C_G(i+1)(i+1), P =>C_P(i+1)(i+1));
    end generate R0;
	Co(0) <= Cin;
	
		R1: for i in 1 to layers generate
			R2: for j in 1 to NBIT generate
				-- get G block
				IFG: if ((j mod 2**i = 0 or j mod NBIT_PER_BLOCK = 0) and j> 2**(i-1) and j <= 2**i) generate
					G_B: g 
						Port Map(
							Ga => C_G(j)(2**(i-1)+1),
							Gb => C_G(2**(i-1))(1),
							P  => C_P(j)(2**(i-1)+1),						
							G_out => C_G(j)(1)
							
						);
					res1: if j mod NBIT_PER_BLOCK = 0 generate
						Co(j/NBIT_PER_BLOCK) <= C_G(j)(1);
					end generate res1;
				end generate IFG;
				IFP0: if j/2**i >= 1 and j mod 2**i > 0 and ((j - 2**i) > 2**(i-1)) and j < 2**(i+1)and (j mod NBIT_PER_BLOCK = 0)generate
					PG_B0: pg
						Port Map(
							Ga => C_G(j)((j/2**(i-1))*2**(i-1)+1),
							Gb => C_G((j/2**(i-1))*2**(i-1))((j/2**(i-1))*2**(i-1)-2**(i-1)+1),
							P1 => C_P(j)((j/2**(i-1))*2**(i-1)+1),
							P2 => C_P((j/2**(i-1))*2**(i-1))((j/2**(i-1))*2**(i-1)-2**(i-1)+1),
							G_out => C_G(j)((j/2**(i-1))*2**(i-1)-2**(i-1)+1),
							P_out => C_P(j)((j/2**(i-1))*2**(i-1)-2**(i-1)+1)
						);
				end generate IFP0;
				ifP1: if j/2**i > 1 and j mod 2**i =0 generate
					PG_B1:pg
						Port Map(
							Ga => C_G(j)(j-2**(i-1)+1),
							Gb => C_G(j-2**(i-1))(j-2**i+1),
							P1 => C_P(j)(j-2**(i-1)+1),
							P2 => C_P(j-2**(i-1))(j-2**i+1),
							G_out => C_G(j)(j-2**i+1),
							P_out => C_P(j)(j-2**i+1)
						);
				end generate IFP1;
			end generate R2;
		end generate R1;
end STRUCTURAL;


configuration CFG_CARRY_GENERATOR_STRUCTURAL of CARRY_GENERATOR is
  for STRUCTURAL
	for R0
		for all : f_add
			use configuration WORK.CFG_F_ADD_STRUCTURAL;
		end for;
	end for;
	for R1
		for R2 
			for IFG
				for all : g
					use configuration WORK.CFG_G_BHE;
				end for;
			end for;
			for IFP0
				for all : pg
					use configuration WORK.CFG_PG_BHE;
				end for;
			end for;
			for IFP1
				for all : pg
					use configuration WORK.CFG_PG_BHE;
				end for;
			end for;
		end for;
	end for;
  end for;
end CFG_CARRY_GENERATOR_STRUCTURAL;



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
		
		Co:	Out	std_logic_vector(NBIT/NBIT_PER_BLOCK downto 0)
	);
end component; 



 signal C_TMP : std_logic_vector(NBIT/N_subdiv downto 0);-- buffer somma temporanea
 signal A_TMP : std_logic_vector(NBIT-1 downto 0);-- buffer somma temporanea
 signal B_TMP : std_logic_vector(NBIT-1 downto 0);-- buffer somma temporanea
 -- signal C_TMP : std_logic_vector(NBLOCKS-1  downto 0);               -- buffer di tutti i carry temporanei
  
begin


	UCARRY : CARRY_GENERATOR
		--GENERIC Map (
		--	NBIT => NBIT,
		--	NBIT_PER_BLOCK => N_subdiv
		--)
		Port Map(
			A => A, 
			B => B, 
			Cin =>Cin, 
			Co => C_TMP
		);
		
	USUM : SUM_GENERATOR
		--GENERIC Map (
        --   NBIT_PER_BLOCK => N_BIT,
		--    NBLOCKS	=> N_Block 
		--)
		Port Map ( 
			A => A,
            B => B,
            Ci =>c_TMP(NBIT/N_subdiv-1 downto 0),
			S => S 
		);		

	Cout <= c_TMP(NBIT/N_subdiv);
      
end STRUCTURAL;

configuration CFG_P4_ADDER_STRUCTURAL of P4_ADDER is
  for STRUCTURAL 
	for all : CARRY_GENERATOR
		use configuration work.CFG_CARRY_GENERATOR_STRUCTURAL;
	end for;
	for all : SUM_GENERATOR
		use configuration work.CFG_SUM_GENERATOR_STRUCTURAL;
	end for;
  end for;
end CFG_P4_ADDER_STRUCTURAL;
-----------------------------------------------------------------------------------
                                           --MUX21
-----------------------------------------------------------------------------------       

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity MUX21 is
 GENERIC(
		NBIT : integer := ALL_BITS 
	);
	
port(
A: IN std_logic_vector( NBIT -1 DOWNTO 0);
B: IN std_logic_vector( NBIT -1 DOWNTO 0);
S: IN std_logic;
Y: OUT std_logic_vector( NBIT -1 DOWNTO 0)
);
END entity;

architecture BEHAV of MUX21 is
begin

process(A,B,S)
begin
if (S = '0') then
Y <= a;
elsif (S = '1')then
y <= b;
end if;
end process;
end BEHAV;

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
		ADD_SUB: In std_logic;
		Cin:	In	std_logic;
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
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Cout:	Out	std_logic
	);
		
		
end component; 


component MUX21 is
 GENERIC(
		NBIT : integer := ALL_BITS 
	);
	
port(
A: IN std_logic_vector( NBIT -1 DOWNTO 0);
B: IN std_logic_vector( NBIT -1 DOWNTO 0);
S: IN std_logic;
Y: OUT std_logic_vector( NBIT -1 DOWNTO 0)
);
END component;

Signal B_2: std_logic_vector( NBIT -1 DOWNTO 0);
begin
m: MUX21 port map (B, std_logic_vector(unsigned(NOT(B))+1),ADD_SUB,B_2);
a2: P4_ADDER PORT MAP (A,B_2,Cin,S,Cout);
      
end STRUCTURAL;



