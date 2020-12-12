library ieee;
use ieee.std_logic_1164.all;

entity test_module is
	generic(n_bit: natural := 8);
	port(serial_in, clock, reset, load_1, load_2, run_test: in std_logic;
		output: out std_logic_vector(2 * n_bit - 1 downto 0));
end test_module;


architecture specification of test_module is
	component dbfsr is
		generic(n_bit : natural := 8);
		port(serial_in, clock, load, reset: in std_logic;
			output: out std_logic_vector(n_bit - 1 downto 0));
	end component;
	
	signal run_1, run_2: std_logic;
	signal output_gate: std_logic_vector(2 * n_bit - 1 downto 0);
begin
	fsr_1: dbfsr generic map(n_bit => n_bit) 
		port map(serial_in => serial_in, 
			clock => run_1, 
			load => load_1, 
			reset => reset, 
			output => output_gate(n_bit - 1 downto 0));
		
	fsr_2: dbfsr generic map(n_bit => n_bit) 
		port map(serial_in => serial_in, 
			clock => run_2, 
			load => load_2, 
			reset => reset, 
			output => output_gate(2 * n_bit - 1 downto n_bit));
	   
	run_1 <= clock and (run_test or load_1);
	run_2 <= clock and (run_test or load_2);
	output <= output_gate when run_test = '1' else (others => 'Z');
end specification;

