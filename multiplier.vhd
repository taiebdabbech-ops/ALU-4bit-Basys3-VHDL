library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier is
    Port (
        a      : in  std_logic_vector(3 downto 0);
        b      : in  std_logic_vector(3 downto 0);
        result : out std_logic_vector(7 downto 0)
    );
end multiplier;

architecture rtl of multiplier is
begin
    result <= std_logic_vector(unsigned(a) * unsigned(b));

end rtl;