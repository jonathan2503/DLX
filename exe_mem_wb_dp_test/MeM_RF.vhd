library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity rf is 
port (
	  RF_i: in  std_logic_vector (31 downto 0);
	  en  : in  std_logic ;
	  Rf_o: out std_logic_vector (31 downto 0);	
	  clk: in std_logic );
end rf ; 


architecture behevioural of rf is
	subtype word is std_logic_vector(31 downto 0);
begin
	
	process (RF_i , en , clk )  is 
	variable aka : word ;
	begin

	if ClK'event and ClK='1' then

    if ( RF_i(0) = 'Z' ) then
	         if (en = '0') then
			Rf_o <= ( others => 'Z') ;
			else
			Rf_o <= aka ;
			end if ;
	else
	    aka :=  RF_i ; 
		if (en = '1') then
			Rf_o <= aka ;
		else 
			Rf_o <= ( others => 'Z') ;
		end if;
	end if;
    end if; 
	end process;

end behevioural;
	