library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synchronous_counter is
    generic(n_bit: natural := 8);
    port(clock, enable, reset, load: in std_logic;
        max_value: in std_logic_vector(n_bit - 1 downto 0);
        count: out std_logic_vector(n_bit - 1 downto 0);
        end_of_count: out std_logic);               
end synchronous_counter;

architecture specification of synchronous_counter is
    signal max_value_register: unsigned(n_bit - 1 downto 0);
    signal count_value: unsigned(n_bit - 1 downto 0);
begin

    count <= std_logic_vector(count_value);
    end_of_count <= '1' when count_value = max_value_register else '0';

    process(clock, reset)
    begin
        if reset = '1' then
            count_value <= (others => '0');
            max_value_register <= (others => '0');
        else
            if clock = '1' and clock'event then
                if load = '1' then
                    max_value_register <= unsigned(max_value);
                elsif enable = '1' then
                    count_value <= count_value + 1;
                    if count_value = max_value_register then
                        count_value <= (others => '0');
                    end if;
                end if;
            end if;
        end if;
    end process;
end specification;
