library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

---STRUCTURE-------------------------------------------------------------------------------
---	Each window is composed by 32 registers: 8 global registers (which are the first
---	8 registers of the RF), 8 input registers, 8 local registers and 8 output registers.
---	The output registers of a window correspond to the input registers of the next
---	window, so to allow parameters passing.
-------------------------------------------------------------------------------------------

entity windowed_register_file is
    generic(n_bit: natural := 8;
        n_window: natural := 4);
    port(data_in: in std_logic_vector(n_bit - 1 downto 0);
        address_read_1, address_read_2, address_write: in std_logic_vector(4 downto 0);
        chip_select, clock, reset, write, read_1, read_2, call, ret: in std_logic;
        data_out_1, data_out_2: out std_logic_vector(n_bit - 1 downto 0);
        full, empty: out std_logic);
end windowed_register_file;

architecture specification of windowed_register_file is
    component address_translator is
        generic(n_bit: natural := 8;
            n_window: natural := 4);
        port(chip_select, reset, call, ret: in std_logic;
            address_read_1, address_read_2, address_write: in std_logic_vector(4 downto 0);
            full, empty: out std_logic;
            real_address_read_1, real_address_read_2, real_address_write: out 
                std_logic_vector(natural(ceil(log2(real(32 + 16 * (n_window - 1))))) - 1 downto 0));
    end component;
    
    component register_file is
        generic(n_bit_data: natural := 8;
            n_bit_address: natural := 4);
        port(data_in: in std_logic_vector(n_bit_data - 1 downto 0);
            address_read_1, address_read_2, address_write: in std_logic_vector(n_bit_address - 1 downto 0);
            chip_select, clock, reset, write, read_1, read_2: in std_logic;
            data_out_1, data_out_2: out std_logic_vector(n_bit_data - 1 downto 0));
    end component;

    signal ar1, ar2, aw: std_logic_vector(natural(ceil(log2(real(32 + 16 * (n_window - 1))))) - 1 downto 0);
begin
    at: address_translator generic map(n_bit => n_bit, 
			n_window => n_window)
        port map(chip_select => chip_select, 
			reset => reset, 
			call => call, 
			ret => ret,
            address_read_1 => address_read_1, 
			address_read_2 => address_read_2, 
			address_write => address_write,
            full => full, 
			empty => empty, 
			real_address_read_1 => ar1, 
			real_address_read_2 => ar2, 
			real_address_write => aw);
			
    rf: register_file generic map(n_bit_data => n_bit, 
			n_bit_address => natural(ceil(log2(real(32 + 16 * (n_window - 1))))))
        port map(data_in => data_in, 
			address_read_1 => ar1, 
			address_read_2 => ar2, 
			address_write => aw, 
			chip_select => chip_select, 
			clock => clock, 
			reset => reset, 
			write => write, 
			read_1 => read_1, 
			read_2 => read_2,
            data_out_1 => data_out_1, 
			data_out_2 => data_out_2);
end specification;
