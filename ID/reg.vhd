library IEEE;
use IEEE.std_logic_1164.all;

entity REG is
    Generic(NBIT: integer);
	Port  ( 
	    D:	In	std_logic_vector(NBIT-1 downto 0);
		CK:	In	std_logic;
		EN: IN std_logic;
		RESET:	In	std_logic;
		Q:	Out	std_logic_vector(NBIT-1 downto 0));
end REG;


architecture PIPPO of REG is -- flip flop D with syncronous reset

begin
	PSYNCH: process(CK,RESET,EN)
	begin
	  if CK'event and CK='1' then -- positive edge triggered:
	    if RESET='1' then -- active high reset 
	      Q <= (others =>'0'); 
	    else
	    if (EN = '1') then
	      Q <= D; -- input is written on output
	    end if;
	    end if;
	  end if;
	end process;

end PIPPO;

architecture PLUTO of REG is -- flip flop D with asyncronous reset

begin
	
	PASYNCH: process(CK,RESET,EN)
	begin
	  if RESET='1' then
	     Q <= (others =>'0');
	  elsif CK'event and CK='1' and EN = '1' then -- positive edge triggered:
	    Q <= D; 
	  end if;
	end process;

end PLUTO;


configuration CFG_REG_PIPPO of REG is
	for PIPPO
	end for;
end CFG_REG_PIPPO;


configuration CFG_REG_PLUTO of REG is
	for PLUTO
	end for;
end CFG_REG_PLUTO;

