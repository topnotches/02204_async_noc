library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;

entity diagonal_input_rtl is
    port
    (
        rst : in std_logic;

        -- Local Address
        in_local_address_x : in std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
        in_local_address_y : in std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');

        -- Input channel
        in_ack  : out std_logic;
        in_req  : in std_logic;
        in_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

        -- Output Continue
        out_req_continue  : out std_logic;
        out_data_continue : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
        out_ack_continue  : in std_logic;

        -- Output West/East
        out_req_we  : out std_logic;
        out_data_we : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
        out_ack_we  : in std_logic;

        -- Output North/South
        out_req_ns  : out std_logic;
        out_data_ns : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
        out_ack_ns  : in std_logic;

        -- Output Local
        out_req_local  : out std_logic;
        out_data_local : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
        out_ack_local  : in std_logic
    );
end entity diagonal_input_rtl;

architecture rtl of diagonal_input_rtl is

    -- Stage 0 Signals
    signal stage_0_ack  : std_logic                                     := '0';
    signal stage_0_req  : std_logic                                     := '0';
    signal stage_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- Stage 1 Signals (fork)

    -- Port Path
    signal stage_1_port_ack  : std_logic                                     := '0';
    signal stage_1_port_req  : std_logic                                     := '0';
    signal stage_1_port_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    -- Compare Path
    signal stage_1_compare_ack  : std_logic                                     := '0';
    signal stage_1_compare_req  : std_logic                                     := '0';
    signal stage_1_compare_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- Stage DEMUX
    -- DEMUX 0
    signal stage_demux_0_sel_0_ack  : std_logic                                                       := '0';
    signal stage_demux_0_sel_0_req  : std_logic                                                       := '0';
    signal stage_demux_0_sel_0_data : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    signal stage_demux_0_sel_1_ack  : std_logic                                                       := '0';
    signal stage_demux_0_sel_1_req  : std_logic                                                       := '0';
    signal stage_demux_0_sel_1_data : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    -- DEMUX 1
    signal stage_demux_1_sel_0_ack  : std_logic                                                       := '0';
    signal stage_demux_1_sel_0_req  : std_logic                                                       := '0';
    signal stage_demux_1_sel_0_data : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_1_WIDTH - 1 downto 0) := (others => '0');

    signal stage_demux_1_sel_1_ack  : std_logic                                                       := '0';
    signal stage_demux_1_sel_1_req  : std_logic                                                       := '0';
    signal stage_demux_1_sel_1_data : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_1_WIDTH - 1 downto 0) := (others => '0');

    -- DEMUX 2
    signal stage_demux_2_sel_0_ack  : std_logic                                                       := '0';
    signal stage_demux_2_sel_0_req  : std_logic                                                       := '0';
    signal stage_demux_2_sel_0_data : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_2_WIDTH - 1 downto 0) := (others => '0');

    signal stage_demux_2_sel_1_ack  : std_logic                                                       := '0';
    signal stage_demux_2_sel_1_req  : std_logic                                                       := '0';
    signal stage_demux_2_sel_1_data : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_2_WIDTH - 1 downto 0) := (others => '0');

    -- Stage Compare

    -- Fork
    signal stage_compare_x_ack  : std_logic                                                            := '0';
    signal stage_compare_x_req  : std_logic                                                            := '0';
    signal stage_compare_x_data : std_logic_vector(NOC_DIAGONAL_STAGE_COMPARE_FORK_WIDTH - 1 downto 0) := (others => '0');

    signal stage_compare_y_ack  : std_logic                                                            := '0';
    signal stage_compare_y_req  : std_logic                                                            := '0';
    signal stage_compare_y_data : std_logic_vector(NOC_DIAGONAL_STAGE_COMPARE_FORK_WIDTH - 1 downto 0) := (others => '0');

    -- Compare X
    -- INPUT
    signal stage_compare_x_input_ack  : std_logic                                                  := '0';
    signal stage_compare_x_input_req  : std_logic                                                  := '0';
    signal stage_compare_x_input_data : std_logic_vector(stage_compare_x_data'length - 1 downto 0) := (others => '0');

    -- OUTPUT
    signal stage_compare_x_output_ack  : std_logic                                                              := '0';
    signal stage_compare_x_output_req  : std_logic                                                              := '0';
    signal stage_compare_x_output_data : std_logic_vector(NOC_DIAGONAL_STAGE_COMPARE_X_FORK_WIDTH - 1 downto 0) := (others => '0');

    -- Compare Y
    -- INPUT
    signal stage_compare_y_input_ack  : std_logic                                                  := '0';
    signal stage_compare_y_input_req  : std_logic                                                  := '0';
    signal stage_compare_y_input_data : std_logic_vector(stage_compare_y_data'length - 1 downto 0) := (others => '0');

    -- OUTPUT
    signal stage_compare_y_output_ack  : std_logic                                                              := '0';
    signal stage_compare_y_output_req  : std_logic                                                              := '0';
    signal stage_compare_y_output_data : std_logic_vector(NOC_DIAGONAL_STAGE_COMPARE_X_FORK_WIDTH - 1 downto 0) := (others => '0');

    -- Y Select Fork Stage
    signal stage_select_x_fork_0_ack  : std_logic                                                              := '0';
    signal stage_select_x_fork_0_req  : std_logic                                                              := '0';
    signal stage_select_x_fork_0_data : std_logic_vector(NOC_DIAGONAL_STAGE_COMPARE_X_FORK_WIDTH - 1 downto 0) := (others => '0');

    signal stage_select_x_fork_1_ack  : std_logic                                                              := '0';
    signal stage_select_x_fork_1_req  : std_logic                                                              := '0';
    signal stage_select_x_fork_1_data : std_logic_vector(NOC_DIAGONAL_STAGE_COMPARE_X_FORK_WIDTH - 1 downto 0) := (others => '0');
    -- Y Select Demux Stage
    signal stage_select_y_demux_0_ack  : std_logic                                                               := '0';
    signal stage_select_y_demux_0_req  : std_logic                                                               := '0';
    signal stage_select_y_demux_0_data : std_logic_vector(NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_WIDTH - 1 downto 0) := (others => '0');

    signal stage_select_y_demux_1_ack  : std_logic                                                               := '0';
    signal stage_select_y_demux_1_req  : std_logic                                                               := '0';
    signal stage_select_y_demux_1_data : std_logic_vector(NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_WIDTH - 1 downto 0) := (others => '0');
begin

    out_req_local           <= stage_demux_1_sel_0_req;
    out_data_local          <= stage_demux_1_sel_0_data;
    stage_demux_1_sel_0_ack <= out_ack_local;

    out_req_we              <= stage_demux_2_sel_0_req;
    out_data_we             <= stage_demux_2_sel_0_data;
    stage_demux_2_sel_0_ack <= out_ack_we;

    out_req_ns              <= stage_demux_1_sel_1_req;
    out_data_ns             <= stage_demux_1_sel_1_data;
    stage_demux_1_sel_1_ack <= out_ack_ns;

    out_req_continue        <= stage_demux_2_sel_1_req;
    out_data_continue       <= stage_demux_2_sel_1_data;
    stage_demux_2_sel_1_ack <= out_ack_continue;

    stage_0_click : entity work.click_element(Behavioral)
        generic
        map(
        DATA_WIDTH => NOC_DIAGONAL_STAGE_0_CLICK_WIDTH,
        VALUE      => NOC_DIAGONAL_STAGE_0_CLICK_VALUE,
        PHASE_INIT => NOC_DIAGONAL_STAGE_0_CLICK_PHASE -- Set PHASE_INIT to '0' as per your requirements
        )
        port map
        (
            rst      => rst, -- Connect rst port to your reset signal
            in_ack   => in_ack, -- Connect in_ack port to your signal for in_ack
            in_req   => in_req, -- Connect in_req port to your signal for in_req
            in_data  => in_data, -- Connect in_data port to your signal for in_data
            out_req  => stage_0_req, -- Connect out_req port to your signal for out_req
            out_data => stage_0_data, -- Connect out_data port to your signal for out_data
            out_ack  => stage_0_ack -- Connect out_ack port to your signal for out_ack
        );

    stage_1_fork : entity work.reg_fork(Behavioral)
        generic
        map(
        DATA_WIDTH   => NOC_DIAGONAL_STAGE_0_FORK_WIDTH,
        VALUE        => NOC_DIAGONAL_STAGE_0_FORK_VALUE,
        PHASE_INIT_A => NOC_DIAGONAL_STAGE_0_FORK_PHASE_A,
        PHASE_INIT_B => NOC_DIAGONAL_STAGE_0_FORK_PHASE_B,
        PHASE_INIT_C => NOC_DIAGONAL_STAGE_0_FORK_PHASE_C
        )
        port
        map(
        rst => rst,
        --Input channel
        inA_req  => stage_0_req,
        inA_data => stage_0_data,
        inA_ack  => stage_0_ack,
        --Output Port Path
        outB_req  => stage_1_port_req,
        outB_data => stage_1_port_data,
        outB_ack  => stage_1_port_ack,
        --Output Compare Path 
        outC_req  => stage_1_compare_req,
        outC_data => stage_1_compare_data,
        outC_ack  => stage_1_compare_ack
        );

    -- Stage demux
    stage_demux_0 : entity work.demux(Behavioral)
        generic
        map(
        DATA_WIDTH   => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
        PHASE_INIT_A => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
        PHASE_INIT_B => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
        PHASE_INIT_C => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
        )
        port
        map(
        rst => rst,
        -- Input port
        inA_req  => stage_1_port_req,
        inA_data => stage_1_port_data,
        inA_ack  => stage_1_port_ack,
        -- Select port 
        inSel_req => stage_select_x_fork_0_req,
        inSel_ack => stage_select_x_fork_0_ack,
        selector  => stage_select_x_fork_0_data(0),
        -- Output channel 1
        outC_req  => stage_demux_0_sel_0_req,
        outC_data => stage_demux_0_sel_0_data,
        outC_ack  => stage_demux_0_sel_0_ack,
        -- Output channel 2
        outB_req  => stage_demux_0_sel_1_req,
        outB_data => stage_demux_0_sel_1_data,
        outB_ack  => stage_demux_0_sel_1_ack
        );
    stage_demux_1 : entity work.demux(Behavioral)
        generic
        map(
        DATA_WIDTH   => NOC_DIAGONAL_STAGE_DEMUX_1_WIDTH,
        PHASE_INIT_A => NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_A,
        PHASE_INIT_B => NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_B,
        PHASE_INIT_C => NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_C
        )
        port
        map(
        rst => rst,
        -- Input port
        inA_req  => stage_demux_0_sel_0_req,
        inA_data => stage_demux_0_sel_0_data,
        inA_ack  => stage_demux_0_sel_0_ack,
        -- Select port 
        inSel_req => stage_select_y_demux_0_req,
        inSel_ack => stage_select_y_demux_0_ack,
        selector  => stage_select_y_demux_0_data(0),
        -- Output channel 1
        outC_req  => stage_demux_1_sel_0_req,
        outC_data => stage_demux_1_sel_0_data,
        outC_ack  => stage_demux_1_sel_0_ack,
        -- Output channel 2
        outB_req  => stage_demux_1_sel_1_req,
        outB_data => stage_demux_1_sel_1_data,
        outB_ack  => stage_demux_1_sel_1_ack
        );
    stage_demux_2 : entity work.demux(Behavioral)
        generic
        map(
        DATA_WIDTH   => NOC_DIAGONAL_STAGE_DEMUX_2_WIDTH,
        PHASE_INIT_A => NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_A,
        PHASE_INIT_B => NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_B,
        PHASE_INIT_C => NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_C
        )
        port
        map(
        rst => rst,
        -- Input port
        inA_req  => stage_demux_0_sel_1_req,
        inA_data => stage_demux_0_sel_1_data,
        inA_ack  => stage_demux_0_sel_1_ack,
        -- Select port 
        inSel_req => stage_select_y_demux_1_req,
        inSel_ack => stage_select_y_demux_1_ack,
        selector  => stage_select_y_demux_1_data(0),
        -- Output channel 1
        outC_req  => stage_demux_2_sel_0_req,
        outC_data => stage_demux_2_sel_0_data,
        outC_ack  => stage_demux_2_sel_0_ack,
        -- Output channel 2
        outB_req  => stage_demux_2_sel_1_req,
        outB_data => stage_demux_2_sel_1_data,
        outB_ack  => stage_demux_2_sel_1_ack
        );

    -- compare addresses
    stage_compare_fork : entity work.reg_fork(Behavioral)
        generic
        map(
        DATA_WIDTH   => NOC_DIAGONAL_STAGE_COMPARE_FORK_WIDTH,
        VALUE        => NOC_DIAGONAL_STAGE_COMPARE_FORK_VALUE,
        PHASE_INIT_A => NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_A,
        PHASE_INIT_B => NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_B,
        PHASE_INIT_C => NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_C
        )
        port
        map(
        rst => rst,
        --Input channel
        inA_req  => stage_1_compare_req,
        inA_data => stage_1_compare_data,
        inA_ack  => stage_1_compare_ack,
        --Output X Path
        outB_req  => stage_compare_x_input_req,
        outB_data => stage_compare_x_input_data,
        outB_ack  => stage_compare_x_input_ack,
        --Output Y Path 
        outC_req  => stage_compare_y_input_req,
        outC_data => stage_compare_y_input_data,
        outC_ack  => stage_compare_y_input_ack
        );

    -- generate compare selectors
    stage_compare_x : entity work.compare_address_diff_rtl(rtl)
        port
        map
        (
        in_local_address => in_local_address_x,
        in_ack           => stage_compare_x_input_ack,
        in_req           => stage_compare_x_input_req,
        in_data          => slv_to_data_if(stage_compare_x_input_data).x,
        out_req          => stage_compare_x_output_req,
        out_data         => stage_compare_x_output_data(0),
        out_ack          => stage_compare_x_output_ack
        );

    stage_compare_y : entity work.compare_address_diff_rtl(rtl)
        generic
        map (
        COMPARE_DELAY => 12
        )
        port
        map
        (
        in_local_address => in_local_address_y,
        in_ack           => stage_compare_y_input_ack,
        in_req           => stage_compare_y_input_req,
        in_data          => slv_to_data_if(stage_compare_y_input_data).y,
        out_req          => stage_compare_y_output_req,
        out_data         => stage_compare_y_output_data(0),
        out_ack          => stage_compare_y_output_ack
        );

    stage_compare_x_fork : entity work.reg_fork(Behavioral)
        generic
        map(
        DATA_WIDTH   => NOC_DIAGONAL_STAGE_COMPARE_X_FORK_WIDTH,
        VALUE        => NOC_DIAGONAL_STAGE_COMPARE_X_FORK_VALUE,
        PHASE_INIT_A => NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_A,
        PHASE_INIT_B => NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_B,
        PHASE_INIT_C => NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_C
        )
        port
        map(
        rst => rst,
        --Input channel
        inA_req  => stage_compare_x_output_req,
        inA_data => stage_compare_x_output_data,
        inA_ack  => stage_compare_x_output_ack,
        --Output Y 0 
        outB_req  => stage_select_x_fork_0_req,
        outB_data => stage_select_x_fork_0_data,
        outB_ack  => stage_select_x_fork_0_ack,
        --Output Y 1
        outC_req  => stage_select_x_fork_1_req,
        outC_data => stage_select_x_fork_1_data,
        outC_ack  => stage_select_x_fork_1_ack
        );

    -- Stage demux
    stage_demux_y_select : entity work.demux(Behavioral)
        generic
        map(
        DATA_WIDTH   => NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_WIDTH,
        PHASE_INIT_A => NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_A,
        PHASE_INIT_B => NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_B,
        PHASE_INIT_C => NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_C
        )
        port
        map(
        rst => rst,
        -- Input port
        inA_req  => stage_compare_y_output_req,
        inA_data => stage_compare_y_output_data,
        inA_ack  => stage_compare_y_output_ack,
        -- Select port 
        inSel_req => stage_select_x_fork_1_req,
        inSel_ack => stage_select_x_fork_1_ack,
        selector  => stage_select_x_fork_1_data(0),
        -- Output channel 1
        outC_req  => stage_select_y_demux_0_req,
        outC_data => stage_select_y_demux_0_data,
        outC_ack  => stage_select_y_demux_0_ack,
        -- Output channel 2
        outB_req  => stage_select_y_demux_1_req,
        outB_data => stage_select_y_demux_1_data,
        outB_ack  => stage_select_y_demux_1_ack
        );
end architecture;