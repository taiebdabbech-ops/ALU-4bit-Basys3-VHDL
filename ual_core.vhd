library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ual_core is
    Port (
        clk     : in  std_logic;   
        rst     : in  std_logic;   
        sel     : in  std_logic_vector(3 downto 0);
        inp_a   : in  std_logic_vector(3 downto 0);
        inp_b   : in  std_logic_vector(3 downto 0);
        enable  : in  std_logic;   
        load    : in  std_logic;   
        result  : out std_logic_vector(7 downto 0);
        flag_z  : out std_logic;
        flag_c  : out std_logic;
        flag_eq : out std_logic;
        flag_gt : out std_logic;
        flag_lt : out std_logic
    );
end ual_core;

architecture rtl of ual_core is

    signal lfsr_q      : std_logic_vector(3 downto 0);
    signal shift_q_l   : std_logic_vector(3 downto 0);  
    signal shift_q_r   : std_logic_vector(3 downto 0);  
    signal counter_q   : std_logic_vector(3 downto 0);
    signal comp_result : std_logic_vector(3 downto 0);
    signal comp_eq, comp_gt, comp_lt : std_logic;
    signal mult_result : std_logic_vector(7 downto 0);

    signal lfsr_en, cnt_en, shift_en_l, shift_en_r : std_logic;
    signal result_i : std_logic_vector(7 downto 0);
    signal carry_i, eq_i, gt_i, lt_i : std_logic;

    component lfsr is
        Port (clk : in std_logic; rst : in std_logic; enable : in std_logic; q : out std_logic_vector(3 downto 0));
    end component;

    component shift_register is
        Port (clk : in std_logic; rst : in std_logic; load : in std_logic; enable : in std_logic; dir : in std_logic; din : in std_logic_vector(3 downto 0); q : out std_logic_vector(3 downto 0));
    end component;

    component async_counter is
        Port (clk : in std_logic; rst : in std_logic; enable : in std_logic; q : out std_logic_vector(3 downto 0));
    end component;

    component comparator is
        Port (a : in std_logic_vector(3 downto 0); b : in std_logic_vector(3 downto 0); eq : out std_logic; gt : out std_logic; lt : out std_logic; result : out std_logic_vector(3 downto 0));
    end component;

    component multiplier is
        Port (a : in std_logic_vector(3 downto 0); b : in std_logic_vector(3 downto 0); result : out std_logic_vector(7 downto 0));
    end component;

begin

    lfsr_en    <= enable when (sel = "0001") else '0';
    shift_en_l <= enable when (sel = "0010") else '0';
    shift_en_r <= enable when (sel = "0011") else '0';
    cnt_en     <= enable when (sel = "0100") else '0';

    u_lfsr : lfsr port map (clk => clk, rst => rst, enable => lfsr_en, q => lfsr_q);
    u_shift_left : shift_register port map (clk => clk, rst => rst, load => load, enable => shift_en_l, dir => '0', din => inp_a, q => shift_q_l);
    u_shift_right : shift_register port map (clk => clk, rst => rst, load => load, enable => shift_en_r, dir => '1', din => inp_a, q => shift_q_r);
    u_counter : async_counter port map (clk => clk, rst => rst, enable => cnt_en, q => counter_q);
    u_comparator : comparator port map (a => inp_a, b => inp_b, eq => comp_eq, gt => comp_gt, lt => comp_lt, result => comp_result);
    u_multiplier : multiplier port map (a => inp_a, b => inp_b, result => mult_result);

    p_mux : process(sel, inp_a, inp_b, lfsr_q, shift_q_l, shift_q_r, counter_q, comp_result, mult_result, comp_eq, comp_gt, comp_lt)
    begin
        result_i <= (others => '0');
        carry_i  <= '0';
        eq_i     <= '0';
        gt_i     <= '0';
        lt_i     <= '0';

        case sel is
            when "0000" => result_i <= "0000" & (inp_a xor inp_b);
            when "0001" => result_i <= "0000" & lfsr_q;
            when "0010" => result_i <= "0000" & shift_q_l;
            when "0011" => result_i <= "0000" & shift_q_r;
            when "0100" => result_i <= "0000" & counter_q;
            
            when "0101" => 
                result_i <= "0000" & comp_result;
                eq_i <= comp_eq;  
                gt_i <= comp_gt;
                lt_i <= comp_lt;

            when "0110" => 
                result_i <= mult_result;
                if unsigned(mult_result) > 15 then carry_i <= '1'; end if;
                
            when "0111" => result_i <= inp_a & inp_b;
            when others => result_i <= (others => '0');
        end case;
    end process p_mux;

    result  <= result_i;
    flag_z  <= '1' when (result_i = "00000000") else '0';
    flag_c  <= carry_i;
    flag_eq <= eq_i;
    flag_gt <= gt_i;
    flag_lt <= lt_i;

end rtl;