library IEEE;
use IEEE.STD_LOGIC_1164.all; 
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity InstructionFetch is 
	port(
		clk : in std_logic;
		instruction_p : in std_logic_vector(15 downto 0);
		REGWRITE_ppp : in std_logic;
		ALU_result : in STD_LOGIC_VECTOR(63 downto 0);		  -- 64 bits per register 
		write_data : in std_logic_vector(63 downto 0);
		write_register_pp : in std_logic_vector(3 downto 0);
		
		read_data_1_p : out std_logic_vector(63 downto 0);
		read_data_2_p: out std_logic_vector(63 downto 0);
		opcode_p : out std_logic_vector(3 downto 0);
		reg2_address : out std_logic_vector(3 downto 0);
		write_register_ppp : out std_logic_vector(3 downto 0)
		);
end InstructionFetch;	 

architecture dataflow of InstructionFetch is	
TYPE register_file IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (63 DOWNTO 0); 			
signal register_array: register_file := (others => X"0000000000000000");			   --64 bits, hex per register. Array of 16 registers
SIGNAL read_register_address_1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL read_register_address_2 : STD_LOGIC_VECTOR (3 DOWNTO 0);	
SIGNAL write_register_address : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL read_data_1 : STD_LOGIC_VECTOR (63 DOWNTO 0);
SIGNAL read_data_2 : STD_LOGIC_VECTOR (63 DOWNTO 0); 
signal writedata : std_logic_vector(63 downto 0);
SIGNAL opcode : STD_LOGIC_VECTOR (3 DOWNTO 0);
begin 
	--copy the instruction bits	
	read_register_address_1 <= 	instruction_p(7 downto 4); 
	read_register_address_2 <= 	instruction_p(11 downto 8); 
	write_register_address <= instruction_p(3 downto 0); 
	opcode <= instruction_p(15 downto 12);
	reg2_address <= instruction_p(7 downto 4);
	--read the data stored in the registers
    read_data_1 <= register_array(CONV_INTEGER(read_register_address_1(3 DOWNTO 0)));  
	read_data_2 <= register_array(CONV_INTEGER(read_register_address_1(3 DOWNTO 0))); 
	
	writedata <= ALU_result when REGWRITE_ppp = '1' else write_data;  
	
	--writes data on the first clock edge
	process(clk)
	begin
		if (clk'EVENT AND clk = '0') then 
			if (REGWRITE_ppp = '1') then
 				register_array(CONV_INTEGER(write_register_pp(3 DOWNTO 0))) <= writedata;
			end if;
		end if;
	end process;  
	
	process (clk, read_register_address_1, read_register_address_2, write_register_address, opcode)  
	begin 
	--	wait until (clk'EVENT AND clk='1'); 
	if (clk'EVENT AND clk = '0') then
		read_data_1_p <= read_data_1;
		read_data_2_p <= read_data_2; 
		write_register_ppp <= write_register_address;
		opcode_p <= opcode;
		end if;
	end process;	
end dataflow;
			

