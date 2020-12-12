library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity carry_select_adder is
    generic(n_bit: natural := 8);
    port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
        carry_in: in std_logic;
        sum: out std_logic_vector(n_bit - 1 downto 0);
        carry_out, overflow: out std_logic);
end carry_select_adder;

architecture specification of carry_select_adder is
    component ripple_carry_adder
        generic(n_bit: natural := 8);
            port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
                carry_in: in std_logic;
                sum: out std_logic_vector(n_bit - 1 downto 0);
                carry_out, overflow: out std_logic);
    end component;
    
    signal ovf, cout: std_logic_vector(1 downto 0);
    signal sumsig: std_logic_vector(2 * n_bit - 1 downto 0);
begin
    adders: for i in 0 to 1 generate
        rca: ripple_carry_adder generic map(n_bit => n_bit)
            port map(operand_1 => operand_1,
                operand_2 => operand_2,
                carry_in => std_logic(to_unsigned(i, 1)(0)),
                sum => sumsig((i + 1) * n_bit - 1 downto i * n_bit),
                carry_out => cout(i),
                overflow => ovf(i));
    end generate;
    
    sum <= sumsig(n_bit - 1 downto 0) when carry_in = '0' else
        sumsig(2 * n_bit - 1 downto n_bit) when carry_in = '1';
    carry_out <= cout(0) when carry_in = '0' else
        cout(1) when carry_in = '1';
    overflow <= ovf(0) when carry_in = '0' else
        ovf(1) when carry_in = '1';
end specification;
