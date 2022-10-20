library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity flag is 
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
end flag ; 


architecture behevioural of flag is
signal flags: std_logic_vector(3 downto 0); -- | Z , C |
begin                                               -- | 1 , 0 |                                     
--enable active low, if the enable is active the flags change, otherwise they don't	
	process ( C , Z ,N ,V ,en )  is 

	begin
-- tracking the input


    if  ( en = '0' ) then
        
		flags(3) <=  N;
		flags(2) <=  V;
		flags(1) <=  Z;
	    flags(0) <=  C;
		C_o <= C;
		Z_o <= Z;
		V_o <= V;
		N_o <= N;

	else 
	    N_o <= flags(3); 
	    V_o <= flags(2); 
		Z_o <= flags(1);
		C_o <= flags(0);
	end if ;
		

	end process;

end behevioural;
	

