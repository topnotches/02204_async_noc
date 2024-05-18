library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity noc_hw_tb is
end entity noc_hw_tb;

architecture rtl of noc_hw_tb is
    signal signal_rst       : std_logic                     := '1';
    signal sl_clk           : std_logic                     := '0';
    signal sl_rst           : std_logic                     := '0';
    signal sl4_switches     : std_logic_vector(3 downto 0)  := (others => '0');
    signal sl16_leds        : std_logic_vector(15 downto 0) := (others => '0');
    signal sl_seg_light     : std_logic                     := '0';
    signal sl_button_left   : std_logic                     := '0';
    signal sl_button_top    : std_logic                     := '0';
    signal sl_button_bottom : std_logic                     := '0';
    signal sl_button_center : std_logic                     := '0';
begin

    dut : entity work.noc_hw_top(rtl)
        port map
        (

            pil_clk => sl_clk,
            pil_rst => signal_rst,
            -- Switches
            pil4_switches => sl4_switches,
            -- LEDs
            pol16_leds => sl16_leds,

            pol_seg_light     => sl_seg_light,
            pil_button_left   => sl_button_left,
            pil_button_top    => sl_button_top,
            pil_button_bottom => sl_button_bottom,
            pil_button_center => sl_button_center
        );

    -- Testbench for diagonal input

    tb : block is
    begin

        process is
        begin
            sl4_switches <= "0001";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "0010";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "0011";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "0100";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "0101";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "0110";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "0111";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "1000";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "1001";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "1010";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "1011";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "1100";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "1101";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "1110";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl4_switches <= "1111";
            wait for 100 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;
            sl_button_center <= not sl_button_center;
            wait for 10 ns;

        end process;

    end block tb;

    -- Reset Signal Goes Low
    signal_rst <= '0' after 50 ns;
    sl_clk     <= not sl_clk after 5 ns;
end architecture;