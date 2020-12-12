library ieee;
use ieee.std_logic_1164.all;

entity g_block is
	port(Gik, Pik, Gk1j: in std_logic;
	Gij: out std_logic);
end g_block;

architecture specification of g_block is
begin
	Gij <= Gik or (Pik and Gk1j);
end specification;

