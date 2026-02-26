library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity async_counter is
    Port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        enable : in  std_logic;
        q      : out std_logic_vector(3 downto 0)
    );
end async_counter;

architecture rtl of async_counter is
    signal count : unsigned(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count <= "0000";
            elsif enable = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;
    q <= std_logic_vector(count);
end rtl;