library ieee;
use ieee.std_logic_1164.all;

entity logical_unit is
    generic(n_bit: natural := 8);
    port(operand_1, operand_2: in std_logic_vector(n_bit - 1 downto 0);
        operation_1, operation_2, operation_3, operation_4: in std_logic_vector(n_bit - 1 downto 0);
        result: out std_logic_vector(n_bit - 1 downto 0));
end logical_unit;

architecture specification of logical_unit is
begin
    result <= (((operation_1 nand not(operand_1)) nand not(operand_2)) nand
        ((operation_2 nand not(operand_1)) nand operand_2)) nand
        (((operation_3 nand operand_1) nand not(operand_2)) nand
        ((operation_4 nand operand_1) nand operand_2));
end specification;
