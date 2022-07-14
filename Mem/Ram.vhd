--
--Introduction--
-- IM instruction:  | opcode| RS1 | RD | IMM |
--                  |   5   |  5  |  5 |  16 | 
--   n
-- Number of address: 2^16 + 2^5 = 2'097'152 => 2'048 byte = 2 kbyte




--
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity RAM is 

		port (
	    --input--
			ADDR:	in	std_logic_vector(19 downto 0); --21 bit = RD + IMM
			 Din:	in	std_logic_vector(ALL_BITS-1 downto 0); --32 BIT
		--output--
			Dout:	out	std_logic_vector( 31 downto 0);
		--Control--
			--clk:	in	std_logic;  --syncronous locked
			w_r:	in	std_logic;  -- control if w_r=0 w mode ; r=>1 r mode;
			r  :    in  std_logic;  -- reset 
			en :    in  std_logic ); -- enable )
end RAM ; 

architecture behevioural of RAM is
begin
process
type mem is array (integer range 0 to 65568) of std_logic_vector(31 downto 0);

variable RAMs: mem ;



begin
--if ( r = '1')	then
--	RAMs <=  (others=>'0') 
--end if ;	
	
if ( en = '1' ) then
	Dout <= (others=>'X');
	
else 
	if    ( w_r ='1' ) then -- read mode
     Dout <= RAMs( to_integer(unsigned(ADDR)));
	 
	else  -- write mode
	RAMs( to_integer(unsigned(ADDR))) := Din ;

	end if ;


end if;




end process ;
end behevioural;









