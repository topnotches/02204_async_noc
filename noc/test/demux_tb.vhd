library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;
use work.data_if_pkg.all;

entity demux_tb is
end demux_tb;

architecture behavioral of demux_tb is
    signal rst_signal     : std_logic                                     := '1';
    signal in_ack_signal  : std_logic                                     := '0';
    signal in_req_signal  : std_logic                                     := '0';
    signal in_data_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal outB_req_signal  : std_logic                                     := '0';
    signal outB_data_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal outB_ack_signal  : std_logic                                     := '0';

    signal outC_req_signal  : std_logic                                     := '0';
    signal outC_data_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal outC_ack_signal  : std_logic                                     := '0';

    signal selector_req_signal : std_logic := '0';
    signal selector_signal     : std_logic := '0';
    signal selector_ack_signal : std_logic := '0';
begin

    DUT : entity work.DEMUX
        generic
        map(
        DATA_WIDTH   => 4,
        PHASE_INIT_A => '0',
        PHASE_INIT_B => '0',
        PHASE_INIT_C => '0'
        )
        port map
        (
            rst => rst_signal,
            -- Input port
            inA_req  => in_req_signal,
            inA_data => in_data_signal,
            inA_ack  => in_ack_signal,
            -- Select port 
            inSel_req => selector_req_signal,
            inSel_ack => selector_ack_signal,
            selector  => selector_signal,
            -- Output channel 1
            outB_req  => outB_req_signal,
            outB_data => outB_data_signal,
            outB_ack  => outB_ack_signal,
            -- Output channel 2
            outC_req  => outC_req_signal,
            outC_data => outC_data_signal,
            outC_ack  => outC_ack_signal
        );
    -- Testbench for diagonal input
    TB : block
    begin
        process

        begin
            wait for 100 ns;
            rst_signal <= '0';
            wait for 100 ns;
            in_data_signal  <= "1111";
            selector_signal <= '1';--selects out B
            wait for 100 ns;
            in_req_signal       <= not in_req_signal;
            selector_req_signal <= not selector_req_signal;

            wait until outB_req_signal'event;
            assert outB_data_signal = "1111" report "Error in outB_data_signal" severity error;
            wait for 50 ns;
            outB_ack_signal <= not outB_ack_signal;

            in_data_signal  <= "0000";
            selector_signal <= '0';--selects out C
            wait for 100 ns;
            in_req_signal       <= not in_req_signal;
            selector_req_signal <= not selector_req_signal;

            wait until outC_req_signal'event;
            assert outC_data_signal = "0000" report "Error in outC_data_signal" severity error;
            outC_ack_signal <= not outC_ack_signal;
        end process;
    end block;

end architecture;