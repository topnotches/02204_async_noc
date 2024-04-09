LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.noc_defs_pkg.ALL;
USE work.data_if_pkg.ALL;

ENTITY buffer_tb IS
END buffer_tb;

ARCHITECTURE behavioral OF buffer_tb IS
    CONSTANT BUFFER_LENGTH : INTEGER := 4;

    -- Assuming NOC_ADDRESS_WIDTH, NOC_DATA_WIDTH are previously defined constants
    SIGNAL rst_signal : STD_LOGIC := '0';

    SIGNAL in_ack_signal : STD_LOGIC := '0';
    SIGNAL in_req_signal : STD_LOGIC := '0';
    SIGNAL in_data_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    SIGNAL out_ack_signal : STD_LOGIC := '0';
    SIGNAL out_req_signal : STD_LOGIC := '0';
    SIGNAL out_data_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

BEGIN

    DUT : ENTITY work.buffer_rtl
        GENERIC MAP (
            buffer_length => BUFFER_LENGTH
        )
        PORT MAP(
            rst => rst_signal,

            in_ack => in_ack_signal,
            in_req => in_req_signal,
            in_data => in_data_signal,

            out_ack => out_ack_signal,
            out_req => out_req_signal,
            out_data => out_data_signal
        );

    -- Stimulus process
    stimulus : PROCESS
    BEGIN
        -- Reset
        rst_signal <= '1';
        wait for 10 ns;
        rst_signal <= '0';

        wait for 10 ns;
        in_req_signal <= '1';
        in_data_signal <= (others => '1');
        wait until rising_edge(in_ack_signal);

        wait until rising_edge(out_req_signal);
        wait for 1 ns;
        out_ack_signal <= '1';

        wait for 10 ns;
        in_req_signal <= '0';
        in_data_signal <= (others => '1');
        wait until falling_edge(in_ack_signal);

        wait until falling_edge(out_req_signal);
        wait for 1 ns;
        out_ack_signal <= '0';

        wait;
    END PROCESS;

  -- Reset Signal Goes Low
  rst_signal <= '0' after 50 ns;
END ARCHITECTURE;