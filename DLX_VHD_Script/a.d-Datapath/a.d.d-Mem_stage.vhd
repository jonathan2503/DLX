library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity memory_stage is  
Port (
--input from exe
RST : in  std_logic;
alu_out:  in  std_logic_vector( 31 downto 0);--OK
mem_out: in  std_logic_vector( 31 downto 0);--OK
RD:   in  std_logic_vector( 4 downto 0);--OK


-- output from stage
Dout_mem:  OUT  std_logic_vector( 31 downto 0);--OK
alu_out_ext:  out  std_logic_vector( 31 downto 0);
RD_EXT_MEM: OUT std_logic_vector(4 downto 0);


--input/OUTPUT fOR RAM
ADDRESS_RAM:   OUT  std_logic_vector( 31 downto 0);--OK
DIN_TO_RAM:   OUT  std_logic_vector( 31 downto 0);
DOUT_FROM_RAM:   in  std_logic_vector( 31 downto 0);--OK
--input from cu
s4  :    in  std_logic_vector(2 downto 0);

en4 :    in  std_logic ;
clk :    in  std_logic 
);
end memory_stage;





architecture structural of memory_stage is

	component REG is
        generic (NBIT:INTEGER);
        Port ( 
        RF_IN: IN std_logic_vector(NBIT-1 DOWNTO 0);
        CLK: IN std_logic;
        RST: IN std_logic;
        ENABLE: IN std_logic;
        RF_OUT: OUT std_logic_vector(NBIT-1 DOWNTO 0)
        );
	end component;


    COMPONENT MUX21 is
        generic(N: integer:=32);
        Port (
        A: in std_logic_vector(N-1 downto 0);
        B: in std_logic_vector(N-1 downto 0);
        sel: in std_logic;
        Y: out std_logic_vector(N-1 downto 0));
        end COMPONENT;

signal out_ext: std_logic_vector (31 downto 0);


begin
--outputs entering into the RAM are not synchronized with the clock
	ADDRESS_RAM <= alu_out;
    DIN_TO_RAM <= MEM_OUT;

	--Once a word is retrived from the RAM it can be masked depending on rh s4 signal
    process(s4,DOUT_FROM_RAM)
	begin 
	case s4 is 
	when "111" => out_ext <= "0000000000000000"& DOUT_FROM_RAM(15 downto 0 ); --lhu
	when "110" => if (DOUT_FROM_RAM(15)='0') then --lh
					out_ext <= "0000000000000000"& DOUT_FROM_RAM(15 downto 0 );
				  elsif (DOUT_FROM_RAM(15)='1') then
					out_ext <= "1111111111111111"& DOUT_FROM_RAM(15 downto 0 );
				  end if;
	when "101" => out_ext <= "000000000000000000000000"& DOUT_FROM_RAM(7 downto 0 );--lbu
	when "100" => if (DOUT_FROM_RAM(7)='0') then --lb
					out_ext <= "000000000000000000000000"& DOUT_FROM_RAM(7 downto 0 );
				  elsif (DOUT_FROM_RAM(7)='1') then
					out_ext <= "111111111111111111111111"& DOUT_FROM_RAM(7 downto 0 );
				  end if;
	when others => out_ext <= DOUT_FROM_RAM;
	end case;
	end process;


   
                                      
--outputs entering into the next stage are synchronized with the clock
    Dout_mem_RF : REG generic map (NBIT   => 32 )
        Port map (
        RF_IN   => out_ext,
        CLK     => CLK ,
        RST     => RST,
        ENABLE  => EN4,
        RF_OUT  => Dout_mem
    ); 
	
	alu_outC : REG generic map (NBIT   => 32 )
        Port map (
        RF_IN   => alu_out,
        CLK     => CLK ,
        RST     => RST,
        ENABLE  => EN4,
        RF_OUT  => alu_out_ext
    );

	REG_RD_EXE : REG generic map (NBIT   => 5 )
        Port map (
        RF_IN   => RD ,
        CLK     => clk ,
        RST     => RST,
        ENABLE  => EN4,
        RF_OUT  => RD_EXT_MEM
        ); 

       




end structural;
