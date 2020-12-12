library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity multiplexer is
    generic(n_input: natural := 8;
        n_bit: natural := 16);
    port(input_set: in std_logic_vector(n_bit * n_input - 1 downto 0);
        selection: in std_logic_vector(natural(ceil(log2(real(n_input)))) - 1 downto 0);
        output: out std_logic_vector(n_bit - 1 downto 0));
end multiplexer;

architecture specification of multiplexer is
    component multiplexer_2x1 is
        generic(n_bit: natural := 16);
        port(input_1, input_2: in std_logic_vector(n_bit - 1 downto 0);
            selection: in std_logic;
            output: out std_logic_vector(n_bit - 1 downto 0));
    end component;

    constant n_stages: natural := natural(ceil(log2(real(n_input))));
    type prop_data is array (n_input - 1 downto 0) of std_logic_vector(n_bit - 1 downto 0);
    type prop_matrix is array (n_stages + 1 downto 1) of prop_data;
    signal pmat: prop_matrix; 
begin
    input_matrix: for i in 0 to n_input - 1 generate
        pmat(1)(i) <= input_set(n_bit * (i + 1) - 1 downto n_bit * i);
    end generate;
    output <= pmat(n_stages + 1)(0);

    stages: for i in 1 to n_stages generate
        muxes: for j in 0 to natural(floor(ceil(real(n_input) / real(2**(i - 1))) / real(2))) - 1 generate
            mux: multiplexer_2x1 generic map(n_bit => n_bit)
                port map(input_1 => pmat(i)(2 * j), 
                    input_2 => pmat(i)(2 * j + 1), 
                    selection => selection(i - 1),
                    output => pmat(i + 1)(j));
        end generate;
        propagate: if natural(ceil(real(n_input) / real(2**(i - 1)))) mod 2 /= 0 generate
            pmat(i + 1)(natural(ceil(real(n_input) / real(2**i))) - 1) <= 
                pmat(i)(natural(ceil(real(n_input) / real(2**(i - 1)))) - 1);
        end generate;
    end generate;
end specification;
