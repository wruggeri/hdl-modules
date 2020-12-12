library ieee;
use ieee.std_logic_1164.all;

entity alu is
    generic(n_bit: natural := 8);
    port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
        operation: in std_logic_vector(2 downto 0);
        result: out std_logic_vector(n_bit - 1 downto 0);
        carry_out, overflow: out std_logic);
end alu;

architecture specification of alu is
    component sparse_tree_adder is
        generic(n_bit: integer := 32);
        port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
            carry_in: in std_logic;
            sum: out std_logic_vector(n_bit - 1 downto 0);
            carry_out, overflow: out std_logic);
    end component;
    
    component bitwise_logical_calculator is
    generic(n_bit: natural := 8);
        port(operation: in std_logic_vector(2 downto 0);
            operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
            result: out std_logic_vector(n_bit - 1 downto 0));
    end component;
    
    signal module_select: std_logic;
    signal op2add, reslog, resadd: std_logic_vector(n_bit - 1 downto 0);
begin
    module_select <= operation(2) and operation(1);
        
    op2add <= operand_2 when operation(0) = '0' else
        not(operand_2) when operation(0) = '1' else
        (others => 'U');
        
    adder: sparse_tree_adder generic map(n_bit => n_bit)
        port map(operand_1 => operand_1, 
			operand_2 => op2add, 
			carry_in => operation(0), 
			sum => resadd, 
			carry_out => carry_out, 
			overflow => overflow);  
			
    logicals: bitwise_logical_calculator generic map(n_bit => n_bit)
        port map(operation => operation, 
			operand_1 => operand_1, 
			operand_2 => operand_2, 
			result => reslog);

    result <= reslog when module_select = '0' else
        resadd when module_select = '1' else
        (others => 'U');
end specification;
