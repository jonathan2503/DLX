library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity DEMUX1N is
Port (
iin: in std_logic_vector( 31 downto 0);
oout: out std_logic_vector( 63 downto 0);
sel: in std_logic
);
end DEMUX1N;



-- whit only two possibility 
architecture DE2 of DEMUX1N is
begin

process(sel,iin)
begin
if (sel = '0') then
 oout(31 downto 0) <= iin ;
 oout(63 downto 32) <= (others => '-') ;
else
    oout(31 downto 0) <= (others => '-') ;
    oout(63 downto 32) <= iin ;
end if;

end process;
end DE2;