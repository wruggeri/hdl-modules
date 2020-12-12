library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder is
    generic(n_bit: natural := 8);
    port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
        carry_in: in std_logic;
        sum: out std_logic_vector(n_bit - 1 downto 0);
        carry_out, overflow: out std_logic);
end ripple_carry_adder;

architecture specification of ripple_carry_adder is
    component full_adder
        port(operand_1, operand_2, carry_in: in std_logic;
            sum, carry_out: out std_logic);
    end component;
	
    signal cin: std_logic_vector(n_bit downto 0);
begin
    cin(0) <= carry_in;
    carry_out <= cin(n_bit);
    overflow <= cin(n_bit) xor cin(n_bit - 1);
    
    fadders: for i in 0 to n_bit - 1 generate
        fa: full_adder 
			port map(operand_1 => operand_1(i),
				operand_2 => operand_2(i),
				carry_in => cin(i),
				sum => sum(i),
				carry_out => cin(i + 1));
    end generate;
end specification;
