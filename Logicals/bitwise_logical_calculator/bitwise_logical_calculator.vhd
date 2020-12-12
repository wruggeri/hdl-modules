library ieee;
use ieee.std_logic_1164.all;

entity bitwise_logical_calculator is
    generic(n_bit: natural := 8);
    port(operation: in std_logic_vector(2 downto 0);
        operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
        result: out std_logic_vector(n_bit - 1 downto 0));
end bitwise_logical_calculator;

architecture specification of bitwise_logical_calculator is
	component operation_decoder is
        generic(n_bit: natural := 8);
        port(operation: in std_logic_vector(2 downto 0);
            encoding_1, encoding_2, encoding_3, encoding_4: out std_logic_vector(n_bit - 1 downto 0));
    end component;
	
	component logical_unit is
        generic(n_bit: natural := 8);
        port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
            operation_1, operation_2, operation_3, operation_4: in std_logic_vector(n_bit - 1 downto 0);
            result: out std_logic_vector(n_bit - 1 downto 0));
    end component;
    
    type sigarray is array (1 to 4) of std_logic_vector(n_bit - 1 downto 0);
    signal control: sigarray;
begin
    op_dec: operation_decoder generic map(n_bit => n_bit)
        port map(operation => operation, 
			encoding_1 => control(1), 
			encoding_2 => control(2), 
			encoding_3 => control(3), 
			encoding_4 => control (4));
			
    log_unit: logical_unit generic map(n_bit => n_bit)
        port map(operand_1 => operand_1, 
			operand_2 => operand_2, 
			operation_1 => control(1), 
			operation_2 => control(2), 
			operation_3 => control(3), 
			operation_4 => control(4), 
			result => result);
end specification;
