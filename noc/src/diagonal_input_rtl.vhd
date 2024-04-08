LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.data_if_pkg.ALL;
USE work.noc_defs_pkg.ALL;

ENTITY diagonal_input_rtl IS
    PORT (
        rst : IN STD_LOGIC;

        -- Local Address
        in_local_address_x : IN STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
        in_local_address_y : IN STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');

        -- Input channel
        in_ack : OUT STD_LOGIC;
        in_req : IN STD_LOGIC;
        in_data : IN STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

        -- Output Continue
        out_req_continue : OUT STD_LOGIC;
        out_data_continue : OUT STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
        out_ack_continue : IN STD_LOGIC;

        -- Output West/East
        out_req_we : OUT STD_LOGIC;
        out_data_we : OUT STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
        out_ack_we : IN STD_LOGIC;

        -- Output North/South
        out_req_ns : OUT STD_LOGIC;
        out_data_ns : OUT STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
        out_ack_ns : IN STD_LOGIC;

        -- Output Local
        out_req_local : OUT STD_LOGIC;
        out_data_local : OUT STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
        out_ack_local : IN STD_LOGIC
    );
END ENTITY diagonal_input_rtl;

ARCHITECTURE rtl OF diagonal_input_rtl IS

    -- Stage 0 Signals
    SIGNAL stage_0_ack : STD_LOGIC;
    SIGNAL stage_0_req : STD_LOGIC;
    SIGNAL stage_0_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    -- Stage 1 Signals (fork)

    -- Port Path
    SIGNAL stage_1_port_ack : STD_LOGIC;
    SIGNAL stage_1_port_req : STD_LOGIC;
    SIGNAL stage_1_port_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);
    -- Compare Path
    SIGNAL stage_1_compare_ack : STD_LOGIC;
    SIGNAL stage_1_compare_req : STD_LOGIC;
    SIGNAL stage_1_compare_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    -- Stage DEMUX
    -- DEMUX 0
    SIGNAL stage_demux_0_sel_0_ack : STD_LOGIC;
    SIGNAL stage_demux_0_sel_0_req : STD_LOGIC;
    SIGNAL stage_demux_0_sel_0_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    SIGNAL stage_demux_0_sel_1_ack : STD_LOGIC;
    SIGNAL stage_demux_0_sel_1_req : STD_LOGIC;
    SIGNAL stage_demux_0_sel_1_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    -- DEMUX 1
    SIGNAL stage_demux_1_sel_0_ack : STD_LOGIC;
    SIGNAL stage_demux_1_sel_0_req : STD_LOGIC;
    SIGNAL stage_demux_1_sel_0_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    SIGNAL stage_demux_1_sel_1_ack : STD_LOGIC;
    SIGNAL stage_demux_1_sel_1_req : STD_LOGIC;
    SIGNAL stage_demux_1_sel_1_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    -- DEMUX 2
    SIGNAL stage_demux_2_sel_0_ack : STD_LOGIC;
    SIGNAL stage_demux_2_sel_0_req : STD_LOGIC;
    SIGNAL stage_demux_2_sel_0_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    SIGNAL stage_demux_2_sel_1_ack : STD_LOGIC;
    SIGNAL stage_demux_2_sel_1_req : STD_LOGIC;
    SIGNAL stage_demux_2_sel_1_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    -- Stage Compare

    -- Fork
    SIGNAL stage_compare_x_ack : STD_LOGIC;
    SIGNAL stage_compare_x_req : STD_LOGIC;
    SIGNAL stage_compare_x_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    SIGNAL stage_compare_y_ack : STD_LOGIC;
    SIGNAL stage_compare_y_req : STD_LOGIC;
    SIGNAL stage_compare_y_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    -- Compare X
    -- INPUT
    SIGNAL stage_compare_x_input_ack : STD_LOGIC;
    SIGNAL stage_compare_x_input_req : STD_LOGIC;
    SIGNAL stage_compare_x_input_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    -- OUTPUT
    SIGNAL stage_compare_x_output_ack : STD_LOGIC;
    SIGNAL stage_compare_x_output_req : STD_LOGIC;
    SIGNAL stage_compare_x_output_data : STD_LOGIC;

    -- Compare Y
    -- INPUT
    SIGNAL stage_compare_y_input_ack : STD_LOGIC;
    SIGNAL stage_compare_y_input_req : STD_LOGIC;
    SIGNAL stage_compare_y_input_data : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 DOWNTO 0);

    -- OUTPUT
    SIGNAL stage_compare_y_output_ack : STD_LOGIC;
    SIGNAL stage_compare_y_output_req : STD_LOGIC;
    SIGNAL stage_compare_y_output_data : STD_LOGIC;
BEGIN

    stage_0_click : ENTITY work.click_element(Behavioral)
        GENERIC MAP(
            DATA_WIDTH => NOC_DIAGONAL_STAGE_0_CLICK_WIDTH,
            VALUE => NOC_DIAGONAL_STAGE_0_CLICK_VALUE,
            PHASE_INIT => NOC_DIAGONAL_STAGE_0_CLICK_PHASE -- Set PHASE_INIT to '0' as per your requirements
        )
        PORT MAP
        (
            rst => rst, -- Connect rst port to your reset signal
            in_ack => in_ack, -- Connect in_ack port to your signal for in_ack
            in_req => in_req, -- Connect in_req port to your signal for in_req
            in_data => in_data, -- Connect in_data port to your signal for in_data
            out_req => stage_0_req, -- Connect out_req port to your signal for out_req
            out_data => stage_0_data, -- Connect out_data port to your signal for out_data
            out_ack => stage_0_ack -- Connect out_ack port to your signal for out_ack
        );

    stage_1_fork : ENTITY work.reg_fork(Behavioral)
        GENERIC MAP(
            DATA_WIDTH => NOC_DIAGONAL_STAGE_0_FORK_WIDTH,
            VALUE => NOC_DIAGONAL_STAGE_0_FORK_VALUE,
            PHASE_INIT_A => NOC_DIAGONAL_STAGE_0_FORK_PHASE_A,
            PHASE_INIT_B => NOC_DIAGONAL_STAGE_0_FORK_PHASE_B,
            PHASE_INIT_C => NOC_DIAGONAL_STAGE_0_FORK_PHASE_C
        )
        PORT MAP(
            rst => rst,
            --Input channel
            inA_req => stage_0_req,
            inA_data => stage_0_data,
            inA_ack => stage_0_ack,
            --Output Port Path
            outB_req => stage_1_port_req,
            outB_data => stage_1_port_data,
            outB_ack => stage_1_port_ack,
            --Output Compare Path 
            outC_req => stage_1_compare_req,
            outC_data => stage_1_compare_data,
            outC_ack => stage_1_compare_ack
        );

    -- Stage demux
    stage_demux_0 : ENTITY work.demux(Behavioral)
        GENERIC MAP(
            DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
            PHASE_INIT_A => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
            PHASE_INIT_B => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
            PHASE_INIT_C => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
        )
        PORT MAP(
            rst => rst,
            -- Input port
            inA_req => stage_1_compare_req,
            inA_data => stage_1_compare_data,
            inA_ack => stage_1_compare_ack,
            -- Select port 
            inSel_req => stage_compare_x_output_req,
            inSel_ack => stage_compare_x_output_ack,
            selector => stage_compare_x_output_data,
            -- Output channel 1
            outB_req => stage_demux_0_sel_0_req,
            outB_data => stage_demux_0_sel_0_data,
            outB_ack => stage_demux_0_sel_0_ack,
            -- Output channel 2
            outC_req => stage_demux_0_sel_1_req,
            outC_data => stage_demux_0_sel_1_data,
            outC_ack => stage_demux_0_sel_1_ack
        );
    stage_demux_1 : ENTITY work.demux(Behavioral)
        GENERIC MAP(
            DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_1_WIDTH,
            PHASE_INIT_A => NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_A,
            PHASE_INIT_B => NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_B,
            PHASE_INIT_C => NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_C
        )
        PORT MAP(
            rst => rst,
            -- Input port
            inA_req => stage_demux_0_sel_0_req,
            inA_data => stage_demux_0_sel_0_data,
            inA_ack => stage_demux_0_sel_0_ack,
            -- Select port 
            inSel_req => stage_compare_y_output_req,
            inSel_ack => stage_compare_y_output_ack,
            selector => stage_compare_y_output_data,
            -- Output channel 1
            outB_req => stage_demux_1_sel_0_req,
            outB_data => stage_demux_1_sel_0_data,
            outB_ack => stage_demux_1_sel_0_ack,
            -- Output channel 2
            outC_req => stage_demux_1_sel_1_req,
            outC_data => stage_demux_1_sel_1_data,
            outC_ack => stage_demux_1_sel_1_ack
        );
    stage_demux_2 : ENTITY work.demux(Behavioral)
        GENERIC MAP(
            DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_2_WIDTH,
            PHASE_INIT_A => NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_A,
            PHASE_INIT_B => NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_B,
            PHASE_INIT_C => NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_C
        )
        PORT MAP(
            rst => rst,
            -- Input port
            inA_req => stage_demux_0_sel_1_req,
            inA_data => stage_demux_0_sel_1_data,
            inA_ack => stage_demux_0_sel_1_ack,
            -- Select port 
            inSel_req => stage_compare_y_output_req,
            inSel_ack => stage_compare_y_output_ack,
            selector => stage_compare_y_output_data,
            -- Output channel 1
            outB_req => stage_demux_2_sel_0_req,
            outB_data => stage_demux_2_sel_0_data,
            outB_ack => stage_demux_2_sel_0_ack,
            -- Output channel 2
            outC_req => stage_demux_2_sel_1_req,
            outC_data => stage_demux_2_sel_1_data,
            outC_ack => stage_demux_2_sel_1_ack
        );

    -- compare addresses
    stage_compare_fork : ENTITY work.reg_fork(Behavioral)
        GENERIC MAP(
            DATA_WIDTH => NOC_DIAGONAL_STAGE_COMPARE_FORK_WIDTH,
            VALUE => NOC_DIAGONAL_STAGE_COMPARE_FORK_VALUE,
            PHASE_INIT_A => NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_A,
            PHASE_INIT_B => NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_B,
            PHASE_INIT_C => NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_C
        )
        PORT MAP(
            rst => rst,
            --Input channel
            inA_req => stage_1_compare_req,
            inA_data => stage_1_compare_data,
            inA_ack => stage_1_compare_ack,
            --Output X Path
            outB_req => stage_compare_x_input_req,
            outB_data => stage_compare_x_input_data,
            outB_ack => stage_compare_x_input_ack,
            --Output Y Path 
            outC_req => stage_compare_y_input_req,
            outC_data => stage_compare_y_input_data,
            outC_ack => stage_compare_y_input_ack
        );

    -- generate compare selectors
    stage_compare_x : ENTITY work.compare_address_diff_rtl(rtl)
        PORT MAP
        (
            in_local_address => in_local_address_x,
            in_ack => stage_compare_x_input_ack,
            in_req => stage_compare_x_input_req,
            in_data => slv_to_data_if(stage_compare_x_input_data).x,
            out_req => stage_compare_x_output_req,
            out_data => stage_compare_x_output_data,
            out_ack => stage_compare_x_output_ack
        );

    stage_compare_y : ENTITY work.compare_address_diff_rtl(rtl)
        PORT MAP
        (
            in_local_address => in_local_address_y,
            in_ack => stage_compare_y_input_ack,
            in_req => stage_compare_y_input_req,
            in_data => slv_to_data_if(stage_compare_y_input_data).y,
            out_req => stage_compare_y_output_req,
            out_data => stage_compare_y_output_data,
            out_ack => stage_compare_y_output_ack
        );

END ARCHITECTURE;