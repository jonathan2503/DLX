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
s4  :    in  std_logic ;
w_r4:    in  std_logic ;
clk:    in  std_logic ;

-------------- output from stage--------------
Dout_mem:  OUT  std_logic_vector( 31 downto 0)
);
```
### WB
