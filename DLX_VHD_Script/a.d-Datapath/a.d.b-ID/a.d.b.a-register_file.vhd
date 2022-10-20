library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity register_file is
	generic(
		size_word : integer := 32;
		addr: integer := 5;
		addr_num : integer := 32
	);
	port ( 
		--CONTROL SIGNAL
		CLK 		:IN std_logic;
		RESET		:IN std_logic;
		READ_EN_ONE	:IN std_logic;
		READ_EN_TWO	:IN std_logic;
		WRITE_EN	:IN std_logic;
		--GENERAL SIGNAL
		ADDR_READ_ONE	:IN std_logic_vector(addr-1 downto 0);
		ADDR_READ_TWO	:IN std_logic_vector(addr-1 downto 0);
		ADDR_WRITE	:IN std_logic_vector(addr-1 downto 0);
		DATA_WRITE	:IN std_logic_vector(size_word-1 downto 0);
		DATA_OUT_ONE:OUT std_logic_vector(size_word-1 downto 0);
		DATA_OUT_TWO:OUT std_logic_vector(size_word-1 downto 0)
	);
end register_file;

architecture A of register_file is

    -- suggested structures
    subtype REG_ADDR is natural range 0 to addr_num-1; -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(size_word-1 downto 0); 
	signal REGISTERS : REG_ARRAY; 
	
begin 
	--multiple operations can be performed in parallel, in case of reset all cells are set to 0
	A0:process(RESET,READ_EN_ONE,READ_EN_TWO,WRITE_EN,ADDR_READ_ONE,ADDR_READ_TWO,ADDR_WRITE,DATA_WRITE,REGISTERS)
	begin
			if RESET = '1' then
				REGISTERS <= (others => (others => '0'));
				DATA_OUT_ONE <= (others => '0');
				DATA_OUT_TWO <= (others => '0');
			else
					if READ_EN_ONE = '1' then
						DATA_OUT_ONE <= REGISTERS(to_integer(unsigned(ADDR_READ_ONE)));
					end if;
					
					if READ_EN_TWO = '1' then
						DATA_OUT_TWO <= REGISTERS(to_integer(unsigned(ADDR_READ_TWO)));
					end if;
					
					if WRITE_EN = '1' then
						REGISTERS(to_integer(unsigned(ADDR_WRITE))) <= DATA_WRITE;
					end if;
				end if;
	end process A0;
end A;



