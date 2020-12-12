library ieee;
use ieee.std_logic_1164.all;


entity booth_encoder is
    port(operand_bits: in std_logic_vector(2 downto 0);
        selection_bits: out std_logic_vector(2 downto 0));
end booth_encoder;

architecture specification of booth_encoder is
begin
    selection_bits <= "000" when operand_bits = "000" or operand_bits = "111" else  
        "001" when operand_bits = "001" or operand_bits = "010" else                
        "010" when operand_bits = "101" or operand_bits = "110" else                
        "011" when operand_bits = "011" else
        "100" when operand_bits = "100";
end specification;
