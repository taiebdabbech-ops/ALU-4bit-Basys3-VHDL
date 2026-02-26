library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_basys3 is
    Port (
        clk  : in  std_logic;                     
        sw   : in  std_logic_vector(15 downto 0); 
        btnc : in  std_logic;                 
        btnu : in  std_logic;                     
        btnl : in  std_logic;                     
        led  : out std_logic_vector(15 downto 0); 
        seg  : out std_logic_vector(6 downto 0);  
        dp   : out std_logic;                     
        an   : out std_logic_vector(3 downto 0)   
    );
end top_basys3;

architecture rtl of top_basys3 is

    signal rst       : std_logic;
    signal tick_1hz  : std_logic;
    signal tick_1khz : std_logic;

    signal inp_a, inp_b, sel : std_logic_vector(3 downto 0);
    signal alu_result        : std_logic_vector(7 downto 0);
    signal flag_z, flag_c, flag_eq, flag_gt, flag_lt : std_logic;

    -- Registres pour boutons
    signal btnu_sync : std_logic_vector(2 downto 0) := "000";
    signal btnl_sync : std_logic_vector(2 downto 0) := "000";
    signal btnu_tick : std_logic;
    signal btnl_tick : std_logic;
    signal sys_enable: std_logic;
    
    signal status_digit : std_logic_vector(3 downto 0);

    component clock_divider is
        Generic (CNT_1HZ_MAX : integer := 99_999_999; CNT_1KHZ_MAX : integer := 99_999);
        Port (clk : in std_logic; rst : in std_logic; tick_1hz : out std_logic; tick_1khz : out std_logic);
    end component;

    component ual_core is
        Port (clk : in std_logic; rst : in std_logic; sel : in std_logic_vector(3 downto 0); inp_a : in std_logic_vector(3 downto 0); inp_b : in std_logic_vector(3 downto 0); enable : in std_logic; load : in std_logic; result : out std_logic_vector(7 downto 0); flag_z : out std_logic; flag_c : out std_logic; flag_eq : out std_logic; flag_gt : out std_logic; flag_lt : out std_logic);
    end component;

    component sevenseg_driver is
        Port (clk : in std_logic; tick_1khz : in std_logic; rst : in std_logic; digit0 : in std_logic_vector(3 downto 0); digit1 : in std_logic_vector(3 downto 0); digit2 : in std_logic_vector(3 downto 0); digit3 : in std_logic_vector(3 downto 0); seg : out std_logic_vector(6 downto 0); dp : out std_logic; an : out std_logic_vector(3 downto 0));
    end component;

begin

    rst   <= btnc;
    inp_a <= sw(3 downto 0);
    inp_b <= sw(7 downto 4);
    sel   <= sw(11 downto 8);


    process(clk)
    begin
        if rising_edge(clk) then
            btnu_sync <= btnu_sync(1 downto 0) & btnu;
            btnl_sync <= btnl_sync(1 downto 0) & btnl;
        end if;
    end process;
    
    btnu_tick <= btnu_sync(1) and not btnu_sync(2);
    btnl_tick <= btnl_sync(1) and not btnl_sync(2);

    
    sys_enable <= tick_1hz or btnu_tick;

    u_clk : clock_divider
        port map (clk => clk, rst => rst, tick_1hz => tick_1hz, tick_1khz => tick_1khz);

    u_ual : ual_core
        port map (clk => clk, rst => rst, sel => sel, inp_a => inp_a, inp_b => inp_b, enable => sys_enable, load => btnl_tick, result => alu_result, flag_z => flag_z, flag_c => flag_c, flag_eq => flag_eq, flag_gt => flag_gt, flag_lt => flag_lt);

    status_digit <= flag_z & flag_c & flag_eq & flag_gt;

    u_sevenseg : sevenseg_driver
        port map (clk => clk, tick_1khz => tick_1khz, rst => rst, digit0 => alu_result(3 downto 0), digit1 => alu_result(7 downto 4), digit2 => sel, digit3 => status_digit, seg => seg, dp => dp, an => an);

    led(7 downto 0)   <= alu_result;
    led(8)            <= flag_z;
    led(9)            <= flag_c;
    led(10)           <= flag_eq;
    led(11)           <= flag_gt;
    led(12)           <= flag_lt;
    led(15 downto 13) <= "000";

end rtl;