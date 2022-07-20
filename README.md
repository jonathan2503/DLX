## DLX
Here we will write down the interface between the stages.
### IF

### ID



### EXE
```vhdl

--input from ID stage
in1:  in  std_logic_vector( 31 downto 0);
A:    in  std_logic_vector( 31 downto 0);
in2:  in  std_logic_vector( 31 downto 0);
B:    in  std_logic_vector( 31 downto 0);

--input from CU
S3_1:    in  std_logic ;
-- if s3_1 = '0' then  mux_out_1= in1
-- if s3_1 = '1' then  mux_out_1= A
S3_2:    in  std_logic ;
-- if s3_2 = '0' then  mux_out_2= in2
-- if s3_2 = '1' then  mux_out_2= B
ALU1:    in  std_logic ;
-- if ALU1 = '0' then  mux_out_1 GO to adder
-- if s3_2 = '1' then  mux_out_1 GO to gnd
ALU2:    in  std_logic ;
-- if ALU1 = '0' then  mux_out_2 GO to adder
-- if s3_2 = '1' then  mux_out_2 GO to gnd
S3_3:    in  std_logic ;
-- if S3_3 = '0' then  no flags will be active
-- if S3_3 = '1' then  flag active
en:      in  std_logic ;
holds:   in  std_logic ;
-- if holds = '0' then  the flag can't hold a value and track the carry signal in input
-- if holds = '1' then  flag active hold the previeus value also if the input change 
--( so in next stage is possible to read the value) 
clk:     in  std_logic ;


-- output from stage
alu_out:  OUT  std_logic_vector( 31 downto 0)
    );
end  exe_stage;

```


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
