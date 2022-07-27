library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity flag is 
port (
	  en:   in  std_logic ;  
	  Hold:   in  std_logic ;  
	  C :   in  std_logic ;        
	  Z :   in  std_logic ;
	  C_o :   OUT  std_logic ;        
	  Z_o :  OUT  std_logic 
	  );
end flag ; 


architecture behevioural of flag is
subtype flag_array is std_logic_vector(1 downto 0); -- | Z , C |
begin                                               -- | 1 , 0 |                                     
	
	process ( C , Z ,en ,Hold)  is 
	variable flags : flag_array ;
	begin
-- tracking the input
if  (C = 'U') OR ( Z = 'U' ) OR (C = 'Z') OR ( Z = 'Z' )   then

	flags(1) :=  '0';
	flags(0) :=  '0';
	Z_o <='0';
	C_o <= '0';
end if;

    if (Hold = '0') AND ( en = '1' ) then
		flags(1) :=  Z;
	    flags(0) :=  C;
		Z_o <= Z;
	    C_o <= C;
	elsif (Hold = '0') AND ( en = '0' ) then
		flags(1) := Z;
		flags(0) :=  C;
		Z_o <= 'Z' ;
		C_o <= 'Z' ; 
	elsif (Hold = '1') AND ( en = '1' ) then
		Z_o <= flags(1);
		C_o <= flags(0);
	elsif (Hold = '1') AND ( en = '0' ) then
		Z_o <= 'Z' ;
		C_o <= 'Z' ; 
	end if ;
		

	end process;

end behevioural;
	

