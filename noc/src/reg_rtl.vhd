library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity reg_rtl is
    port
    (
        pil_clk : in std_logic;
        pil_rst : in std_logic;

        pil_data  : in std_logic;
        pil_en    : in std_logic;
        pol_q     : out std_logic;
        pol_q_inv : out std_logic
    );
end entity reg_rtl;

architecture rtl of reg_rtl is
    signal sl_q : std_logic := '0';
begin

    pol_q_inv <= not sl_q;
    pol_q     <= sl_q;
    REG_PROCESS : process (sensitivity_list)
    begin
        if rising_edge(pil_clk) then
            if (pil_rst = '1') then
                sl_q <= '0';
            elsif (pil_en = '1') then
                sl_q <= pil_data;
            end if;
        end if;
    end process REG_PROCESS;
end architecture;