library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;


-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test.asm.mem"

entity IRAM is
  generic (
    RAM_DEPTH : integer := 1000;
    I_SIZE : integer := 32);
  port (
	CLK  : in std_logic;
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );

end IRAM;

architecture IRam_Bhe of IRAM is

  type RAMtype is array (0 to RAM_DEPTH - 1) of std_logic_vector(I_SIZE - 1 downto 0);-- std_logic_vector(I_SIZE - 1 downto 0);

  signal IRAM_mem : RAMtype;

begin  -- IRam_Bhe

	run: process (ClK)
		begin
			if ClK'event and ClK='1' then
				Dout <= IRAM_mem(conv_integer(unsigned(Addr)));
			end if;
	end process;
  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  FILL_MEM_P: process (Rst)
    file mem_fp: text;
	variable fstatus1 : FILE_OPEN_STATUS;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(I_SIZE-1 downto 0);
	variable data : std_logic_vector(I_SIZE-1 downto 0);
  begin  -- process FILL_MEM_P
    if (Rst = '1') then
      file_open(fstatus1,mem_fp,"testbench/test.asm",READ_MODE);
      while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        read(file_line,tmp_data_u);
        IRAM_mem(index) <= tmp_data_u;       
        index := index + 1;
      end loop;
    end if;
  end process FILL_MEM_P;

end IRam_Bhe;
