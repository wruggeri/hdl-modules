library ieee;
use ieee.std_logic_1164.all;

entity pg_block is
	port(Gik, Pik, Gk1j, Pk1j: in std_logic;
	Gij, Pij: out std_logic);
end pg_block;

architecture specification of pg_block is
begin
	Pij <= Pik and Pk1j;
	Gij <= Gik or (Pik and Gk1j);
end specification;
