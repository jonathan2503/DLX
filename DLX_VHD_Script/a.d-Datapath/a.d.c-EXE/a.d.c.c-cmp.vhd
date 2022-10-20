library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cmp is
Port (

--source of flag
Z : IN std_logic;
C : IN std_logic;
V : IN std_logic;
N : IN std_logic;
--source of CONTROL
EQ: IN std_logic;
NE: IN std_logic;
GT: IN std_logic;
LD: IN std_logic;
S_U: IN std_logic;

--output
Y: OUT std_logic_vector(31 downto 0)
 );
end cmp;

architecture Behavioral of cmp is
SIGNAL unsigned_output: std_logic_vector(31 DOWNTO 0);

begin

--based on the control signals  it's possible to evaluate if some conditions are met or not. 
process(Z,C,V,N,EQ,NE,GT,LD,S_U)

begin 


-----------------------------------
--              EQ 
-----------------------------------
IF (NE = '0' and EQ = '1' and  GT = '0' and LD = '0') then 
  IF (Z = '1' ) then 
     Y <= B"0000_0000_0000_0000_0000_0000_0000_0001";
  else 
     Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
  end if;
-----------------------------------
--              NEQ
-----------------------------------
elsif (NE = '1' and EQ = '0' and  GT = '0' and LD = '0') then                                
IF (Z = '0' ) then 
Y <= B"0000_0000_0000_0000_0000_0000_0000_0001";
  else 
Y<= B"0000_0000_0000_0000_0000_0000_0000_0000";
end if;



-----------------------------------
--              SGE
-----------------------------------
elsif ( NE = '0' and EQ = '1' and GT = '1' and LD = '0') then  

IF (S_U = '0') then  --signed number
    IF (Z='1' OR N=V) THEN --condition to be true
        Y<= B"0000_0000_0000_0000_0000_0000_0000_0001";
    else 
        Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
    end if;
    
elsif (S_U = '1') then --unsigned number
    IF ((C='1' AND Z= '0') or Z= '1') THEN --condition to be true
        Y<= B"0000_0000_0000_0000_0000_0000_0000_0001";
    else 
        Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
    end if;
END IF;


                              

-----------------------------------
--            SGT
-----------------------------------
elsif (NE = '0' and EQ = '0' and GT = '1' and  LD = '0') then 

IF (S_U = '0') then 
    IF (N=V) THEN 
        Y<= B"0000_0000_0000_0000_0000_0000_0000_0001";
    else 
        Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
    end if;
    
ELSIF (S_U = '1') then 
    IF (C='1' AND Z= '0') THEN 
        Y<= B"0000_0000_0000_0000_0000_0000_0000_0001";
    else 
        Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
    end if;
END IF;
    
-----------------------------------
--              SLT
----------------------------------
elsif (NE = '0' and EQ = '0' and GT = '0' and LD = '1' ) then      

IF (S_U = '0') then 
    IF (N /= V) THEN 
        Y<= B"0000_0000_0000_0000_0000_0000_0000_0001";
    else 
        Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
    end if;
    
ELSIF (S_U = '1') then 
    IF (C='0')THEN 
        Y<= B"0000_0000_0000_0000_0000_0000_0000_0001";
    else 
        Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
    end if;
END IF;
-----------------------------------
--              SLE
-----------------------------------
elsif ( NE = '0' and EQ = '1' and  GT = '0' and  LD = '1' ) then
                                
IF (S_U = '0') then 
    IF (Z='1' OR N /= V) THEN 
        Y<= B"0000_0000_0000_0000_0000_0000_0000_0001";
    else 
        Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
    end if;
    
ELSIF (S_U = '1') then 
    IF (C='0' OR Z='1')THEN 
        Y<= B"0000_0000_0000_0000_0000_0000_0000_0001";
    else 
        Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
    end if;
END IF;


else 
Y <= B"0000_0000_0000_0000_0000_0000_0000_0000";
end if;

end process;

end Behavioral;



