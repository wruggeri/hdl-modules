library ieee;
use ieee.std_logic_1164.all;

package logical_operations_codes is
    constant AND_CODE: std_logic_vector(2 downto 0) := "000";
    constant OR_CODE: std_logic_vector(2 downto 0) := "001";
    constant XOR_CODE: std_logic_vector(2 downto 0) := "010";
    constant NAND_CODE: std_logic_vector(2 downto 0) := "011";
    constant NOR_CODE: std_logic_vector(2 downto 0) := "100";
    constant XNOR_CODE: std_logic_vector(2 downto 0) := "101";
end logical_operations_codes;
