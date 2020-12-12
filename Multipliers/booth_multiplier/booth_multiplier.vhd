library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity booth_multiplier is
    generic(n_bit: natural := 8);
    port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
        product: out std_logic_vector(2 * n_bit - 1 downto 0));
end booth_multiplier;

architecture specification of booth_multiplier is
    component booth_encoder is
        port(operand_bits: in std_logic_vector(2 downto 0);
            selection_bits: out std_logic_vector(2 downto 0));
    end component;
    
    component carry_select_adder is
        generic(n_bit: natural := 8);
        port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
            carry_in: in std_logic;
            sum: out std_logic_vector(n_bit - 1 downto 0);
            carry_out: out std_logic;
            overflow: out std_logic);
    end component;
    
    component multiplexer is
        generic(n_input: natural := 8;
            n_bit: natural := 16);
        port(input_set: in std_logic_vector(n_bit * n_input - 1 downto 0);
            selection: in std_logic_vector(natural(ceil(log2(real(n_input)))) - 1 downto 0);
            output: out std_logic_vector(n_bit - 1 downto 0));
    end component;
    
    signal op1res, op1resinv: std_logic_vector(2 * n_bit - 1 downto 0);
    signal op2res: std_logic_vector(n_bit + 1 downto 0);
    type muxarray is array (natural(ceil(real(n_bit) / real(2))) - 1 downto 0) of std_logic_vector(10 * n_bit - 1 downto 0);
    type selarray is array (natural(ceil(real(n_bit) / real(2))) - 1 downto 0) of std_logic_vector(2 downto 0);
    type sumarray is array (natural(ceil(real(n_bit) / real(2))) - 1 downto 0) of std_logic_vector(2 * n_bit - 1 downto 0);
    signal muxmatrix: muxarray;
    signal selmatrix: selarray;
    signal summatrix_1, summatrix_2: sumarray;
    constant zeros: std_logic_vector(2 * n_bit - 1 downto 0) := (others => '0');
begin
    op1res <= std_logic_vector(resize(signed(operand_1), 2 * n_bit));
    op1resinv <= std_logic_vector(resize(-signed(operand_1), 2 * n_bit));
    op2res <= std_logic_vector(shift_left(resize(signed(operand_2), n_bit + 2), 1));
	
    --First bits
    muxmatrix(0) <= std_logic_vector(shift_left(signed(op1resinv), 1)) &
        std_logic_vector(shift_left(signed(op1res), 1)) &
        op1resinv &
        op1res &
        zeros;
    encoder_first: booth_encoder
        port map(operand_bits => op2res(2 downto 0), 
			selection_bits => selmatrix(0));
    mux_first: multiplexer generic map(n_input => 5, 
			n_bit => 2 * n_bit)
        port map(input_set => muxmatrix(0), 
		selection => selmatrix(0), 
		output => summatrix_1(0));
    
    --Other bits
    other_bits: for i in 1 to natural(ceil(real(n_bit) / real(2))) - 1 generate
        muxmatrix(i) <= std_logic_vector(shift_left(signed(op1resinv), 2 * i + 1)) &
            std_logic_vector(shift_left(signed(op1res), 2 * i + 1)) &
            std_logic_vector(shift_left(signed(op1resinv), 2 * i)) &
            std_logic_vector(shift_left(signed(op1res), 2 * i)) &
            zeros;
        encoder: booth_encoder
            port map(operand_bits => op2res(2 * i + 2 downto 2 * i), 
				selection_bits => selmatrix(i));
        mux: multiplexer generic map(n_input => 5, n_bit => 2 * n_bit)
            port map(input_set => muxmatrix(i), 
				selection => selmatrix(i), 
				output => summatrix_2(i - 1)); 
        adder: carry_select_adder generic map(n_bit => 2 * n_bit)
            port map(operand_1 => summatrix_1(i - 1), 
				operand_2 => summatrix_2(i - 1), 
				carry_in => '0', 
				sum => summatrix_1(i));      
    end generate;
    
    product <= summatrix_1(natural(ceil(real(n_bit) / real(2))) - 1);
end specification;
