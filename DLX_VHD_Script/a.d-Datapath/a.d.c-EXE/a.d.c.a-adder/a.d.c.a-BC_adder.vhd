
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package high_math is 
	function divide(n:integer; m:integer) return integer;
	function log2(n:integer) return integer;
end high_math;

package body high_math is
	function divide(n:integer; m:integer) return integer is
	begin
		if(n mod m) = 0 then
			return n/m;
		else
			return (n/m)+1;
		end if;
	end divide;
	
	function log2(n:integer) return integer is
	begin
		if n <= 2 then
			return 1;
		else
			return 1 + log2(divide(n,2));
		end if;
	end log2;
end high_math;


----------------------------------------------------------------------------------------------------
--                                             FA                                                --
----------------------------------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all; 

entity FA is 
       
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Ci:	In	std_logic;
		S:	Out	std_logic;
		Co:	Out	std_logic);
end FA; 

architecture BEHAVIORAL of FA is

begin

  S <= A xor B xor Ci ;
  Co <= (A and B) or (B and Ci) or (A and Ci) ;
  
  
end BEHAVIORAL;



----------------------------------------------------------------------------------------------------
--                                             G                                                  --
----------------------------------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_1164.all; 

entity g is 
       
	Port (	
	    Ga:	In	std_logic;
		Gb:	In	std_logic;
		P:	In	std_logic;
		G_out:	Out	std_logic
		);
end g; 

architecture BHE of g is

begin

   G_out <= Ga  or (P and Gb) ;
  
  
end BHE;




----------------------------------------------------------------------------------------------------
--                                             MUX                                                --
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use WORK.constants.all;

entity  mux  IS
    	GENERIC(
		NBIT : integer := N_BIT
	            );
		     
	Port (	A:   	In	std_logic_vector(NBIT -1 downto 0) ;
	    	B:	    In	std_logic_vector(NBIT -1  downto 0);
	    	SEL:	In	std_logic;
	    	Y:	Out	std_logic_vector(NBIT-1  downto 0));

    end mux;

architecture Behav of mux is

begin

process (A, B, SEL)

begin
       if Sel = '1' then
       
       
       	  for I in 0 to NBIT-1 loop
          Y(I) <= A(I);
		  end loop;
       
               
       else   
       	  for I in 0 to NBIT-1 loop
          Y(I) <= B(I);
		  end loop;
       end if;

end process;
End Behav ;




----------------------------------------------------------------------------------------------------
--                                             F_add                                              --
----------------------------------------------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all; 

entity f_add is 
       
	Port (	
	    f_a:	In	std_logic;  --variable of upper block left
		f_b:	In	std_logic;  --variable of upper block reight
		G:	Out	std_logic;  --output of first
		P:	Out	std_logic  --output of second
		);
end f_add; 

architecture bhe of f_add is

begin

   G <= f_a AND f_b ;
   P <= f_a XOR f_b;
  
  
end bhe;






----------------------------------------------------------------------------------------------------
--                                            PG                                                  --
----------------------------------------------------------------------------------------------------


library ieee; 
use ieee.std_logic_1164.all; 

entity pg is 
       
	Port (	
	    Ga:	In	std_logic;  --variable of upper block left
		Gb:	In	std_logic;  --variable of upper block reight
		P1:	In	std_logic;  -- immediate vicinance ci
		P2:	In	std_logic; --shifted of two curry
		G_out:	Out	std_logic;  --output of first
		P_out:	Out	std_logic  --output of second
		);
end pg; 

architecture BHE of pg is

begin

   G_out <= Ga  or (P1 and Gb) ;
   P_out <= P1 and P2  ;
  
  
  
end BHE;


----------------------------------------------------------------------------------------------------
--                                            RCA                                                --
----------------------------------------------------------------------------------------------------


library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity RCA is 

   GENERIC(
		NBIT : integer := N_BIT
	            );
	
	Port (
		A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1  downto 0);
		Ci:	In	std_logic;
		Co:	out	std_logic;
		So:	Out	std_logic_vector(NBIT-1  downto 0));
end RCA; 



architecture STRUCTURAL of RCA is

  signal S_TMP : std_logic_vector(NBIT-1  downto 0);-- buffer somma temporanea
  signal C_TMP : std_logic_vector(NBIT  downto 0);-- buffer di tutti i carry temporanei

  component FA --define full adder

  Port (
     A:	    In	std_logic;
	 B:  	In	std_logic;
	 Ci:	In	std_logic;
	 
	 S:	Out	std_logic;
	 Co:	Out	std_logic);
  end component; 

begin

  C_TMP(0) <= Ci; --structure | - , - ,- ,- , Ci |
  -- S £ Co ->original pos
  
  
  ADDER1:  for I in 1 to NBIT  generate
     FAI : FA  
     Port Map (A(I-1), B(I-1), C_TMP(I-1), S_TMP(I-1), C_TMP(I)); 
  end generate;

  So <= S_TMP;       --associaton if stemp to    S
  Co <= C_TMP(NBIT );    --output last element     | Co , - ,- ,- , - |


end STRUCTURAL;



----------------------------------------------------------------------------------------------------
--                                           CSB                                                  --
----------------------------------------------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity csb is 
    GENERIC(
		ANBIT : integer := N_BIT
	            );
	
	Port (
		A_c:	In	std_logic_vector(ANBIT-1 downto 0);
		B_c:	In	std_logic_vector(ANBIT-1 downto 0);
		Ci_c:	In	std_logic;
		So_c:	Out	std_logic_vector(ANBIT-1 downto 0));
end csb; 





architecture STRUCTURAL of csb is

  signal S_TMP_Ba : std_logic_vector(N_BIT-1 downto 0);-- buffer bA temporanea
  signal S_TMP_Bb : std_logic_vector(N_BIT-1 downto 0);-- buffer bB temporanea

  component RCA 
	GENERIC(
		NBIT : integer := N_BIT
	);
	Port (
		A:	In	std_logic_vector(N_BIT-1 downto 0);
		B:	In	std_logic_vector(N_BIT-1 downto 0);
		Ci:	In	std_logic;
		So:	Out	std_logic_vector(N_BIT-1 downto 0)
	);
  end component; 
  
    component mux
	Port (	A:   	In	std_logic_vector(N_BIT-1 downto 0) ;
	    	B:	    In	std_logic_vector(N_BIT-1 downto 0);
	    	SEL:	In	std_logic;
	    	Y:	Out	std_logic_vector(N_BIT-1 downto 0)
		);
	    	
   end component; 
  
  
  

begin
       Ba: RCA
       --generic map (NBIT =>N_BIT)
       port map (	A => A_c  ,B=> B_c , Ci=> '1', So=> S_TMP_Ba);
       Bb: RCA 
	   --generic map (NBIT =>N_BIT)
	   port map (	A => A_c  ,B=> B_c , Ci=> '0', So=> S_TMP_Bb);
       Mu: mux 
	   --generic map (NBIT =>N_BIT)
	   port map (	A => S_TMP_Ba ,B=> S_TMP_Bb , SEL=> Ci_c , Y=> So_c);
       
end STRUCTURAL;



