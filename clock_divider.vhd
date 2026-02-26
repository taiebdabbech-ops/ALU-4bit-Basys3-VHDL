library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Generic (
        CNT_1HZ_MAX  : integer := 99_999_999;  
        CNT_1KHZ_MAX : integer := 99_999       
    );
    Port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        tick_1hz  : out std_logic;
        tick_1khz : out std_logic
    );
end clock_divider;

architecture rtl of clock_divider is
    signal cnt_1hz  : integer range 0 to CNT_1HZ_MAX := 0;
    signal cnt_1khz : integer range 0 to CNT_1KHZ_MAX := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt_1hz   <= 0;
                cnt_1khz  <= 0;
                tick_1hz  <= '0';
                tick_1khz <= '0';
            else
                
                if cnt_1hz = CNT_1HZ_MAX then
                    cnt_1hz  <= 0;
                    tick_1hz <= '1';
                else
                    cnt_1hz  <= cnt_1hz + 1;
                    tick_1hz <= '0';
                end if;

                
                if cnt_1khz = CNT_1KHZ_MAX then
                    cnt_1khz  <= 0;
                    tick_1khz <= '1';
                else
                    cnt_1khz  <= cnt_1khz + 1;
                    tick_1khz <= '0';
                end if;
            end if;
        end if;
    end process;
end rtl;