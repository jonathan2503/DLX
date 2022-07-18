library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.constants.all;


entity memory_stage is  
Port (
--input from exe
alu_out:  in  std_logic_vector( 31 downto 0);
mem_out: in  std_logic_vector( 31 downto 0);
-- output from stage
Dout_mem:  OUT  std_logic_vector( 31 downto 0);
--input from cu
en4 :    in  std_logic ;
s4  :    in  std_logic ;
w_r4:    in  std_logic ;
clk:    in  std_logic 

);
end memory_stage;





architecture structural of memory_stage is

-- register LMD
    component rf 
    port (
          RF_i: in  std_logic_vector (31 downto 0);
          en  : in  std_logic ;
          Rf_o: out std_logic_vector (31 downto 0);	
          clk: in std_logic)		;
    end component;


--mux 

component MUX21 
    generic(N: integer:=32);
    Port (
    A: in std_logic_vector(N-1 downto 0); --sel= 0
    B: in std_logic_vector(N-1 downto 0); --sel= 1
    sel: in std_logic;
    Y: out std_logic_vector(N-1 downto 0));
end component;


component RAM 
port (
    ADDR:	in	std_logic_vector(address_ram-1 downto 0);
     Din:	in	std_logic_vector(ALL_BITS-1 downto 0);
    Dout:	out	std_logic_vector( 31 downto 0);
    w_r:	in	std_logic;
    r  :    in  std_logic;
    en :    in  std_logic );
end component;
   --------------------------------
--          SIGNAL             --
--------------------------------

signal mux_out: std_logic_vector(31 downto 0) ;
signal RF_out: std_logic_vector(31 downto 0) ;
signal RAM_out: std_logic_vector(31 downto 0) ;
signal r4 : std_logic;


--------------------------------
--          core              --
--------------------------------
begin

    MUX_2: MUX21 GENERIC MAP(N=>32)
    PORT MAP (
               A=> alu_out,
               B=> RAM_out,
               SEL=> S4 ,
               Y=> mux_out); 

   
    MEM_RF: rf  
    port MAP  (    RF_i => mux_out ,
                     en  => EN4  ,
                     Rf_o => RF_out  ,	
                     clk => CLK );


    RAMO : RAM 
            port MAP(
                     ADDR => Alu_out(address_ram-1 downto 0) ,
                     Din  => 	mem_out,
                     Dout => 	 RAM_out,
                     w_r => w_r4,
                     r  =>   r4,
                     en => EN4 );
            

 Dout_mem   <= RAM_out;



   

end structural;