library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use IEEE.NUMERIC_STD.all;

entity ControlUnit is 
	port(	 
		clk : in std_logic;
	    opcode : in std_logic_vector(3 downto 0);
		REGWRITE_p : out std_logic;
		ALUSRC1_p : out std_logic; 
		ALUOP_p :  out std_logic_vector(3 downto 0)
		);
end ControlUnit;	

architecture behavioral of ControlUnit is 
constant ADD : std_logic_vector(3 downto 0) := "0000";
constant ORR : std_logic_vector(3 downto 0) := "0001";
constant COUNT : std_logic_vector(3 downto 0) := "0010";
constant SHIFT : std_logic_vector(3 downto 0) := "0011";  
constant SHIFTHALF : std_logic_vector(3 downto 0) := "0100";
constant ADD2 : std_logic_vector(3 downto 0) := "0101";	
constant SUB2 : std_logic_vector(3 downto 0) := "0110";
constant ADD4 : std_logic_vector(3 downto 0) := "0111";
constant SUB4 : std_logic_vector(3 downto 0) := "1000";
constant ADD4SAT : std_logic_vector(3 downto 0) := "1001";
constant SUB4SAT : std_logic_vector(3 downto 0) := "1010"; 
constant MULT : std_logic_vector(3 downto 0) := "1011";
constant SUB8 : std_logic_vector(3 downto 0) := "1100";	

SIGNAL ALUSRC1, REGWRITE : STD_LOGIC; 
SIGNAL ALUOP : STD_LOGIC_vector(3 downto 0); 
begin 

	process(opcode)
		begin
			if (opcode = "0000") then
				ALUSRC1 <= '1';	
				REGWRITE <= '1';
				ALUOP <= ADD;
			elsif (opcode = "0001") then
				ALUSRC1 <= '1';	
				REGWRITE <= '1';
				ALUOP <= ADD;
			elsif (opcode = "0010") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= ADD;
			elsif (opcode = "0011") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= ORR;	   
			elsif (opcode = "0100") then 
				ALUSRC1 <= '1';	
				REGWRITE <= '1';
				ALUOP <= COUNT;
			elsif (opcode = "0101") then 
				ALUSRC1 <= '1';	
				REGWRITE <= '1';
				ALUOP <= COUNT;
			elsif (opcode = "0110") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= SHIFT;	  
			elsif (opcode = "0111") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= SHIFTHALF;		
			elsif (opcode = "1000") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= ADD2;			
			elsif (opcode = "1001") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= SUB2;
			elsif (opcode = "1010") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= ADD4;
			elsif (opcode = "1011") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= SUB4;
			elsif (opcode = "1100") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= ADD4SAT;		  
			elsif (opcode = "1101") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= SUB4SAT;
			elsif (opcode = "1110") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= MULT;	 
			elsif (opcode = "1111") then 
				ALUSRC1 <= '0';	
				REGWRITE <= '1';
				ALUOP <= SUB8;	
			else 
				null;
			end if;		
	end process;  
	
	PROCESS	(clk, REGWRITE, ALUSRC1, ALUOP)
 	BEGIN
	if(clk'EVENT) AND (Clk = '1') then
		REGWRITE_p <= REGWRITE;
		ALUSRC1_p <= ALUSRC1;
		ALUOP_p <= ALUOP;
	end if;
	end process;
end behavioral;
	