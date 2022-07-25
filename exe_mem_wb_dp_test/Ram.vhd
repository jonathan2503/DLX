--Introduction--
-- IM instruction:  | opcode| RS1 | RD | IMM |
--                  |   5   |  5  |  5 |  16 | 
--   n
-- Number of address: 2^16 + 2^5 = 2'097'152 => 2'048 byte = 2 kbyte
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity RAM is 

		port (
	    --input--
			ADDR:	in	std_logic_vector(20 downto 0); --21 bit = RD + IMM
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

process ( en ,w_r ,Din ) is 


type mem is array (integer range 0 to 65568) of std_logic_vector(31 downto 0);
variable RAMs: mem ;
variable address : integer;
begin 	
if ( en = '0' ) then
	Dout <= (others=>'Z');
	
else 
	if    ( w_r ='1' ) then -- read mode
    Dout <= RAMs( to_integer(unsigned(ADDR)));
	-- Dout <= (others=>'0');
	else  -- write mode
	RAMs( to_integer(unsigned(ADDR))) := Din ;
	--Dout <= (others=>'1');
	end if ;


end if;
end process;




end behevioural;









