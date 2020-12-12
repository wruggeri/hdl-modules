library ieee;
use ieee.std_logic_1164.all;
use work.logical_operations_codes.all;


entity operation_decoder is
    generic(n_bit: natural := 8);
    port(operation: in std_logic_vector(2 downto 0);
        encoding_1, encoding_2, encoding_3, encoding_4: out std_logic_vector(n_bit - 1 downto 0));
end operation_decoder;

architecture specification of operation_decoder is
begin
    encoding_1 <= (others => '1') when (operation = NAND_CODE) or (operation = NOR_CODE) or (operation = XNOR_CODE) else (others => '0');
    encoding_2 <= (others => '1') when (operation = OR_CODE) or (operation = XOR_CODE) or (operation = NAND_CODE) else (others => '0');
    encoding_3 <= (others => '1') when (operation = OR_CODE) or (operation = XOR_CODE) or (operation = NAND_CODE) else (others => '0');
    encoding_4 <= (others => '1') when (operation = AND_CODE) or (operation = OR_CODE) or (operation = XNOR_CODE) else (others => '0');
end specification;
