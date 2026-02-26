library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_register is
    Port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        load   : in  std_logic;
        enable : in  std_logic;
        dir    : in  std_logic;
        din    : in  std_logic_vector(3 downto 0);
        q      : out std_logic_vector(3 downto 0)
    );
end shift_register;

architecture rtl of shift_register is
    signal reg : std_logic_vector(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                reg <= (others => '0');
            elsif load = '1' then
                reg <= din;
            elsif enable = '1' then
                if dir = '0' then
                    reg <= reg(2 downto 0) & reg(3);
                else
                    reg <= reg(0) & reg(3 downto 1);
                end if;
            end if;
        end if;
    end process;
    q <= reg;
end rtl;