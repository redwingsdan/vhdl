LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity Cpu_tb is
end Cpu_tb;

architecture behavior of Cpu_tb is				  

component CPU is
	port(
		clk : in std_logic;
		load_en: in std_logic;		  
		write_data: in std_logic_vector(63 downto 0);
		instruction_load : in std_logic_vector(15 downto 0)
		);
end component;	 

signal clk : std_logic := '0';	   
signal load_en : std_logic;
signal write_data : std_logic_vector(63 downto 0);
signal instruction_load : std_logic_vector(15 downto 0);  



constant clk_period : time := 1ns;
begin  
	
	uut: Cpu port map (
	clk => clk,	
	load_en => load_en,
	write_data => write_data,
	instruction_load => instruction_load
	);
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;  --for 0.5 ns signal is '0'.
        clk <= '1';
        wait for clk_period/2;  --for next 0.5 ns signal is '1'.
   end process;
   
    stim_proc: process
   begin
	   write_data <= x"00000000fedc1234";
	   instruction_load <= x"1342";
	   load_en <= '1';
	   wait for 1ns;
	   --load_en <= '0';
	   instruction_load <= x"1288";
	   wait for 1ns;
	   instruction_load <= x"1623";
	   wait for 1ns;
	   instruction_load <= x"328f";
	   wait for 1ns;
	  -- load_en <= '0';
	   instruction_load <= x"2f35";
	   wait for 1ns;
	   instruction_load <= x"4321";
	   wait for 1ns;
	   instruction_load <= x"5524";
	   wait for 1ns;
	   instruction_load <= x"6546";
	   wait for 1ns;
	   instruction_load <= x"7887";
	   wait for 1ns;
	   instruction_load <= x"8638";
	   wait for 1ns;
	   instruction_load <= x"92f9";
	   wait for 1ns;
	   instruction_load <= x"a36a";
	   wait for 1ns;
	   instruction_load <= x"b74b";
	   wait for 1ns;
	   instruction_load <= x"cf2c";
	   wait for 1ns;
	   instruction_load <= x"df1d";
	   wait for 1ns;
	   instruction_load <= x"f41e";
	   wait for 1ns;
	   load_en <= '0';
	   wait for 2ns;
	   write_data <= x"00110000a2fc4321";
	   wait for 1ns;
	   write_data <= x"00110f0f534172fa";
	   wait for 12ns;	 
	   load_en <= '1';
	   instruction_load <= x"e250";	
	   wait for 1ns;
	   load_en <= '0';
	   wait;
   end process;
   end;
   
   
 --  	   write_data <= x"00000000fedc1234";
--	   instruction_load <= x"1342";
--	   load_en <= '1';
--	   wait for 1ns;
--	   instruction_load <= x"1288";
--	   wait for 1ns;
--	   instruction_load <= x"328f";
--	   wait for 1ns; 
--	   instruction_load <= x"ef25";
--	   wait for 1ns;
--	   load_en <= '0';
--	   wait for 2ns;
--	   write_data <= x"00110000a2fc4321";
--	   wait for 4ns;  
--	   wait for 5ns;
--	   load_en <= '0';
--	   wait for 1ns;
     --00110000fefc5335