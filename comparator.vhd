library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator is
    Port (
        a      : in  std_logic_vector(3 downto 0);
        b      : in  std_logic_vector(3 downto 0);
        eq     : out std_logic;
        gt     : out std_logic;
        lt     : out std_logic;
        result : out std_logic_vector(3 downto 0)
    );
end comparator;

architecture rtl of comparator is
    signal a_u : unsigned(3 downto 0);
    signal b_u : unsigned(3 downto 0);
begin

    a_u <= unsigned(a);
    b_u <= unsigned(b);

    eq <= '1' when a_u = b_u else '0';
    gt <= '1' when a_u > b_u else '0';
    lt <= '1' when a_u < b_u else '0';

    
    result <= "0001" when a_u = b_u else   
              "0010" when a_u > b_u else   
              "0100";                       

end rtl;