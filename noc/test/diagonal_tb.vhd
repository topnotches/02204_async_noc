LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.noc_defs_pkg.ALL;
USE work.data_if_pkg.ALL;
ENTITY diagonal_tb IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        sig
    );
END diagonal_tb;

ARCHITECTURE behavioral OF diagonal_tb IS
    -- Assuming NOC_ADDRESS_WIDTH, NOC_DATA_WIDTH are previously defined constants
    SIGNAL rst_signal : STD_LOGIC;

    SIGNAL in_local_address_x_signal : STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0) := "00";
    SIGNAL in_local_address_y_signal : STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0) := "00";
    )
    SIGNAL in_ack_signal : STD_LOGIC;
    SIGNAL in_req_signal : STD_LOGIC;
    SIGNAL in_data_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    SIGNAL out_req_continue_signal : STD_LOGIC;
    SIGNAL out_data_continue_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL out_ack_continue_signal : STD_LOGIC;

    SIGNAL out_req_we_signal : STD_LOGIC;
    SIGNAL out_data_we_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL out_ack_we_signal : STD_LOGIC;

    SIGNAL out_req_ns_signal : STD_LOGIC;
    SIGNAL out_data_ns_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL out_ack_ns_signal : STD_LOGIC;

    SIGNAL out_req_local_signal : STD_LOGIC;
    SIGNAL out_data_local_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL out_ack_local_signal : STD_LOGIC;
    TYPE a8_data_if_t IS ARRAY (NATURAL 0 TO 7) OF data_if;
    SIGNAL sa8_data_if_stimuli : a8_data_if_t :=    (init_data_if(0, 0),
                                                    init_data_if(0, 1),
                                                    init_data_if(1, 0),
                                                    init_data_if(1, 1));
BEGIN

    DUT : ENTITY work.diagonal_input_rtl
        PORT MAP(
            rst => rst_signal,

            in_local_address_x => in_local_address_x_signal,
            in_local_address_y => in_local_address_y_signal,

            in_ack => in_ack_signal,
            in_req => in_req_signal,
            in_data => in_data_signal,

            out_req_continue => out_req_continue_signal,
            out_data_continue => out_data_continue_signal,
            out_ack_continue => out_ack_continue_signal,

            out_req_we => out_req_we_signal,
            out_data_we => out_data_we_signal,
            out_ack_we => out_ack_we_signal,

            out_req_ns => out_req_ns_signal,
            out_data_ns => out_data_ns_signal,
            out_ack_ns => out_ack_ns_signal,

            out_req_local => out_req_local_signal,
            out_data_local => out_data_local_signal,
            out_ack_local => out_ack_local_signal
        );

        
    -- Reset Signal Goes Low
    rst <= '0' AFTER 50 ns;
END ARCHITECTURE;