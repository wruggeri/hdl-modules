library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity sparse_tree_carry_generator is
	generic(n_bit: integer := 32);
	port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
	   carry_in: in std_logic;
		carry_out: out std_logic_vector(n_bit / 4 - 1 downto 0));
end sparse_tree_carry_generator;

architecture specification of sparse_tree_carry_generator is
    component pg_network
	   generic(n_bit: integer := 32);
	   port(operand_1, operand_2: in std_logic_vector(n_bit downto 1);
		  p, g: out std_logic_vector(n_bit downto 1));
    end component;

    component pg_block
	   port(Gik, Pik, Gk1j, Pk1j: in std_logic;
	       Gij, Pij: out std_logic);
    end component;
    
    component g_block
	   port(Gik, Pik, Gk1j: in std_logic;
	       Gij: out std_logic);
    end component;
    
    component g_block_enhanced
	   port(Gik, Pik, Gk1j, Pk1j, carry_in: in std_logic;
	       Gij: out std_logic);
    end component;

	signal p, g: std_logic_vector(n_bit - 1 downto 0);
	constant N_lines: integer := integer(ceil(log2(real(n_bit))));
	type signal_array is array (0 to N_lines - 1) of std_logic_vector(n_bit / 2 - 1 downto 0);
	signal g_matrix: signal_array;
	signal p_matrix: signal_array;
begin
	pgnetwork: pg_network generic map(n_bit => n_bit)
		port map(operand_1 => operand_1, 
		  operand_2 => operand_2, 
		  p => p, 
		  g => g);
		
	--First level
	flgblock: g_block_enhanced
	   port map(Gik => g(1), 
	       Pik => p(1), 
	       Gk1j => g(0), 
	       Pk1j => p(0), 
	       carry_in => carry_in, 
	       Gij => g_matrix(0)(0));
	flpg: for j in 1 to n_bit / 2 - 1 generate
	   flpgblock: pg_block
	       port map(Gik => g(2 * j + 1), 
	           Pik => p(2 * j + 1), 
	           Gk1j => g(2 * j), 
	           Pk1j => p(2 * j), 
	           Gij => g_matrix(0)(j), 
	           Pij => p_matrix(0)(j));
	end generate flpg;
	
	--Second level
	slgblock: g_block
	   port map(Gik => g_matrix(0)(1), 
	       Pik => p_matrix(0)(1), 
	       Gk1j => g_matrix(0)(0), 
	       Gij => g_matrix(1)(0));
	slpg: for j in 1 to n_bit / 4 - 1 generate
	   slpgblock: pg_block
	       port map(Gik => g_matrix(0)(2 * j + 1), 
	           Pik => p_matrix(0)(2 * j + 1), 
	           Gk1j => g_matrix(0)(2 * j), 
	           Pk1j => p_matrix(0)(2 * j), 
	           Gij => g_matrix(1)(j), 
	           Pij => p_matrix(1)(j));
	end generate slpg;
	
	--Other levels
	olstructure: for j in 2 to N_lines - 1 generate
	   olblocks: for k in 0 to n_bit / 4 - 1 generate
	       propagation: if (to_integer(unsigned(std_logic_vector(to_unsigned(4 * (k + 1)  - 1, n_bit)) and std_logic_vector(to_unsigned(2**j, n_bit)))) = 0) generate
	           g_matrix(j)(k) <= g_matrix(j - 1)(k);
	           p_matrix(j)(k) <= p_matrix(j - 1)(k);
	       end generate propagation;
	       blocks: if (to_integer(unsigned(std_logic_vector(to_unsigned(4 * (k + 1)  - 1, n_bit)) and std_logic_vector(to_unsigned(2**j, n_bit)))) > 0) generate
	           olg: if (4 * (k + 1) > 2**j) and (4 * (k + 1) <= 2**(j + 1)) generate
	               olgblock: g_block
	                   port map(Gik => g_matrix(j - 1)(k), 
	                       Pik => p_matrix(j - 1)(k), 
	                       Gk1j => g_matrix(j - 1)(j - 2), 
	                       Gij => g_matrix(j)(k));
	           end generate olg;
	           olpg: if 4 * (k + 1) > 2**(j + 1) generate
	               olpgblock: pg_block
	                   port map(Gik => g_matrix(j - 1)(k), 
	                       Pik => p_matrix(j - 1)(k), 
	                       Gk1j => g_matrix(j - 1)(2**(j - 2) * (4 * k - 1)/(2**j) - 1),
	                       Pk1j => p_matrix(j - 1)(2**(j - 2) * (4 * k - 1)/(2**j) - 1),
	                       Gij => g_matrix(j)(k),
	                       Pij => p_matrix(j)(k));
	           end generate olpg;
	       end generate blocks;
	   end generate olblocks;
	end generate olstructure;
	
	outputs: for j in 0 to n_bit / 4 - 1 generate
	   carry_out(j) <= g_matrix(N_lines - 1)(j);
	end generate outputs;
end specification;
