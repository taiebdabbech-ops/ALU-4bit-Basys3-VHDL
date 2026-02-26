library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lfsr is
    Port (
        clk    : in  std_logic;   
        rst    : in  std_logic;
        enable : in  std_logic;   
        q      : out std_logic_vector(3 downto 0)
    );
end lfsr;

architecture rtl of lfsr is
    signal state    : std_logic_vector(3 downto 0) := "0001";
    signal feedback : std_logic;
begin
    
    feedback <= state(3) xor state(0);

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= "0001";
            elsif enable = '1' then
                if state = "0000" then
                    state <= "0001";
                else
                   
                    state <= feedback & state(3 downto 1);
                end if;
            end if;
        end if;
    end process;
    
    q <= state;
end rtl;