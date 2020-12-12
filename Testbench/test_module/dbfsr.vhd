library ieee;
use ieee.std_logic_1164.all;

entity dbfsr is
	generic(n_bit : natural := 8);
	port(serial_in, clock, load, reset: in std_logic;
		output: out std_logic_vector(n_bit - 1 downto 0));
end dbfsr;


architecture specification of dbfsr is
	signal val : std_logic_vector(n_bit - 1 downto 0);
begin
	process(clock, reset)
		variable xored, nored: std_logic;
	begin
		if reset = '1' then
			val <= (others => '0');
		elsif clock = '1' and clock'event then
			if load = '1' then 
				val <= serial_in & val(n_bit - 1 downto 1);
			else
				nored := val(1);
				for i in 2 to n_bit - 1 loop
					nored := nored or val(i);
				end loop;
				nored := not(nored);
				if n_bit = 4 then
					xored := val(0) xor val(1) xor nored;
				elsif n_bit = 5 then
					xored := val(0) xor val(2) xor nored;
				elsif n_bit = 6 then
					xored := val(0) xor val(1) xor nored;
				elsif n_bit = 7 then
					xored := val(0) xor val(1) xor nored;
				elsif n_bit = 8 then
					xored := val(0) xor val(2) xor val(3) xor val(4) xor nored;
				elsif n_bit = 9 then
					xored := val(0) xor val(4) xor nored;
				elsif n_bit = 10 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 11 then
					xored := val(0) xor val(2) xor nored;
				elsif n_bit = 12 then
					xored := val(0) xor val(6) xor val(8) xor val(11) xor nored;
				elsif n_bit = 13 then
					xored := val(0) xor val(9) xor val(10) xor val(12) xor nored;
				elsif n_bit = 14 then
					xored := val(0) xor val(9) xor val(11) xor val(13) xor nored;
				elsif n_bit = 15 then
					xored := val(0) xor val(1) xor nored;
				elsif n_bit = 16 then
					xored := val(0) xor val(1) xor val(3) xor val(12) xor nored;
				elsif n_bit = 17 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 18 then
					xored := val(0) xor val(7) xor nored;
				elsif n_bit = 19 then
					xored := val(0) xor val(13) xor val(17) xor val(18) xor nored;
				elsif n_bit = 20 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 21 then
					xored := val(0) xor val(2) xor nored;
				elsif n_bit = 22 then
					xored := val(0) xor val(1) xor nored;
				elsif n_bit = 23 then
					xored := val(0) xor val(5) xor nored;
				elsif n_bit = 24 then
					xored := val(0) xor val(1) xor val(2) xor val(7) xor nored;
				elsif n_bit = 25 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 26 then
					xored := val(0) xor val(20) xor val(24) xor val(25) xor nored;
				elsif n_bit = 27 then
					xored := val(0) xor val(22) xor val(25) xor val(26) xor nored;
				elsif n_bit = 28 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 29 then
					xored := val(0) xor val(2) xor nored;
				elsif n_bit = 30 then
					xored := val(0) xor val(24) xor val(26) xor val(29) xor nored;
				elsif n_bit = 31 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 32 then
					xored := val(0) xor val(10) xor val(30) xor val(31) xor nored;
				elsif n_bit = 33 then
					xored := val(0) xor val(13) xor nored;
				elsif n_bit = 34 then
					xored := val(0) xor val(7) xor val(32) xor val(33) xor nored;
				elsif n_bit = 35 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 36 then
					xored := val(0) xor val(11) xor nored;
				elsif n_bit = 37 then
					xored := val(0) xor val(32) xor val(33) xor val(34) xor val(35) xor val(36) xor nored;
				elsif n_bit = 38 then
					xored := val(0) xor val(32) xor val(33) xor val(37) xor nored;
				elsif n_bit = 39 then
					xored := val(0) xor val(4) xor nored;
				elsif n_bit = 40 then
					xored := val(0) xor val(2) xor val(19) xor val(21) xor nored;
				elsif n_bit = 41 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 42 then
					xored := val(0) xor val(1) xor val(22) xor val(23) xor nored;
				elsif n_bit = 43 then
					xored := val(0) xor val(1) xor val(5) xor val(6) xor nored;
				elsif n_bit = 44 then
					xored := val(0) xor val(1) xor val(26) xor val(27) xor nored;
				elsif n_bit = 45 then
					xored := val(0) xor val(1) xor val(3) xor val(4) xor nored;
				elsif n_bit = 46 then
					xored := val(0) xor val(1) xor val(20) xor val(21) xor nored;
				elsif n_bit = 47 then
					xored := val(0) xor val(5) xor nored;
				elsif n_bit = 48 then
					xored := val(0) xor val(1) xor val(27) xor val(28) xor nored;
				elsif n_bit = 49 then
					xored := val(0) xor val(9) xor nored;
				elsif n_bit = 50 then
					xored := val(0) xor val(1) xor val(26) xor val(27) xor nored;
				elsif n_bit = 51 then
					xored := val(0) xor val(1) xor val(15) xor val(16) xor nored;
				elsif n_bit = 52 then
					xored := val(0) xor val(3) xor nored;
				elsif n_bit = 53 then
					xored := val(0) xor val(1) xor val(15) xor val(16) xor nored;
				elsif n_bit = 54 then
					xored := val(0) xor val(1) xor val(36) xor val(37) xor nored;
				elsif n_bit = 55 then
					xored := val(0) xor val(24) xor nored;
				elsif n_bit = 56 then
					xored := val(0) xor val(1) xor val(21) xor val(22) xor nored;
				elsif n_bit = 57 then
					xored := val(0) xor val(7) xor nored;
				elsif n_bit = 58 then
					xored := val(0) xor val(19) xor nored;
				elsif n_bit = 59 then
					xored := val(0) xor val(1) xor val(21) xor val(22) xor nored;
				elsif n_bit = 60 then
					xored := val(0) xor val(1) xor nored;
				elsif n_bit = 61 then
					xored := val(0) xor val(1) xor val(15) xor val(16) xor nored;
				elsif n_bit = 62 then
					xored := val(0) xor val(1) xor val(46) xor val(47) xor nored;
				elsif n_bit = 63 then
					xored := val(0) xor val(1) xor nored;
				elsif n_bit = 64 then
					xored := val(0) xor val(1) xor val(3) xor val(4) xor nored;
				end if;
				val <= xored & val(n_bit - 1 downto 1);
			end if;
		end if;
	end process;

	output <= val;
end specification;

