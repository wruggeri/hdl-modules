library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;


entity testbench is
end testbench;
 

architecture specification of testbench is
---TEST PROCEDURE SETTINGS----------------------------------------------------------------
------Modify as you need, the test circuitry supports every data width up to 64 bits------
	constant clock_period: time := 10 ns;
	signal clock: std_logic := '0';
	signal reset: std_logic;
	constant n_bit: natural := 8;
------------------------------------------------------------------------------------------

---TEST CIRCUITRY--------------------------------------------------------
------Don't modify-------------------------------------------------------
	component test_module is
		generic(n_bit: natural := 8);
		port(serial_in, clock, reset, load_1, load_2, run_test: in std_logic;
			output: out std_logic_vector(2 * n_bit - 1 downto 0));
	end component;

	signal serial_in, load_1, load_2, run_test: std_logic;
	signal input_1, input_2: std_logic_vector(n_bit - 1 downto 0);
-------------------------------------------------------------------------

---GOLDEN MODEL CIRCUITRY----------------------------------------------------------------------
------Insert the component structure of your golden model and all the needed signals here------
------Leave empty if you don't use a golden model to validate your results---------------------
-----------------------------------------------------------------------------------------------

---YOUR UNIT-UNDER-TEST COMPONENT DECLARATION-----------------------------------------
------Insert the component structure of your UUT and all the needed signals here------
--------------------------------------------------------------------------------------

begin
---TESTING CIRCUITRY INSTANTIATION-------------------------------------------------------------------------------------------------------
------Don't modify-----------------------------------------------------------------------------------------------------------------------
   input: test_module generic map(n_bit => n_bit)
		port map (serial_in => serial_in, 
			clock => clock, 
			reset => reset, 
			load_1 => load_1, 
			load_2 => load_2, 
			run_test => run_test,
			output(2 * n_bit - 1 downto n_bit) => input_1, 
			output(n_bit - 1 downto 0) => input_2);
-----------------------------------------------------------------------------------------------------------------------------------------

---YOUR GOLDEN MODEL INSTANTIATION---------------------------------
------Insert here you golden model component instantiation---------	
------Use input_1 and input_2 as inputs to your golden model-------
-------------------------------------------------------------------

---YOUR UNIT-UNDER-TEST INSTANTIATION--------------------
------Insert here you UUT component instantiation--------	
------Use input_1 and input_2 as inputs to your UUT------
---------------------------------------------------------

---CLOCK PROCESS---------------------
------Don't modify-------------------
   clock_process: process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
-------------------------------------
	
   stim_proc: process	
---INPUT SEEDS DECLARATION-----------------------------------------------------------------
-------You can comment out if you don't use custom generation settings---------------------
-------Edit to choose the starting seeds for the input generators--------------------------
		variable seed_1: std_logic_vector(n_bit - 1 downto 0) := (others => '0');
		variable seed_2: std_logic_vector(n_bit - 1 downto 0) := (others => '0');
-------------------------------------------------------------------------------------------
   begin			
---INIT SEQUENCE OF THE TESTING CIRCUITRY--------------------------------------
------Don't modify-------------------------------------------------------------
------It also resets all the circuits receiving the provided reset signal------
		wait for 100 ns;
		serial_in <= '0';
		reset <= '1';
		load_1 <= '0';
		load_2 <= '0';
		run_test <= '0';
		wait for clock_period;
		reset <= '0';
-------------------------------------------------------------------------------

---INITIAL SETTINGS OF THE MODELS-------------------------------------------------------------------------
------If there's something you must immediately set after the reset (e.g. enable signals) to prevent------
------your designs from operating incorrectly you can do it here------------------------------------------
----------------------------------------------------------------------------------------------------------

---INPUT SEEDS LOADING-----------------------------------------------------
------You can comment out if you don't use custom generation settings------
		load_1 <= '1';
		for i in 0 to n_bit - 1 loop
			serial_in <= seed_1(i);
			wait for clock_period;
		end loop;
		load_1 <= '0';
		wait for clock_period;
		load_2 <= '1';
		for i in 0 to n_bit - 1 loop
			serial_in <= seed_2(i);
			wait for clock_period;
		end loop;
		load_2 <= '0';
		serial_in <= '0';
---------------------------------------------------------------------------

---UUT TESTING PROCEDURE------------------------------------------------------------------------------------------------------
------Here the test actually starts: don't edit this signal assignment--------------------------------------------------------
		run_test <= '1';
------Edit as you need or leave it as written for full-cycle automatic testing without a golden model-------------------------
		wait for (2 ** n_bit) * clock_period;
------Here the test ends: don't edit this signal assignment-------------------------------------------------------------------
		run_test <= '0';
------------------------------------------------------------------------------------------------------------------------------
      wait;
   end process;
end;
