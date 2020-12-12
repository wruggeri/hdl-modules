library ieee;
use ieee.std_logic_1164.all;


entity sparse_tree_adder is
    generic(n_bit: integer := 32);
    port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
        carry_in: in std_logic;
        sum: out std_logic_vector(n_bit - 1 downto 0);
        carry_out, overflow: out std_logic);
end sparse_tree_adder;

architecture specification of sparse_tree_adder is
    component carry_select_adder
        generic(n_bit: natural := 8);
        port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
            carry_in: in std_logic;
            sum: out std_logic_vector(n_bit - 1 downto 0);
            carry_out, overflow: out std_logic);
    end component;
    
    component sparse_tree_carry_generator
	generic(n_bit: integer := 32);
	port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
	   carry_in: in std_logic;
		carry_out: out std_logic_vector(n_bit / 4 - 1 downto 0));
    end component;
    
    signal carries: std_logic_vector(n_bit / 4 downto 0);
begin
    
    carries(0) <= carry_in;
    
    carrygen: sparse_tree_carry_generator generic map(n_bit => n_bit)
        port map(operand_1 => operand_1,
            operand_2 => operand_2,
            carry_in => carry_in,
            carry_out => carries(n_bit / 4 downto 1));
            
    adders: for i in 0 to n_bit / 4 - 1 generate
        last_adder: if i = n_bit / 4 - 1 generate
            adder: carry_select_adder generic map(n_bit => 4)
                port map(operand_1 => operand_1(4 * i + 3 downto 4 * i),
                    operand_2 => operand_2(4 * i + 3 downto 4 * i),
                    carry_in => carries(i),
                    sum => sum(4 * i + 3 downto 4 * i),
                    overflow => overflow);
        end generate last_adder;
		
        other_adders: if i < n_bit / 4 - 1 generate
            adder: carry_select_adder generic map(n_bit => 4)
                port map(operand_1 => operand_1(4 * i + 3 downto 4 * i),
                    operand_2 => operand_2(4 * i + 3 downto 4 * i),
                    carry_in => carries(i),
                    sum => sum(4 * i + 3 downto 4 * i));
        end generate other_adders;
    end generate adders;
    
    carry_out <= carries(n_bit / 4);
end specification;
