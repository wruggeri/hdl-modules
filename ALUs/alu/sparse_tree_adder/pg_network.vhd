library ieee;
use ieee.std_logic_1164.all;

entity pg_network is
	generic(n_bit: integer := 32);
	port(operand_1, operand_2: in std_logic_vector(n_bit downto 1);
		p, g: out std_logic_vector(n_bit downto 1));
end pg_network;

architecture specification of pg_network is
begin
	p <= operand_1 xor operand_2;
	g <= operand_1 and operand_2;
end specification;

