library ieee;
use ieee.std_logic_1164.all;


entity full_adder is
    port(operand_1, operand_2, carry_in: in std_logic;
        sum, carry_out: out std_logic);
end full_adder;

architecture specification of full_adder is
begin
    sum <= carry_in xor (operand_1 xor operand_2);
    carry_out <= (carry_in and (operand_1 xor operand_2)) or (operand_1 and operand_2);
end specification;
