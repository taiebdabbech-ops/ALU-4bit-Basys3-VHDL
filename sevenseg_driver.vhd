library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sevenseg_driver is
    Port (
        clk       : in  std_logic;   
        tick_1khz : in  std_logic;   
        rst       : in  std_logic;
        digit0    : in  std_logic_vector(3 downto 0); 
        digit1    : in  std_logic_vector(3 downto 0);
        digit2    : in  std_logic_vector(3 downto 0);
        digit3    : in  std_logic_vector(3 downto 0);
        seg       : out std_logic_vector(6 downto 0);
        dp        : out std_logic;
        an        : out std_logic_vector(3 downto 0)
    );
end sevenseg_driver;

architecture Behavioral of sevenseg_driver is
    signal scan_cnt      : unsigned(1 downto 0) := "00";
    signal current_digit : std_logic_vector(3 downto 0);

begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                scan_cnt <= "00";
            elsif tick_1khz = '1' then
                scan_cnt <= scan_cnt + 1;
            end if;
        end if;
    end process;


    process(scan_cnt, digit0, digit1, digit2, digit3)
    begin
        case scan_cnt is
            when "00" => 
                an <= "1110"; 
                current_digit <= digit0;
            when "01" => 
                an <= "1101"; 
                current_digit <= digit1;
            when "10" => 
                an <= "1011"; 
                current_digit <= digit2;
            when "11" => 
                an <= "0111"; 
                current_digit <= digit3;
            when others => 
                an <= "1111"; -- Tout éteint par sécurité
                current_digit <= "0000";
        end case;
    end process;


    process(current_digit)
    begin
        case current_digit is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when "1010" => seg <= "0001000"; -- A
            when "1011" => seg <= "0000011"; -- b
            when "1100" => seg <= "1000110"; -- C
            when "1101" => seg <= "0100001"; -- d
            when "1110" => seg <= "0000110"; -- E
            when "1111" => seg <= "0001110"; -- F
            when others => seg <= "1111111"; -- Tout éteint
        end case;
    end process;

    
    dp <= '1';  
    
end Behavioral;