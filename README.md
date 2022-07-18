## DLX
Here we will write down the interface between the stages.
### IF

### ID



### EXE

### MEM
```vhdl
---------------input from exe---------------
alu_out:  in  std_logic_vector( 31 downto 0); --this signal come from ALU_Out register
mem_out: in  std_logic_vector( 31 downto 0);  --this signal come from mem register

-----input from cu-----
en4 :    in  std_logic ;
       -- if en4 = '0'\ stage do not work
       -- if en4 = '1'\  stage active
s4  :    in  std_logic ;
       -- if s4 = '0'\ mux_out= data from memory stage (bypass the Ram)
       -- if s4 = '1'\ mux_out=  data from Ram
w_r4:    in  std_logic ;
       -- if w_r4 = '0'\ ram is in write mode
       -- if w_r4 = '1'\  ram is in read mode
clk:    in  std_logic ;

-------------- output from stage--------------
Dout_mem:  OUT  std_logic_vector( 31 downto 0)
```
### WB
