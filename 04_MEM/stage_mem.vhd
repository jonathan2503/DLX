library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity memory_stage is
    generic(addrs: integer:=20);    
Port (
--input from exe
alu_out:  in  std_logic_vector( 31 downto 0);
addr_out: in  std_logic_vector( addrs-1 downto 0);
--input/output from Ram
ADDR_ram:	out	std_logic_vector(addrs-1 downto 0);
Din_ram:	out	std_logic_vector(31 downto 0);
Dout_ram:	in	std_logic_vector( 31 downto 0);
w_r_ram:	out	std_logic;
en_ram :    out  std_logic ;
-- output from stage
Dout_mem:  OUT  std_logic_vector( 31 downto 0);
--input from cu
en4 :    in  std_logic ;
s4  :    in  std_logic ;
w_r4:    in  std_logic ;
CLK:    in  std_logic 

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
   --------------------------------
--          SIGNAL             --
--------------------------------
signal mux_out: std_logic_vector(31 downto 0) ;
signal RF_out: std_logic_vector(31 downto 0) ;
--------------------------------
--          core              --
--------------------------------
begin

    MUX_2: MUX21 GENERIC MAP(N=>32)
    PORT MAP (
               A=> alu_out ,
               B=> Dout_ram,
               SEL=> S4,
               Y=> mux_out); 

   
    MEM_RF: rf  
    port MAP  (    RF_i => mux_out,
                     en  => en4 ,
                     Rf_o =>  RF_out,	
                     clk => CLK );

                     
    ADDR_ram <=  addr_out ;
    Din_ram  <=  alu_out ;       
    w_r_ram   <=  w_r4;
    en_ram    <=  EN4;
    Dout_mem  <=    RF_out ;

   

end structural;