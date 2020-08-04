LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_ARITH.ALL;
 USE IEEE.STD_LOGIC_SIGNED.ALL;
 USE IEEE.NUMERIC_STD.ALL;
 
 entity Execution is 
	 port(	
	 	clk : in std_logic;
		Read_Data_1 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		Read_Data_2 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		ALUSRC1_p : IN STD_LOGIC; 
		ALU_Result_p : OUT STD_LOGIC_VECTOR (63 DOWNTO 0); 
		ALUOP_p : IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
	--	Write_data : in std_logic_vector(63 downto 0);	
		Write_register_p : in std_logic_vector(3 downto 0);
		REGWRITE_p : in std_logic;
		REGWRITE_pp : out std_logic;
		Write_register_ppp : out std_logic_vector(3 downto 0);
		Register2_address: in std_logic_vector(3 downto 0)				--the address for register 2 being used (0 thru 15)
		);
end Execution;

architecture behavioral of  Execution is
SIGNAL ALU_output : STD_LOGIC_VECTOR (63 DOWNTO 0);
SIGNAL ALU_Result : STD_LOGIC_VECTOR (63 DOWNTO 0);
SIGNAL Write_Address : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL A_input : STD_LOGIC_VECTOR (63 DOWNTO 0); 
SIGNAL B_input : STD_LOGIC_VECTOR (63 DOWNTO 0); 
SIgnal ALUSRC : std_logic;
-- MY added inputs for my functions 
signal rotate_input : std_logic_vector(63 downto 0);
signal shift_input0 : std_logic_vector(15 downto 0);
signal shift_input1 : std_logic_vector(15 downto 0);
signal shift_input2 : std_logic_vector(15 downto 0);
signal shift_input3 : std_logic_vector(15 downto 0);
signal add_input0 : std_logic_vector(31 downto 0);
signal add_input1 : std_logic_vector(31 downto 0); 
signal add_input2 : std_logic_vector(31 downto 0);
signal add_input3 : std_logic_vector(31 downto 0);
signal add_half0 : std_logic_vector(15 downto 0);
signal add_half1 : std_logic_vector(15 downto 0);
signal mult0 :  std_logic_vector (15 downto 0);
signal mult1 :  std_logic_vector (15 downto 0);
signal mult2 :  std_logic_vector (15 downto 0);
signal mult3 :  std_logic_vector (15 downto 0);
signal product :  std_logic_vector (31 downto 0);	  
signal product2 :  std_logic_vector (31 downto 0);
signal carry0_in : std_logic_vector (31 downto 0);
signal carry1_in : std_logic_vector (31 downto 0);	
signal carry0_out : std_logic_vector (31 downto 0);
signal carry1_out : std_logic_vector (31 downto 0);	
begin 
	
	
	A_input <= Read_Data_1;
	B_input <= Read_Data_2 WHEN ALUSRC1_p = '0' else "0000000000000000000000000000000000000000000000000000000000000000";	   --changed to fit array size
	Write_Address <= Write_register_p;		  --changed from write_data to write register to fit array size
	
	process(ALUOP_p, A_input, B_input, rotate_input, shift_input0, shift_input1, shift_input2, shift_input3, mult0, mult1, mult2, mult3)
	variable cnt0 : std_logic_vector(7 downto 0);
	variable cnt1 : std_logic_vector(7 downto 0);
	variable cnt2 : std_logic_vector(7 downto 0);
	variable cnt3 : std_logic_vector(7 downto 0);
	variable cnt4 : std_logic_vector(7 downto 0);
	variable cnt5 : std_logic_vector(7 downto 0);
	variable cnt6 : std_logic_vector(7 downto 0);
	variable cnt7 : std_logic_vector(7 downto 0); 
	   --MY added variables for my saturation addition and subtraction functions
	variable a,b: unsigned (15 downto 0);
	variable c: unsigned (15 downto 0);
	variable rotate : integer;
	begin
	--	cnt1 := "00000000";	
	--	cnt2 := "00000000";
	--	cnt3 := "00000000";
	--	cnt4 := "00000000";
	--	cnt5 := "00000000";
	--	cnt6 := "00000000";
	--	cnt7 := "00000000";
		if (ALUOP_p = "0000" or ALUOP_p = "0001") then
			ALU_Result <= A_input + B_input; 
			
		elsif (ALUOP_p = "0010") then   
			ALU_Result <= A_input AND B_input;
			
		elsif (ALUOP_p = "0011") then
			ALU_Result <= A_input OR B_input; 
			
		elsif (ALUOP_p = "0100") then 
		cnt0 := "00000000";	
		cnt1 := "00000000";	
		cnt2 := "00000000";
		cnt3 := "00000000";
		cnt4 := "00000000";
		cnt5 := "00000000";
		cnt6 := "00000000";
		cnt7 := "00000000";
			for i in 0 to 7 loop	
				if A_input(i) = '1' then
					cnt0 := cnt0 + 1;
				else 
					cnt0 := cnt0 + 0;
				end if;
			end loop;
			for i in 8 to 15 loop
				if A_input(i) = '1' then
					cnt1 := cnt1 + 1;
				else 
					cnt1 := cnt1 + 0;
				end if;
			end loop;
			for i in 16 to 23 loop
				if A_input(i) = '1' then
					cnt2 := cnt2 + 1;
				else 
					cnt2 := cnt2 + 0;
				end if;
			end loop;
			for i in 24 to 31 loop
				if A_input(i) = '1' then
					cnt3 := cnt3 + 1;
				else 
					cnt3 := cnt3 + 0;
				end if;
			end loop; 
			for i in 32 to 39 loop	
				if A_input(i) = '1' then
					cnt4 := cnt4 + 1;
				else 
					cnt4 := cnt4 + 0;
				end if;
			end loop;
			for i in 40 to 47 loop
				if A_input(i) = '1' then
					cnt5 := cnt5 + 1;
				else 
					cnt5 := cnt5 + 0;
				end if;
			end loop;
			for i in 48 to 55 loop
				if A_input(i) = '1' then
					cnt6 := cnt6 + 1;
				else 
					cnt6 := cnt6 + 0;
				end if;
			end loop;
			for i in 56 to 63 loop
				if A_input(i) = '1' then
					cnt7 := cnt7 + 1;
				else 
					cnt7 := cnt7 + 0;
				end if;
			end loop;
			ALU_Result <= cnt7 & cnt6 & cnt5 & cnt4 & cnt3 & cnt2 & cnt1 & cnt0;
			
		elsif (ALUOP_p = "0101") then 
		cnt1 := "00000000";	
		cnt2 := "00000000";
		cnt3 := "00000000";
		cnt4 := "00000000";
		cnt5 := "00000000";
		cnt6 := "00000000";
		cnt7 := "00000000";
			for i in 31 downto 0 loop
				if(A_input(i) = '1') then
					exit;
				else 
					cnt1 := cnt1 + 1;
				end if;	 
			end loop;
			for i in 63 downto 32 loop 
				if(A_input(i) = '1') then
					exit;
				else 
					cnt2 := cnt2 + 1;
				end if;
			end loop;
			ALU_Result <= "000000000000000000000000" & cnt2 & "000000000000000000000000" & cnt1;
			
---------------------------------------------------------------------------------------------------

			elsif (ALUOP_p = "0110") then
				rotate := (to_integer(unsigned(B_input(5 downto 0))));
			--rotate_input <= A_input;
				--rotate_input <= A_input (63 downto 0);
			--rotate_input <= A_input rol (to_integer(unsigned(B_input)));
--			for i in 0 to rotate loop
				rotate_input <= A_input(63-rotate downto 0) & A_input(63 downto 64-rotate); 
--				if ((i + rotate) > 63) then 
--					if (rotate_input(i+rotate-64) /= A_input(i)) then
--						rotate_input(i+rotate-64) <= A_input(i);
--					end if;
--				else
--					if (rotate_input(i+rotate) /= A_input(i)) then
--						rotate_input(i+rotate) <= A_input(i);
--					end if;
--				end if;
--			end loop;

			ALU_RESULT(63 downto 0) <= rotate_input(63 downto 0);
			
			
		elsif (ALUOP_p = "0111") then
			shift_input0 <= std_logic_vector(unsigned(A_input(15 downto 0))  sll to_integer(unsigned(Register2_address(3 downto 0)))); --register src2;
			shift_input1 <= std_logic_vector(unsigned(A_input(31 downto 16)) sll to_integer(unsigned(Register2_address(3 downto 0)))); --register src2;
			shift_input2 <= std_logic_vector(unsigned(A_input(47 downto 32)) sll to_integer(unsigned(Register2_address(3 downto 0)))); --register src2;
			shift_input3 <= std_logic_vector(unsigned(A_input(63 downto 48)) sll to_integer(unsigned(Register2_address(3 downto 0)))); --register src2;
		--	ALU_RESULT(15 downto 0) <= std_logic_vector(unsigned(A_input(15 downto 0)) sll to_integer(unsigned(B_input(5 downto 0))));
		--	ALU_RESULT(31 downto 16) <= std_logic_vector(unsigned(A_input(31 downto 16)) sll to_integer(unsigned(B_input(5 downto 0))));
		--	ALU_RESULT(47 downto 32) <= std_logic_vector(unsigned(A_input(47 downto 32)) sll to_integer(unsigned(B_input(5 downto 0))));
		--	ALU_RESULT(63 downto 48) <= std_logic_vector(unsigned(A_input(63 downto 48)) sll to_integer(unsigned(B_input(5 downto 0))));
			
			ALU_RESULT(63 downto 0) <= shift_input3 & shift_input2 & shift_input1 & shift_input0;
		--	ALU_RESULT(63 downto 48) <= shift_input3;
		--	ALU_RESULT(47 downto 32) <= shift_input2;
		--	ALU_RESULT(31 downto 16) <= shift_input1;
		--	ALU_RESULT(15 downto 0) <= shift_input0;
			
		elsif (ALUOP_p = "1000") then
			--add_input0 <= A_input(31 downto 0);
			--add_input1 <= B_input(31 downto 0);
			--ALU_RESULT(31 downto 0) <= add_input0 + add_input1;
			--add_input2 <= A_input(63 downto 32);
			--add_input3 <= B_input(63 downto 32);   
			--ALU_RESULT(63 downto 32) <= add_input2 + add_input3;
			
			ALU_RESULT(31 downto 0) <= A_input(31 downto 0) + B_input(31 downto 0);
		   	ALU_RESULT(63 downto 32) <= A_input(63 downto 32) + B_input(63 downto 32);
			
		elsif (ALUOP_p = "1001") then
		--	add_input0 <= A_input(31 downto 0);
		--	add_input1 <= B_input(31 downto 0);
		--	ALU_RESULT(31 downto 0) <= add_input0 - add_input1;
		--	add_input2 <= A_input(63 downto 32);
		--	add_input3 <= B_input(63 downto 32);   
		--	ALU_RESULT(63 downto 32) <= add_input2 - add_input3;
			
			ALU_RESULT(31 downto 0) <= A_input(31 downto 0) - B_input(31 downto 0);
		   	ALU_RESULT(63 downto 32) <= A_input(63 downto 32) - B_input(63 downto 32);
			
		elsif (ALUOP_p = "1010") then
		--	add_half0 <= A_input(15 downto 0);
		--	add_half1 <= B_input(15 downto 0);
		--	ALU_RESULT(15 downto 0) <= add_half0 + add_half1;
		--	add_half0 <= A_input(31 downto 16);
		--	add_half1 <= B_input(31 downto 16);
		--	ALU_RESULT(31 downto 16) <= add_half0 + add_half1;
		--	add_half0 <= A_input(47 downto 32);
		--	add_half1 <= B_input(47 downto 32);
		--	ALU_RESULT(47 downto 32) <= add_half0 + add_half1;
		--	add_half0 <= A_input(63 downto 48);
		--	add_half1 <= B_input(63 downto 48);
		--	ALU_RESULT(63 downto 48) <= add_half0 + add_half1;
		ALU_RESULT(15 downto 0) <= A_input(15 downto 0) + B_input(15 downto 0);
		ALU_RESULT(31 downto 16) <= A_input(31 downto 16) + B_input(31 downto 16);
		ALU_RESULT(47 downto 32) <= A_input(47 downto 32) + B_input(47 downto 32);
		ALU_RESULT(63 downto 48) <= A_input(63 downto 48) + B_input(63 downto 48);
			
		elsif (ALUOP_p = "1011") then
		--	add_half0 <= A_input(15 downto 0);
		--	add_half1 <= B_input(15 downto 0);
		--	ALU_RESULT(15 downto 0) <= add_half0 - add_half1;
		--	add_half0 <= A_input(31 downto 16);
		--	add_half1 <= B_input(31 downto 16);
		--	ALU_RESULT(31 downto 16) <= add_half0 - add_half1;
		--	add_half0 <= A_input(47 downto 32);
		--	add_half1 <= B_input(47 downto 32);
		--	ALU_RESULT(47 downto 32) <= add_half0 - add_half1;
		--	add_half0 <= A_input(63 downto 48);
		--	add_half1 <= B_input(63 downto 48);
		--	ALU_RESULT(63 downto 48) <= add_half0 - add_half1;
		ALU_RESULT(15 downto 0) <= A_input(15 downto 0) - B_input(15 downto 0);
		ALU_RESULT(31 downto 16) <= A_input(31 downto 16) - B_input(31 downto 16);
		ALU_RESULT(47 downto 32) <= A_input(47 downto 32) - B_input(47 downto 32);
		ALU_RESULT(63 downto 48) <= A_input(63 downto 48) - B_input(63 downto 48);
			
		elsif (ALUOP_p = "1100") then			
			a := unsigned("0"& A_input(14 downto 0));
			b := unsigned("0"& B_input(14 downto 0));
			c := a + b;
			if c <= 2**15 then
			  --ALU_RESULT(15 downto 0) <= '0' & std_logic_vector(c(14 downto 0));
			   ALU_RESULT(15 downto 0) <= (A_input(15 downto 0) + B_input(15 downto 0));
			else
			  ALU_RESULT(15 downto 0) <= x"ffff";		
			end if;
			
			a := unsigned("0"& A_input(30 downto 16));
			b := unsigned("0"& B_input(30 downto 16));
			c := a + b;
			if c <= 2**15 then
			--  ALU_RESULT(31 downto 16) <= '0' & std_logic_vector(c(14 downto 0));
			ALU_RESULT(31 downto 16) <= (A_input(31 downto 16) + B_input(31 downto 16));
			else
			  ALU_RESULT(31 downto 16) <= x"ffff";		
			end if;
			
			a := unsigned("0"& A_input(46 downto 32));
			b := unsigned("0"& B_input(46 downto 32));
			c := a + b;
			if c <= 2**15 then
		--	  ALU_RESULT(47 downto 32) <= '0' & std_logic_vector(c(14 downto 0));
			ALU_RESULT(47 downto 32) <= (A_input(47 downto 32) + B_input(47 downto 32));
			else
			  ALU_RESULT(47 downto 32) <= x"ffff";		
			end if;
			
			a := unsigned("0"& A_input(62 downto 48));
			b := unsigned("0"& B_input(62 downto 48));
			c := a + b;
			if c <= 2**15 then
		--	  ALU_RESULT(63 downto 48) <= '0' & std_logic_vector(c(14 downto 0));
			ALU_RESULT(63 downto 48) <= (A_input(63 downto 48) + B_input(63 downto 48));
			else
			  ALU_RESULT(63 downto 48) <= x"ffff";		
			end if;
		
		elsif (ALUOP_p = "1101") then 
			a := unsigned("0"& A_input(14 downto 0));
			b := unsigned("0"& B_input(14 downto 0));
			c := a - b;
			if c >= 0 then
			 -- ALU_RESULT(15 downto 0) <= '0' & std_logic_vector(c(14 downto 0));
			 ALU_RESULT(15 downto 0) <= (A_input(15 downto 0) - B_input(15 downto 0));
			else
			  ALU_RESULT(15 downto 0) <= x"0000";		
			end if;	
			
			a := unsigned("0"& A_input(30 downto 16));
			b := unsigned("0"& B_input(30 downto 16));
			c := a - b;
			if c >= 0 then
			  --ALU_RESULT(31 downto 16) <= '0' & std_logic_vector(c(14 downto 0));
			  ALU_RESULT(31 downto 16) <= (A_input(31 downto 16) - B_input(31 downto 16));
			else
			  ALU_RESULT(31 downto 16) <= x"0000";		
			end if;
			
			a := unsigned("0"& A_input(46 downto 32));
			b := unsigned("0"& B_input(46 downto 32));
			c := a - b;
			if c >= 0 then
			  --ALU_RESULT(47 downto 32) <= '0' & std_logic_vector(c(14 downto 0));
			  ALU_RESULT(47 downto 32) <= (A_input(47 downto 32) - B_input(47 downto 32));
			else
			  ALU_RESULT(47 downto 32) <= x"0000";		
			end if;
			
			a := unsigned("0"& A_input(62 downto 48));
			b := unsigned("0"& B_input(62 downto 48));
			c := a - b;
			if c >= 0 then
			  --ALU_RESULT(63 downto 48) <= '0' & std_logic_vector(c(14 downto 0));	
			  ALU_RESULT(63 downto 48) <= (A_input(63 downto 48) - B_input(63 downto 48));
			else
			  ALU_RESULT(63 downto 48) <= x"0000";		
			end if;
			--multiply
		elsif (ALUOP_p = "1110") then
			mult0 <= (A_input(15 downto 0));
			mult1 <= (B_input(15 downto 0));
			product <= mult0 * mult1;
			carry0_in <= carry0_out + product;
			mult2 <= (A_input(47 downto 32));
			mult3 <= (B_input(47 downto 32));
			product2 <= mult2 * mult3;	
			carry1_in <= carry1_out + product2;			
			--ALU_RESULT(63 downto 0) <= product2 & product;
			ALU_RESULT(63 downto 0) <= (mult0 * mult1) & (mult2 * mult3);
			--absolute difference of bytes 
		elsif (ALUOP_p = "1111") then
			ALU_RESULT(7 downto 0) <=  A_input(7 downto 0) - B_input(7 downto 0);
			ALU_RESULT(15 downto 8) <=  A_input(15 downto 8) - B_input(15 downto 8);
			ALU_RESULT(23 downto 16) <=  A_input(23 downto 16) - B_input(23 downto 16);
			ALU_RESULT(31 downto 24) <=  A_input(31 downto 24) - B_input(31 downto 24);
			ALU_RESULT(39 downto 32) <=  A_input(39 downto 32) - B_input(39 downto 32);
			ALU_RESULT(47 downto 40) <=  A_input(47 downto 40) - B_input(47 downto 40);
			ALU_RESULT(55 downto 48) <=  A_input(55 downto 48) - B_input(55 downto 48);
			ALU_RESULT(63 downto 56) <=  A_input(63 downto 56) - B_input(63 downto 56);
		end if;
	end process;
	ALU_RESULT_p <= ALU_RESULT;
	end behavioral;
		