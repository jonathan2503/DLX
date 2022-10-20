
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


ENTITY cu_stage is
	port(
		Clk: IN std_logic;
		RESET: IN std_logic;
		OPCODE : IN std_logic_vector(5 downto 0);
		FUNC : IN std_logic_vector(10 downto 0);
        HZ   : IN std_logic;
		JUMP_NOTJUMP: IN std_logic;
		--if stage --2
		EN_IF : OUT std_logic;
		SEL_PC : OUT std_logic;
		--id stage --5
		READ_EN_ONE : OUT std_logic;
		READ_EN_TWO : OUT std_logic;
		S_U_ID	  : OUT std_logic;
		
		ENABLE		: OUT std_logic;
		SEL_IMM : OUT std_logic;
		SEL_RD : OUT std_logic;
		
		--EXE STAGE --24
		--EN_3 : OUT std_logic;
		S3_0 : OUT std_logic;
		S3_1 : OUT std_logic;
		ADD_SUB : OUT std_logic;
		flag_en : OUT std_logic;
		C_EN : OUT std_logic;
		R_L : OUT std_logic;
		L_A : OUT std_logic;
		S_R : OUT std_logic; --16
		L_s_cho : OUT std_logic_vector(3 downto 0); --20
		z_enab : OUT std_logic; --21
		C3 : OUT std_logic_vector(2 DOWNTO 0); --24
		SEL42 : OUT std_logic_vector(2 DOWNTO 0);--27
		EQ :  OUT std_logic; 
		NE :  OUT std_logic; 
		j_and_jal: OUT std_logic; --30
		GT: OUT std_logic;
		LD: OUT std_logic;
		S_U :OUT std_logic;
		-- mem stage --3
		s4	  :    OUT 	std_logic_vector(2 downto 0);
		en4   :    OUT  std_logic;
		w_r4  :    OUT  std_logic;
		en_ram:     OUT  std_logic;
		--wb stage --2
		CTR_MUX	:    OUT  std_logic;
		WRITE_EN	: OUT std_logic;
        
		--hz
		WRITE_EN_EXE : OUT std_logic ;
		WRITE_EN_MEM : OUT std_logic 

	);
	
end cu_stage;



architecture behevioural of cu_stage is
	component REG_CU is
			generic (LBIT_UP:INTEGER ; LBIT_DOWN:INTEGER ;RBIT_UP:INTEGER ;RBIT_DOWN:INTEGER   );
			Port ( 
					RF_IN: IN std_logic_vector(LBIT_UP DOWNTO LBIT_DOWN);
					CLK: IN std_logic;
					RST: IN std_logic;
					ENABLE: IN std_logic;
					RF_OUT: OUT std_logic_vector(RBIT_UP DOWNTO RBIT_DOWN)
);
end component;
constant FONDO     : integer := 41;	
SIGNAL CONTROL_SIG_37 : std_logic_vector(FONDO  downto 0):= (others => '0'); --if
SIGNAL CONTROL_SIG_35 : std_logic_vector(FONDO  downto 1):=(others => '0'); --id
SIGNAL CONTROL_SIG_29 : std_logic_vector(FONDO  downto 7):=(others => '0'); --exe
SIGNAL CONTROL_SIG_5 : std_logic_vector(FONDO  downto 33):=(others => '0'); --mem
SIGNAL CONTROL_SIG_2 : std_logic_vector(FONDO  downto 36):=(others => '0');--wb
SIGNAL EN_REG_37_35: STD_LOGIC:='1';
SIGNAL RF_READ_JUMP_1: STD_LOGIC:='1';
SIGNAL RF_READ_JUMP_2: STD_LOGIC:= '1';
SIGNAL CONTROL_SIG_JUMP_4 : std_logic_vector(1  downto 0):=(others => '0');--wb
SIGNAL CONTROL_SIG_JUMP_3 : std_logic_vector(1  downto 0):=(others => '0');--wb
SIGNAL CONTROL_SIG_JUMP_2 : std_logic_vector(1  downto 0):=(others => '0');--wb
SIGNAL CONTROL_SIG_JUMP_1 : std_logic_vector(1  downto 0):=(others => '0');--wb

begin

EN_REG_37_35 <= not(HZ);


-- when HZ is detected high the enable signals of the output registers of the fetch and decode stages are set to '0'.
--In such a way the inputs of the first two stages are constants until HZ is set low
process (HZ)	
begin	
IF ( HZ = '0') THEN --NO HZ
    EN_IF <= '1'; --EN_IF
	ENABLE <= '1'; --EN_ID


ELSIF ( HZ = '1') THEN --ON MEM
	EN_IF <= '0';	--EN_IF
	ENABLE <= '0';	--EN_ID
END IF;
end process;



process (OPCODE,FUNC)
--nop	
	begin

--CONTROL_SIG_37(7) <= '1';	--EN_3, ASSEGNATO SOLO QUA
CONTROL_SIG_37(33)<= '1';	--en4
CONTROL_SIG_37(38)<= '0';	--en_ram


case OPCODE is

	
------------------------------------------------------------------------	
--                      RESET OPERATION                               --
------------------------------------------------------------------------
			when "000000" =>  
			                --CONTROL_SIG_37    <= (others=>'0');
			                --CONTROL_SIG_37(0) <= '1';
					case FUNC is
						when "00000000100" =>  --sll
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '1';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"010";	--C3
							CONTROL_SIG_37(26 downto 24) <= "010";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000000110" =>  --srl
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"010";	--C3
							CONTROL_SIG_37(26 downto 24) <= "010";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						
						when "00000000111" =>  --sra
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '1';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"010";	--C3
							CONTROL_SIG_37(26 downto 24) <= "010";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
					
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						
						when "00000100000" =>  --add
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000100001" => --addu
														 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						
						when "00000100010" => --sub
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000100011" =>  --subu
														 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						
						when "00000100100" =>  --and
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"1000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"001";	--C3
							CONTROL_SIG_37(26 downto 24) <= "001";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000100101" => --or
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"1110";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"001";	--C3
							CONTROL_SIG_37(26 downto 24) <= "001";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000100110" =>  --xor
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0110";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"001";	--C3
							CONTROL_SIG_37(26 downto 24) <= "001";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000101000" =>  --seq
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000101001" => --sne
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '1';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						
						when "00000101010" =>  --SLT
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '1';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN

						when "00000101011" =>  --sgt 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '1';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000101100" =>  --sle
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '1';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						
						when "00000101101" =>  --sge
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '1';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						
						when "00000110000" =>  --movi2s
								--NOT IMPLEMENTABLE
						when "00000110001" =>  --movs2i
								--NOT IMPLEMENTABLE
						when "00000110010" =>  --movf
								--NOT IMPLEMENTABLE
						when "00000110011" =>  --movd
								--NOT IMPLEMENTABLE
						when "00000110100" => --movfp2i
								--NOT IMPLEMENTABLE
						when "00000110101" => --movi2fp
								--NOT IMPLEMENTABLE
						when "00000110110" => --movi2t
								--NOT IMPLEMENTABLE
						when "00000110111" => --movt2i
								--NOT IMPLEMENTABLE
						when "00000111010" => --sltu
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '1';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000111011" => --sgtu
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '1';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000111100" => --SLEU
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '1';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when "00000111101" => --SGEU
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '1';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '1';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '1';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
						when others =>
							CONTROL_SIG_37    <= (others=>'0');
							
					end case;
			when "000010" =>  --J
							 
							CONTROL_SIG_37(2) <= '0';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '1';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '0';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "011";	--SEL42, 
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '1';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(33)<= '0';	--en4
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '0';	--WRITE_EN

			when "000011" => --JAL
							CONTROL_SIG_37(2) <= '0';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '1';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '0';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "011";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '1';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(33)<= '1';	--en4
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "000100" => --beqz	
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '0';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "011";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '1';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(33)<= '0';	--en4
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '0';	--WRITE_EN			
			
			when "000101" => --bnez
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '0';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "011";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '1';	--NE
							CONTROL_SIG_37(29)<= '1';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(33)<= '0';	--en4
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '0';	--WRITE_EN
			
			when "000110" => --bfpt 	? NOT IMPLEMENTABLE
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "011";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(33)<= '0';	--en4
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '0';	--WRITE_EN
					
			when "000111" => --bfpf
						   --NOT IMPLEMENTABLE
			
			when "001000" => --addi
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0  --gli ho invertiti 
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "001001" => --addui
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0  --gli ho invertiti 
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
							
			when "001010" => --subi
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "001011" => --subui
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			
			when "001100" => --andi
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"1000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"001";	--C3
							CONTROL_SIG_37(26 downto 24) <= "001";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';    --WRITE_EN
			when "001101" => --ori
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"1110";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"001";	--C3
							CONTROL_SIG_37(26 downto 24) <= "001";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
						
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "001110"=> --xori
							 
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0110";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"001";	--C3
							CONTROL_SIG_37(26 downto 24) <= "001";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "001111" => --lhi
							 
							CONTROL_SIG_37(2) <= '0';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "110";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "010000" => --rfe
								--NOT IMPLEMENTABLE
			
			when "010001" => --trap
								-- NOT IMPLEMENTABLE
			
			when "010010" => --jr
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "101";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '1';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(33)<= '0';	--en4
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '0';	--WRITE_EN
			when "010011" => --jalr
		
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "101";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '1';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U

							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN

			when "010100" => --slli
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '1';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"010";	--C3
							CONTROL_SIG_37(26 downto 24) <= "010";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "010101" => --nop

							CONTROL_SIG_37(2) <= '0';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO

							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '0';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(33)<= '0';	--en4

							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '0';	--WRITE_EN
			when "010110" => --srli

							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"010";	--C3
							CONTROL_SIG_37(26 downto 24) <= "010";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN

			when "010111" => --srai
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '1';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"010";	--C3
							CONTROL_SIG_37(26 downto 24) <= "010";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "011000" => --seqi
							 
						
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "011001" => --snei
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '1';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "011010" => --slti
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '1';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "011011" => --sgti	
							 
						
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '1';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							CONTROL_SIG_37(33)<= '1'; 	--en4
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "011100" => --slei
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '1';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
						
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "011101" => --sgei
							 
						
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho11
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '1';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "100000" => --lb
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							CONTROL_SIG_37(38)<= '1';	--en_ram 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '1';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
							CONTROL_SIG_37(34)<= '1';	--s4(0)
							CONTROL_SIG_37(40)<= '0';	--s4(1)
							CONTROL_SIG_37(41)<= '0';	--s4(0)
			when "100001" => --lh
							 
						
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							CONTROL_SIG_37(38)<= '1';	--en_ram 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '1';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
							CONTROL_SIG_37(34)<= '1';	--s4(2)
							CONTROL_SIG_37(40)<= '1';	--s4(1)
							CONTROL_SIG_37(41)<= '0';	--s4(0)
			when "100011" => --lw
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							CONTROL_SIG_37(38)<= '1';	--en_ram
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							CONTROL_SIG_37(34)<= '0';	--s4(0)
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '1';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
							CONTROL_SIG_37(40)<= '0';	--s4(1)
							CONTROL_SIG_37(41)<= '0';	--s4(0)

				

			when "100100" => --lbu
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							CONTROL_SIG_37(38)<= '1';	--en_ram 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '1';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
							CONTROL_SIG_37(34)<= '1';	--s4(0)
							CONTROL_SIG_37(40)<= '0';	--s4(1)
							CONTROL_SIG_37(41)<= '1';	--s4(0)

	

			when "100101" => -- lhu
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							CONTROL_SIG_37(38)<= '1';	--en_ram 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '1';	--w_r4
							CONTROL_SIG_37(36)<= '1';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
							CONTROL_SIG_37(34)<= '1';	--s4(2)
							CONTROL_SIG_37(40)<= '1';	--s4(1)
							CONTROL_SIG_37(41)<= '1';	--s4(0)
			when "100110" => --lf
			                   --CONTROL_SIG_37(38)<= '1';	--en_ram 
			when "100111" => --ld
			                 --CONTROL_SIG_37(38)<= '1';	--en_ram 
			when "101000" => --sb 
			when "101001" => --sh
			                 --CONTROL_SIG_37(38)<= '1';	--en_ram
			when "101011" => --sw
							 
						
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '1';	--READ_EN_TWO
							CONTROL_SIG_37(38)<= '1';	--en_ram 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '0';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '0';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "000";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '0';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '0';	--WRITE_EN
			when "101110" => --sf
							--NOT IMPLEMENTABLE
			when "101111" => --sd
							--NOT IMPLEMENTABLE
			when "111000" => --itlb
						
			when "111010" => --sltui
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '1';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "111011" => --sgtui
							 
						
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '0';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '1';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "111100" => --sleui
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '0';	--GT
							CONTROL_SIG_37(31)<= '1';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "111101" => --sgeui
							 
							
							CONTROL_SIG_37(2) <= '1';	--READ_EN_ONE
							CONTROL_SIG_37(3) <= '0';	--READ_EN_TWO
							 
							CONTROL_SIG_37(5) <= '0';	--SEL_IMM
			                CONTROL_SIG_37(6) <= '0';	--SEL_RD
							
							CONTROL_SIG_37(8) <= '1';	--S3_0
							CONTROL_SIG_37(9) <= '0';	--S3_1
							CONTROL_SIG_37(10)<= '1';	--ADD_SUB
							CONTROL_SIG_37(11)<= '0';	--flag_en
							CONTROL_SIG_37(12)<= '0';	--C_EN
							CONTROL_SIG_37(13)<= '0';	--R_L
							CONTROL_SIG_37(14)<= '0';	--L_A
							CONTROL_SIG_37(15)<= '0';	--S_R
							CONTROL_SIG_37(19 downto 16) <=	"0000";	--L_s_cho
			                CONTROL_SIG_37(20)<= '1';	--z_enab
							CONTROL_SIG_37(23 downto 21) <=	"000";	--C3
							CONTROL_SIG_37(26 downto 24) <= "100";	--SEL42
							CONTROL_SIG_37(27)<= '1';	--EQ
							CONTROL_SIG_37(28)<= '0';	--NE
							CONTROL_SIG_37(29)<= '0';	--j_and_jal
							CONTROL_SIG_37(30)<= '1';	--GT
							CONTROL_SIG_37(31)<= '0';	--LD
							CONTROL_SIG_37(32)<= '1';	--S_U
							 
							
							CONTROL_SIG_37(35)<= '0';	--w_r4
							CONTROL_SIG_37(36)<= '0';	--CTR_MUX
							CONTROL_SIG_37(37)<= '1';	--WRITE_EN
			when "111111" =>  CONTROL_SIG_37 <= (others=>'1');
         
			when others =>
				
		end case;	
		
end process;


--when JUMP_NOTJUMP is set high all the enables allowing to read and to write registers of the next instruction have to be set low(with the right timing) otherwise there could be false data hazards
process(JUMP_NOTJUMP)
BEGIN
SEL_PC <= JUMP_NOTJUMP;
IF (JUMP_NOTJUMP= '0') THEN --NON C'È IL JUMP
RF_READ_JUMP_1<= '1';--enable reading_1
RF_READ_JUMP_2<='1'; --enable reading_2
CONTROL_SIG_JUMP_4(1) <= '1'; --WRITE_EN
CONTROL_SIG_JUMP_4(0) <= '1'; --EN_RAM 
ELSIF(JUMP_NOTJUMP = '1') THEN --C'È IL JUMP
RF_READ_JUMP_1<= '0';--enable reading_1
RF_READ_JUMP_2<='0'; --enable reading_2
CONTROL_SIG_JUMP_4(1) <= '0'; --WRITE_EN
CONTROL_SIG_JUMP_4(0) <= '0'; --EN_RAM 
END IF;
end process;
			


	R_IF: REG_CU GENERIC MAP(
							LBIT_DOWN=>0 , RBIT_DOWN=>1,
							LBIT_UP  =>FONDO   , RBIT_up=>FONDO   ) 
													
        PORT MAP( RF_IN => CONTROL_SIG_37,
                  CLK => CLK,
                  RST => RESET,
                  ENABLE => EN_REG_37_35,
                  RF_OUT => CONTROL_SIG_35	);
                  
                  
                  
                  

	R_ID: REG_CU 
	          GENERIC MAP(
							LBIT_DOWN=>1 , RBIT_DOWN=>7 ,
							LBIT_UP  =>FONDO   , RBIT_UP=>FONDO   ) 
													
              PORT MAP(
                  RF_IN => CONTROL_SIG_35,
                  CLK => CLK,
                  RST => RESET,
                  ENABLE => '1',
                  RF_OUT => CONTROL_SIG_29	);
                  
	R_EXE: REG_CU 
	          GENERIC MAP(
							LBIT_DOWN=>7 , RBIT_DOWN=>33 ,
							LBIT_UP  =>FONDO   , RBIT_UP=>FONDO   ) 
													
              PORT MAP(
                  RF_IN => CONTROL_SIG_29,
                  CLK => CLK,
                  RST => RESET,
                  ENABLE => '1',
                  RF_OUT => CONTROL_SIG_5	);
                  

	R_MEM: REG_CU 
	          GENERIC MAP(
							LBIT_DOWN=>33 , RBIT_DOWN=>36 ,
							LBIT_UP  =>FONDO   , RBIT_UP=>FONDO   ) 
													
              PORT MAP(
                  RF_IN => CONTROL_SIG_5,
                  CLK => CLK,
                  RST => RESET,
                  ENABLE => '1',
                  RF_OUT => CONTROL_SIG_2	);
-----------------------------------------------JUMP-----------------------------------------------------------------------------
R_J4: REG_CU GENERIC MAP(
							LBIT_DOWN=>0 , RBIT_DOWN=>0,
							LBIT_UP  =>1   , RBIT_up=>1  ) 
													
        PORT MAP( RF_IN => CONTROL_SIG_JUMP_4,
                  CLK => CLK,
                  RST => RESET,
                  ENABLE => '1',
                  RF_OUT => CONTROL_SIG_JUMP_3	);


R_J3: REG_CU GENERIC MAP(
							LBIT_DOWN=>0 , RBIT_DOWN=>0,
							LBIT_UP  =>1   , RBIT_up=>1  ) 
													
        PORT MAP( RF_IN => CONTROL_SIG_JUMP_3,
                  CLK => CLK,
                  RST => RESET,
                  ENABLE => '1',
                  RF_OUT => CONTROL_SIG_JUMP_2	);
                  
                  
R_J2: REG_CU GENERIC MAP(
							LBIT_DOWN=>0 , RBIT_DOWN=>0,
							LBIT_UP  =>1   , RBIT_up=>1  ) 
													
        PORT MAP( RF_IN => CONTROL_SIG_JUMP_2,
                  CLK => CLK,
                  RST => RESET,
                  ENABLE => '1',
                  RF_OUT => CONTROL_SIG_JUMP_1	);
                  
	



--All control signals takes the proper value with the right timing. 

----------------------------------		
--               ID
--_________________________________________
    READ_EN_ONE <= CONTROL_SIG_37(2) AND RF_READ_JUMP_1;  
	READ_EN_TWO <= CONTROL_SIG_37(3)AND RF_READ_JUMP_1;
	SEL_IMM     <= CONTROL_SIG_37(5);
	SEL_RD      <= CONTROL_SIG_37(6);
	S_U_ID 		<= CONTROL_SIG_37(32);
		    
		    
------------------------------------------		    
--               EXE
--_________________________________________

		--EN_3          <= CONTROL_SIG_35(7);  --29
		S3_0          <= CONTROL_SIG_35(8);
		S3_1          <= CONTROL_SIG_35(9);
		ADD_SUB       <= CONTROL_SIG_35(10);
		flag_en       <= CONTROL_SIG_35(11);
		C_EN     	  <= CONTROL_SIG_35(12);
		R_L     	  <= CONTROL_SIG_35(13); 
		L_A    		  <= CONTROL_SIG_35(14);
		S_R    		  <= CONTROL_SIG_35(15);
		L_s_cho 	  <= CONTROL_SIG_35(19 downto 16); --(3 downto 0);
		z_enab  	  <= CONTROL_SIG_35(20);
		C3 			  <= CONTROL_SIG_35(23 downto 21); --(2 DOWNTO 0)
		SEL42		  <= CONTROL_SIG_35(26 downto 24); --(2 DOWNTO 0)
		EQ			  <= CONTROL_SIG_35(27);
		NE		 	  <= CONTROL_SIG_35(28);
		j_and_jal	  <= CONTROL_SIG_35(29);
		GT			  <= CONTROL_SIG_35(30);
		LD			  <= CONTROL_SIG_35(31);
		S_U           <= CONTROL_SIG_35(32);
		WRITE_EN_EXE  <= CONTROL_SIG_35(37) and CONTROL_SIG_JUMP_3(1);
------------------------------------------		    
--               MEM
--_________________________________________
		s4(2) <= CONTROL_SIG_29(34);
		s4(1) <= CONTROL_SIG_29(40);
		s4(0) <= CONTROL_SIG_29(41);
		en4 <= CONTROL_SIG_29(33);--5
		w_r4 <= CONTROL_SIG_29(35);
		WRITE_EN_MEM <= CONTROL_SIG_29(37) and CONTROL_SIG_JUMP_2(1);
		EN_ram <=  CONTROL_SIG_29(38) AND CONTROL_SIG_JUMP_2(0); 
------------------------------------------		    
--               WB
--_________________________________________

		CTR_MUX  <= CONTROL_SIG_5(36); --2
		WRITE_EN <= CONTROL_SIG_5(37) and CONTROL_SIG_JUMP_1(1);



END behevioural;


