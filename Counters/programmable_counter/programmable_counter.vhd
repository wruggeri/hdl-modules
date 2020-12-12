library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

---PROGRAMMING THE COUNTER--------------------------------------------------------------------------
--- The configuration register has the size of the number of bits of the counter n_bit_count; 
--- given the configuration register includes, MSB to LSB, the prescaling value and four 
--- configuration bits, it's implicitly assumed that the prescaler's size n_bit_prescaler 
--- is not greater than n_bit_count - 4; obviously, if n_bit_prescaler + 4 < n_bit_count the 
--- actual MSBs of the configuration register may simply be unused bits. The four 
--- configuration bits encode the counter configuration as follows:
---     xxx0 Downcounting
---     xxx1 Upcounting
---     xx0x Use counter max/min
---     xx1x Use custom max/min
---     x0xx One-shot counting
---     x1xx Repeated counting
---     0xxx No prescaling
---     1xxx Prescaling
--- Programming and custom value loading must be performed with the counter disabled.
-----------------------------------------------------------------------------------------------------

entity programmable_counter is
    generic(n_bit_count: natural := 16;
        n_bit_prescaler: natural := 5);
        port(custom_value_load, configuration_load: in std_logic;
			clock, reset, enable, apply_settings: in std_logic;
            settings: in std_logic_vector(n_bit_count - 1 downto 0);
            count: out std_logic_vector(n_bit_count - 1 downto 0);
            end_of_count: out std_logic);
end programmable_counter;

architecture specification of programmable_counter is
    component synchronous_counter
        generic(n_bit: natural := 8);
        port(clock, enable, reset, load: in std_logic;
            max_value: in std_logic_vector(n_bit - 1 downto 0);
            count: out std_logic_vector(n_bit - 1 downto 0);
            end_of_count: out std_logic);               
    end component;
    
    signal configuration_register: std_logic_vector(n_bit_count - 1 downto 0);
    signal custom_value_register: unsigned(n_bit_count - 1 downto 0);
    signal enable_prescaler, load_prescaler, eoc_prescaler, enable_count, updown, custom_limit, repeat, use_prescaler: std_logic;
    signal max_value_prescaler: std_logic_vector(n_bit_prescaler - 1 downto 0);
    signal count_value: unsigned(n_bit_count - 1 downto 0);
begin
    --Internal signals
    updown <= configuration_register(0);
    custom_limit <= configuration_register(1);
    repeat <= configuration_register(2);
    use_prescaler <= configuration_register(3);
    enable_prescaler <= use_prescaler and enable;
    max_value_prescaler <= configuration_register(n_bit_prescaler + 3 downto 4);
    enable_count <= (eoc_prescaler or not(use_prescaler)) and or_reduce(configuration_register(3 downto 0)) and enable;
    load_prescaler <= apply_settings;
	
    --Outputs
    count <= std_logic_vector(count_value);
    end_of_count <= '1' when (custom_limit = '1' and count_value = unsigned(custom_value_register)) else
        '1' when (custom_limit = '0' and updown = '1' and and_reduce(std_logic_vector(count_value)) = '1') else
        '1' when (custom_limit = '0' and updown = '0' and nor_reduce(std_logic_vector(count_value)) = '1') else
        '0';
    
    prescaler: synchronous_counter generic map(n_bit => n_bit_prescaler)
        port map(clock => clock, 
			enable => enable_prescaler, 
			reset => reset, 
			load => load_prescaler, 
            max_value => max_value_prescaler, 
			end_of_count => eoc_prescaler);
    
    process(clock, reset)
    begin
        if reset = '1' then
            configuration_register <= (others => '0');
            custom_value_register <= (others => '0');
            count_value <= (others => '0');
        else
            if clock = '1' and clock'event then 
                if enable_count = '1' then
                    if updown = '1' then 
                        if custom_limit = '0' then
                            if not(repeat = '0' and and_reduce(std_logic_vector(count_value)) = '1') then
                                count_value <= count_value + 1;
                            end if;
                        elsif custom_limit = '1' then
                            if count_value = unsigned(custom_value_register) then
                                if repeat = '1' then
                                    count_value <= (others => '0');
                                end if;
                            else
                                count_value <= count_value + 1;
                            end if;
                        end if;
                    elsif updown = '0' then
                        if custom_limit = '0' then
                            if not(repeat = '0' and nor_reduce(std_logic_vector(count_value)) = '1') then
                                count_value <= count_value - 1;
                            end if;
                        elsif custom_limit = '1' then
                            if count_value = unsigned(custom_value_register) then
                                if repeat = '1' then
                                    count_value <= (others => '1');
                                end if;
                            else
                                count_value <= count_value - 1;
                            end if;
                        end if;
                    end if;
                elsif configuration_load = '1' then
                    configuration_register <= settings;
                elsif custom_value_load = '1' then
                    custom_value_register <= unsigned(settings);
                elsif apply_settings = '1' then
                    if nor_reduce(configuration_register(3 downto 0)) = '0' then
                        if updown = '0' then
                            count_value <= (others => '1');
                        elsif updown = '1' then
                            count_value <= (others => '0');
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end specification;
