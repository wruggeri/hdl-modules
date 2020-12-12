library ieee;
use ieee.std_logic_1164.all;
use work.logical_operations_codes.all;

package alu_operations_codes is
    constant AND_CODE: std_logic_vector(2 downto 0) := work.logical_operations_codes.AND_CODE;
    constant OR_CODE: std_logic_vector(2 downto 0) := work.logical_operations_codes.OR_CODE;
    constant XOR_CODE: std_logic_vector(2 downto 0) := work.logical_operations_codes.XOR_CODE;
    constant NAND_CODE: std_logic_vector(2 downto 0) := work.logical_operations_codes.NAND_CODE;
    constant NOR_CODE: std_logic_vector(2 downto 0) := work.logical_operations_codes.NOR_CODE;
    constant XNOR_CODE: std_logic_vector(2 downto 0) := work.logical_operations_codes.XNOR_CODE;
    constant ADD_CODE: std_logic_vector(2 downto 0) := "110";
    constant SUB_CODE: std_logic_vector(2 downto 0) := "111";
end alu_operations_codes;
