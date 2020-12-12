library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

---ASSUMPTIONS---------------------------------------------------------------------------------------------
---	There are 8 global registers at the beginning of the register file.
---	Each window is composed by 8 global registers, 8 in registers, 8 local register and 8 out registers.
-----------------------------------------------------------------------------------------------------------

entity address_translator is
    generic(n_bit: natural := 8;
        n_window: natural := 4);
    port(chip_select, reset, call, ret: in std_logic;
        address_read_1, address_read_2, address_write: in std_logic_vector(4 downto 0);
        full, empty: out std_logic;
        real_address_read_1, real_address_read_2, real_address_write: out 
            std_logic_vector(natural(ceil(log2(real(32 + 16 * (n_window - 1))))) - 1 downto 0));
end address_translator;

architecture specification of address_translator is
    signal window_pointer: natural := 8;
    signal ar1: unsigned(natural(ceil(log2(real(32 + 16 * (n_window - 1))))) - 1 downto 0);
    signal ar2: unsigned(natural(ceil(log2(real(32 + 16 * (n_window - 1))))) - 1 downto 0);
    signal aw: unsigned(natural(ceil(log2(real(32 + 16 * (n_window - 1))))) - 1 downto 0);
begin

    ar1 <= resize(unsigned(address_read_1), natural(ceil(log2(real(32 + 16 * (n_window - 1))))));
    ar2 <= resize(unsigned(address_read_2), natural(ceil(log2(real(32 + 16 * (n_window - 1))))));
    aw <= resize(unsigned(address_write), natural(ceil(log2(real(32 + 16 * (n_window - 1))))));

    real_address_read_1 <= (others => 'Z') when chip_select = '0' else
        std_logic_vector(ar1) when unsigned(address_read_1) < 8 else 
        std_logic_vector(ar1 + window_pointer - 8);
    real_address_read_2 <= (others => 'Z') when chip_select = '0' else
        std_logic_vector(ar2) when unsigned(address_read_2) < 8 else 
        std_logic_vector(ar2 + window_pointer - 8);
     real_address_write <= (others => 'Z') when chip_select = '0' else
        std_logic_vector(aw) when unsigned(address_write) < 8 else 
        std_logic_vector(aw + window_pointer - 8);
    
    update: process(reset, chip_select, call, ret)
    begin
        if reset = '1' then
            window_pointer <= 8;
            empty <= '1';
            full <= '0';
        elsif chip_select = '1' then
            if call = '1' then
                empty <= '0';
                if window_pointer >= (8 + 16 * (n_window - 1)) then
                    full <= '1';
                else
                    window_pointer <= window_pointer + 16;
                end if;
            elsif ret = '1' then
                full <= '0';
                if window_pointer = 8 then
                    empty <= '1';
                else
                    window_pointer <= window_pointer - 16;
                end if;
            end if;
        end if;
    end process;
end specification;
