
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity RAM is 
		port (
	    --input--
			CLK :   in  std_logic;
			RST : 	in	std_logic;
			ADDR:	in	std_logic_vector(31 downto 0); ---
			Din:	in	std_logic_vector(ALL_BITS-1 downto 0); --32 BIT
		--output--
			Dout:	out	std_logic_vector( 31 downto 0);
		--Control--
			
			w_r:	in	std_logic;  -- control if w_r=0 w mode ; r=>1 r mode;
			en :    in  std_logic ); -- enable )
end RAM ; 




architecture Behavioral of RAM is

type ram_type is array (0 to 31) of std_logic_vector(31 downto 0);
signal ram : ram_type;

begin

process(RST,EN,W_R,ADDR,DIN,CLK) is
begin
if (RST = '1') then
ram <= (others =>(others =>'0'));
elsif (rising_edge(CLK)) then
if (EN = '1' AND w_r = '0') then
ram(to_integer(unsigned(ADDR))) <= Din;
end if;
if (EN = '1' AND w_r = '1') then
Dout <= ram(to_integer(unsigned(ADDR)));
end if;
end if;
end process;
end Behavioral;











