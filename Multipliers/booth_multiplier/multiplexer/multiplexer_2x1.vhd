library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity multiplexer_2x1 is
    generic(n_bit: natural := 16);
    port(input_1, input_2: in std_logic_vector(n_bit - 1 downto 0);
        selection: in std_logic;
        output: out std_logic_vector(n_bit - 1 downto 0));
end multiplexer_2x1;

architecture specification of multiplexer_2x1 is
begin
    output <= input_1 when selection = '0' else input_2 when selection = '1' else (others => 'U');
end specification;
