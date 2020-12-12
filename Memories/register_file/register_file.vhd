library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    generic(n_bit_data: natural := 8;
        n_bit_address: natural := 4);
    port(data_in: in std_logic_vector(n_bit_data - 1 downto 0);
        address_read_1, address_read_2, address_write: in std_logic_vector(n_bit_address - 1 downto 0);
        chip_select, clock, reset, write, read_1, read_2: in std_logic;
        data_out_1, data_out_2: out std_logic_vector(n_bit_data - 1 downto 0));
end register_file;

architecture specification of register_file is
    type register_array is array(2 ** n_bit_address - 1 downto 0) of std_logic_vector(n_bit_data - 1 downto 0);
    signal register_set: register_array;
begin
    data_out_1 <= register_set(to_integer(unsigned(address_read_1))) when (chip_select = '1' and read_1 = '1') else 
        (others => 'Z');
    data_out_2 <= register_set(to_integer(unsigned(address_read_2))) when (chip_select = '1' and read_2 = '1') else 
        (others => 'Z');
        
    process(clock, reset)
    begin
        if reset = '1' then
            for i in 0 to 2 ** n_bit_address - 1 loop
                register_set(i) <= (others => '0');
            end loop;
        elsif clock = '1' and clock'event then
            if chip_select = '1' and write = '1' then
                register_set(to_integer(unsigned(address_write))) <= data_in;
            end if;
        end if;
    end process;
end specification;
