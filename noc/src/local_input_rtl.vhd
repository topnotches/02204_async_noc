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

    -- Output West
    out_req_west  : out std_logic;
    out_data_west : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_west  : in std_logic;

    -- Output North West
    out_req_north_west  : out std_logic;
    out_data_north_west : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_north_west  : in std_logic;

    -- Output North
    out_req_north  : out std_logic;
    out_data_north : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_north  : in std_logic;

    -- Output North East
    out_req_north_east  : out std_logic;
    out_data_north_east : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_north_east  : in std_logic;

    -- Output East
    out_req_east  : out std_logic;
    out_data_east : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_east  : in std_logic;

    -- Output South East
    out_req_south_east  : out std_logic;
    out_data_south_east : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_south_east  : in std_logic;

    -- Output South
    out_req_south  : out std_logic;
    out_data_south : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_south  : in std_logic;

    -- Output South West
    out_req_south_west  : out std_logic;
    out_data_south_west : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_south_west  : in std_logic;

  );
end entity diagonal_input_rtl;

architecture rtl of diagonal_input_rtl is

  -- Stage post-Click Signals
  signal stage_click_ack  : std_logic                                     := '0';
  signal stage_click_req  : std_logic                                     := '0';
  signal stage_click_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

  -- Stage click fork to package and control path
  signal stage_fork_package_req  : std_logic                                     := '0';
  signal stage_fork_package_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_fork_package_ack  : std_logic                                     := '0';

  signal stage_fork_control_req  : std_logic                                     := '0';
  signal stage_fork_control_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_fork_control_ack  : std_logic                                     := '0';

  -- Stage package demux to directions

  signal stage_package_demux_select_0_req  : std_logic                                     := '0';
  signal stage_package_demux_select_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_select_0_ack  : std_logic                                     := '0';

  signal stage_package_demux_south_req  : std_logic                                     := '0';
  signal stage_package_demux_south_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_south_ack  : std_logic                                     := '0';

  signal stage_package_demux_north_req  : std_logic                                     := '0';
  signal stage_package_demux_north_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_north_ack  : std_logic                                     := '0';

  signal stage_package_demux_select_1_req  : std_logic                                     := '0';
  signal stage_package_demux_select_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_select_1_ack  : std_logic                                     := '0';

  signal stage_package_demux_select_1_0_req  : std_logic                                     := '0';
  signal stage_package_demux_select_1_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_select_1_0_ack  : std_logic                                     := '0';

  signal stage_package_demux_east_req  : std_logic                                     := '0';
  signal stage_package_demux_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_east_ack  : std_logic                                     := '0';

  signal stage_package_demux_west_req  : std_logic                                     := '0';
  signal stage_package_demux_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_west_ack  : std_logic                                     := '0';

  signal stage_package_demux_select_1_1_req  : std_logic                                     := '0';
  signal stage_package_demux_select_1_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_select_1_1_ack  : std_logic                                     := '0';

  signal stage_package_demux_select_1_1_0_req  : std_logic                                     := '0';
  signal stage_package_demux_select_1_1_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_select_1_1_0_ack  : std_logic                                     := '0';

  signal stage_package_demux_south_east_req  : std_logic                                     := '0';
  signal stage_package_demux_south_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_south_east_ack  : std_logic                                     := '0';

  signal stage_package_demux_north_east_req  : std_logic                                     := '0';
  signal stage_package_demux_north_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_north_east_ack  : std_logic                                     := '0';

  signal stage_package_demux_select_1_1_1_req  : std_logic                                     := '0';
  signal stage_package_demux_select_1_1_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_select_1_1_1_ack  : std_logic                                     := '0';

  signal stage_package_demux_south_west_req  : std_logic                                     := '0';
  signal stage_package_demux_south_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_south_west_ack  : std_logic                                     := '0';

  signal stage_package_demux_north_west_req  : std_logic                                     := '0';
  signal stage_package_demux_north_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_package_demux_north_west_ack  : std_logic                                     := '0';
  -- Stage fork to s_delta and delta signals

  signal stage_fork_compare_x_req  : std_logic                                     := '0';
  signal stage_fork_compare_x_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_fork_compare_x_ack  : std_logic                                     := '0';

  signal stage_fork_compare_y_req  : std_logic                                     := '0';
  signal stage_fork_compare_y_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_fork_compare_y_ack  : std_logic                                     := '0';

  -- Stage compare output delta_x

  signal stage_raw_delta_x_req  : std_logic                                     := '0';
  signal stage_raw_delta_x_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_raw_delta_x_ack  : std_logic                                     := '0';

  -- Stage compare output s_delta_x

  signal stage_raw_s_delta_x_req  : std_logic                                     := '0';
  signal stage_raw_s_delta_x_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_raw_s_delta_x_ack  : std_logic                                     := '0';

  -- Stage compare output delta_y

  signal stage_raw_delta_y_req  : std_logic                                     := '0';
  signal stage_raw_delta_y_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_raw_delta_y_ack  : std_logic                                     := '0';

  -- Stage compare output s_delta_y

  signal stage_raw_s_delta_y_req  : std_logic                                     := '0';
  signal stage_raw_s_delta_y_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_raw_s_delta_y_ack  : std_logic                                     := '0';

  -- Stage s_delta_x to s_delta_x_kill, s_delta_x_0, s_delta_x_1

  signal stage_s_delta_x_kill_req  : std_logic                                     := '0';
  signal stage_s_delta_x_kill_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_x_kill_ack  : std_logic                                     := '0';

  signal stage_s_delta_x_demux_select_1_req  : std_logic                                     := '0';
  signal stage_s_delta_x_demux_select_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_x_demux_select_1_ack  : std_logic                                     := '0';

  signal stage_s_delta_x_0_demux_req  : std_logic                                     := '0';
  signal stage_s_delta_x_0_demux_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_x_0_demux_ack  : std_logic                                     := '0';

  signal stage_s_delta_x_1_req  : std_logic                                     := '0';
  signal stage_s_delta_x_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_x_1_ack  : std_logic                                     := '0';

  -- Stage s_delta_y to s_delta_y_kill, s_delta_y_0, s_delta_y_1, s_delta_y_2,

  signal stage_s_delta_y_0_demux_req  : std_logic                                     := '0';
  signal stage_s_delta_y_0_demux_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_y_0_demux_ack  : std_logic                                     := '0';

  signal stage_s_delta_y_demux_select_1_req  : std_logic                                     := '0';
  signal stage_s_delta_y_demux_select_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_y_demux_select_1_ack  : std_logic                                     := '0';

  signal stage_s_delta_y_kill_req  : std_logic                                     := '0';
  signal stage_s_delta_y_kill_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_y_kill_ack  : std_logic                                     := '0';

  signal stage_s_delta_y_demux_select_1_1_req  : std_logic                                     := '0';
  signal stage_s_delta_y_demux_select_1_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_y_demux_select_1_1_ack  : std_logic                                     := '0';

  signal stage_s_delta_y_1_demux_req  : std_logic                                     := '0';
  signal stage_s_delta_y_1_demux_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_y_1_demux_ack  : std_logic                                     := '0';

  signal stage_s_delta_y_2_demux_req  : std_logic                                     := '0';
  signal stage_s_delta_y_2_demux_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_y_2_demux_ack  : std_logic                                     := '0';
  -- Stage delta_y to delta_y_kill, delta_y_0

  signal stage_delta_y_kill_req  : std_logic                                     := '0';
  signal stage_delta_y_kill_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_y_kill_ack  : std_logic                                     := '0';

  signal stage_delta_y_0_req  : std_logic                                     := '0';
  signal stage_delta_y_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_y_0_ack  : std_logic                                     := '0';

  -- Stage delta_x_0 to delta_x_0_demux, delta_x_0_fork_0, delta_x_0_fork_1, delta_x_0_fork_2

  signal stage_delta_x_0_fork_intermediate_0_req  : std_logic                                     := '0';
  signal stage_delta_x_0_fork_intermediate_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_x_0_fork_intermediate_0_ack  : std_logic                                     := '0';

  signal stage_delta_x_0_fork_intermediate_1_req  : std_logic                                     := '0';
  signal stage_delta_x_0_fork_intermediate_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_x_0_fork_intermediate_1_ack  : std_logic                                     := '0';

  signal stage_delta_x_0_demux_req  : std_logic                                     := '0';
  signal stage_delta_x_0_demux_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_x_0_demux_ack  : std_logic                                     := '0';

  signal stage_delta_x_0_fork_0_req  : std_logic                                     := '0';
  signal stage_delta_x_0_fork_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_x_0_fork_0_ack  : std_logic                                     := '0';

  signal stage_delta_x_0_fork_1_req  : std_logic                                     := '0';
  signal stage_delta_x_0_fork_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_x_0_fork_1_ack  : std_logic                                     := '0';

  signal stage_delta_x_0_fork_2_req  : std_logic                                     := '0';
  signal stage_delta_x_0_fork_2_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_x_0_fork_2_ack  : std_logic                                     := '0';

  -- Stage delta_y_0 to delta_y_0_demux, delta_y_0_fork_0, delta_y_0_fork_1

  signal stage_delta_y_0_fork_intermediate_0_req  : std_logic                                     := '0';
  signal stage_delta_y_0_fork_intermediate_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_y_0_fork_intermediate_0_ack  : std_logic                                     := '0';

  signal stage_delta_y_0_demux_req  : std_logic                                     := '0';
  signal stage_delta_y_0_demux_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_y_0_demux_ack  : std_logic                                     := '0';

  signal stage_delta_y_0_fork_0_req  : std_logic                                     := '0';
  signal stage_delta_y_0_fork_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_y_0_fork_0_ack  : std_logic                                     := '0';

  signal stage_delta_y_0_fork_1_req  : std_logic                                     := '0';
  signal stage_delta_y_0_fork_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_delta_y_0_fork_1_ack  : std_logic                                     := '0';

  -- Stage delta_s_x_1 to delta_s_x_1_demux, delta_s_x_1_fork

  signal stage_s_delta_x_1_demux_req  : std_logic                                     := '0';
  signal stage_s_delta_x_1_demux_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_x_1_demux_ack  : std_logic                                     := '0';

  signal stage_s_delta_x_1_fork_0_req  : std_logic                                     := '0';
  signal stage_s_delta_x_1_fork_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal stage_s_delta_x_1_fork_0_ack  : std_logic                                     := '0';

begin
  stage_click : entity work.click_element(Behavioral)
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
  stage_input_fork : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_0_req,
    inA_data => stage_0_data,
    inA_ack  => stage_0_ack,
    -- Output Port 0
    outB_req  => stage_fork_package_req,
    outB_data => stage_fork_package_data,
    outB_ack  => stage_fork_package_ack,
    -- Output port 1 
    outC_req  => stage_fork_control_req,
    outC_data => stage_fork_control_data,
    outC_ack  => stage_fork_control_ack
    );

  --------------------
  --                --
  --  STAGE PACKAGE --
  --                --
  --------------------

  stage_package_demux_0 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_fork_package_req,
    inA_data => stage_fork_package_data,
    inA_ack  => stage_fork_package_ack,
    -- Select port 
    inSel_req => stage_delta_x_0_demux_req,
    inSel_ack => stage_delta_x_0_demux_ack,
    selector  => stage_delta_x_0_demux_data(0),
    -- Output channel 0
    outB_req  => stage_package_demux_select_0_req,
    outB_data => stage_package_demux_select_0_data,
    outB_ack  => stage_package_demux_select_0_ack,
    -- Output channel 1
    outC_req  => stage_package_demux_select_1_req,
    outC_data => stage_package_demux_select_1_data,
    outC_ack  => stage_package_demux_select_1_ack
    );
  stage_package_demux_1 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_package_demux_select_0_req,
    inA_data => stage_package_demux_select_0_data,
    inA_ack  => stage_package_demux_select_0_ack,
    -- Select port 
    inSel_req => stage_s_delta_y_0_demux_req,
    inSel_ack => stage_s_delta_y_0_demux_ack,
    selector  => stage_s_delta_y_0_demux_data(0),
    -- Output channel 0
    outB_req  => stage_package_demux_south_req,
    outB_data => stage_package_demux_south_data,
    outB_ack  => stage_package_demux_south_ack,
    -- Output channel 1
    outC_req  => stage_package_demux_north_req,
    outC_data => stage_package_demux_north_data,
    outC_ack  => stage_package_demux_north_ack
    );
  stage_package_demux_2 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_package_demux_select_1_req,
    inA_data => stage_package_demux_select_1_data,
    inA_ack  => stage_package_demux_select_1_ack,
    -- Select port 
    inSel_req => stage_delta_y_0_demux_req,
    inSel_ack => stage_delta_y_0_demux_ack,
    selector  => stage_delta_y_0_demux_data(0),
    -- Output channel 0
    outB_req  => stage_package_demux_select_1_0_req,
    outB_data => stage_package_demux_select_1_0_data,
    outB_ack  => stage_package_demux_select_1_0_ack,
    -- Output channel 1
    outC_req  => stage_package_demux_select_1_1_req,
    outC_data => stage_package_demux_select_1_1_data,
    outC_ack  => stage_package_demux_select_1_1_ack
    );
  stage_package_demux_3 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_package_demux_select_1_0_req,
    inA_data => stage_package_demux_select_1_0_data,
    inA_ack  => stage_package_demux_select_1_0_ack,
    -- Select port 
    inSel_req => stage_s_delta_x_0_demux_req,
    inSel_ack => stage_s_delta_x_0_demux_ack,
    selector  => stage_s_delta_x_0_demux_data(0),
    -- Output channel 0
    outB_req  => stage_package_demux_east_req,
    outB_data => stage_package_demux_east_data,
    outB_ack  => stage_package_demux_east_ack,
    -- Output channel 1
    outC_req  => stage_package_demux_west_req,
    outC_data => stage_package_demux_west_data,
    outC_ack  => stage_package_demux_west_ack
    );
  stage_package_demux_4 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_package_demux_select_1_1_req,
    inA_data => stage_package_demux_select_1_1_data,
    inA_ack  => stage_package_demux_select_1_1_ack,
    -- Select port 
    inSel_req => stage_s_delta_x_1_demux_req,
    inSel_ack => stage_s_delta_x_1_demux_ack,
    selector  => stage_s_delta_x_1_demux_data(0),
    -- Output channel 0
    outB_req  => stage_package_demux_select_1_1_0_req,
    outB_data => stage_package_demux_select_1_1_0_data,
    outB_ack  => stage_package_demux_select_1_1_0_ack,
    -- Output channel 1
    outC_req  => stage_package_demux_select_1_1_1_req,
    outC_data => stage_package_demux_select_1_1_1_data,
    outC_ack  => stage_package_demux_select_1_1_1_ack
    );
  stage_package_demux_5 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_package_demux_select_1_1_0_req,
    inA_data => stage_package_demux_select_1_1_0_data,
    inA_ack  => stage_package_demux_select_1_1_0_ack,
    -- Select port 
    inSel_req => stage_s_delta_y_1_demux_req,
    inSel_ack => stage_s_delta_y_1_demux_ack,
    selector  => stage_s_delta_y_1_demux_data(0),
    -- Output channel 0
    outB_req  => stage_package_demux_south_east_req,
    outB_data => stage_package_demux_south_east_data,
    outB_ack  => stage_package_demux_south_east_ack,
    -- Output channel 1
    outC_req  => stage_package_demux_north_east_req,
    outC_data => stage_package_demux_north_east_data,
    outC_ack  => stage_package_demux_north_east_ack
    );
  stage_package_demux_6 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_package_demux_select_1_1_1_req,
    inA_data => stage_package_demux_select_1_1_1_data,
    inA_ack  => stage_package_demux_select_1_1_1_ack,
    -- Select port 
    inSel_req => stage_s_delta_y_2_demux_req,
    inSel_ack => stage_s_delta_y_2_demux_ack,
    selector  => stage_s_delta_y_2_demux_data(0),
    -- Output channel 0
    outB_req  => stage_package_demux_south_west_req,
    outB_data => stage_package_demux_south_west_data,
    outB_ack  => stage_package_demux_south_west_ack,
    -- Output channel 1
    outC_req  => stage_package_demux_north_west_req,
    outC_data => stage_package_demux_north_west_data,
    outC_ack  => stage_package_demux_north_west_ack
    );
  ------------------------------
  --                          --
  --  STAGE FORK TO COMPARE   --
  --                          --
  ------------------------------
  stage_compare_fork_0 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_fork_control_req,
    inA_data => stage_fork_control_data,
    inA_ack  => stage_fork_control_ack,
    -- Output Port 0
    outB_req  => stage_fork_compare_x_req,
    outB_data => stage_fork_compare_x_data,
    outB_ack  => stage_fork_compare_x_ack,
    -- Output port 1 
    outC_req  => stage_fork_compare_y_req,
    outC_data => stage_fork_compare_y_data,
    outC_ack  => stage_fork_compare_y_ack
    );

  stage_compare_fork_1 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_fork_compare_x_req,
    inA_data => stage_fork_compare_x_data,
    inA_ack  => stage_fork_compare_x_ack,
    -- Output Port 0
    outB_req  => stage_fork_delta_x_req,
    outB_data => stage_fork_delta_x_data,
    outB_ack  => stage_fork_delta_x_ack,
    -- Output port 1 
    outC_req  => stage_fork_s_delta_x_req,
    outC_data => stage_fork_s_delta_x_data,
    outC_ack  => stage_fork_s_delta_x_ack
    );

  stage_compare_fork_2 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_fork_compare_y_req,
    inA_data => stage_fork_compare_y_data,
    inA_ack  => stage_fork_compare_y_ack,
    -- Output Port 0
    outB_req  => stage_fork_delta_y_req,
    outB_data => stage_fork_delta_y_data,
    outB_ack  => stage_fork_delta_y_ack,
    -- Output port 1 
    outC_req  => stage_fork_s_delta_y_req,
    outC_data => stage_fork_s_delta_y_data,
    outC_ack  => stage_fork_s_delta_y_ack
    );

  ------------------------------
  --                          --
  --  STAGE GENERATE COMPARE  --
  --                          --
  ------------------------------

  stage_compare_address_diff_x : entity work.compare_address_diff_rtl(rtl)
    port
    map
    (
    in_local_address => in_local_address_x,
    in_ack           => stage_fork_delta_x_req,
    in_req           => stage_fork_delta_x_data,
    in_data          => stage_fork_delta_x_ack,
    out_req          => stage_raw_delta_x_req,
    out_data         => stage_raw_delta_x_data(0),
    out_ack          => stage_raw_delta_x_ack
    );

  stage_compare_address_diff_y : entity work.compare_address_diff_rtl(rtl)
    generic
    map (
    COMPARE_DELAY => 2
    )
    port
    map
    (
    in_local_address => in_local_address_y,
    in_ack           => stage_fork_delta_y_req,
    in_req           => stage_fork_delta_y_data,
    in_data          => stage_fork_delta_y_ack,
    out_req          => stage_raw_delta_y_req,
    out_data         => stage_raw_delta_y_data(0),
    out_ack          => stage_raw_delta_y_ack
    );

  stage_compare_address_sign_diff_x : entity work.compare_address_sign_diff_rtl(rtl)
    port
    map
    (
    in_local_address => in_local_address_x,
    in_ack           => stage_fork_s_delta_x_req,
    in_req           => stage_fork_s_delta_x_data,
    in_data          => stage_fork_s_delta_x_ack,
    out_req          => stage_raw_s_delta_x_req,
    out_data         => stage_raw_s_delta_x_data(0),
    out_ack          => stage_raw_s_delta_x_ack
    );

  stage_compare_address_sign_diff_y : entity work.compare_address_sign_diff_rtl(rtl)
    generic
    map (
    COMPARE_DELAY => 2
    )
    port
    map
    (
    in_local_address => in_local_address_y,
    in_ack           => stage_fork_s_delta_y_req,
    in_req           => stage_fork_s_delta_y_data,
    in_data          => stage_fork_s_delta_y_ack,
    out_req          => stage_raw_s_delta_y_req,
    out_data         => stage_raw_s_delta_y_data(0),
    out_ack          => stage_raw_s_delta_y_ack
    );

  ----------------------------
  --                        --
  --  STAGE RAW S_DELTA_X   --
  --                        --
  ----------------------------
  stage_s_delta_x_demux_0 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_raw_s_delta_x_req,
    inA_data => stage_raw_s_delta_x_data,
    inA_ack  => stage_raw_s_delta_x_ack,
    -- Select port 
    inSel_req => stage_delta_x_0_fork_0_req,
    inSel_ack => stage_delta_x_0_fork_0_ack,
    selector  => stage_delta_x_0_fork_0_data(0),
    -- Output channel 0
    outB_req  => stage_s_delta_x_kill_req,
    outB_data => stage_s_delta_x_kill_data,
    outB_ack  => stage_s_delta_x_kill_ack,
    -- Output channel 1
    outC_req  => stage_s_delta_x_demux_select_1_req,
    outC_data => stage_s_delta_x_demux_select_1_data,
    outC_ack  => stage_s_delta_x_demux_select_1_ack
    );

  stage_s_delta_x_demux_1 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_s_delta_y_demux_select_1_req,
    inA_data => stage_s_delta_y_demux_select_1_data,
    inA_ack  => stage_s_delta_y_demux_select_1_ack,
    -- Select port 
    inSel_req => stage_delta_y_0_fork_0_req,
    inSel_ack => stage_delta_y_0_fork_0_ack,
    selector  => stage_delta_y_0_fork_0_data(0),
    -- Output channel 0
    outB_req  => stage_s_delta_x_0_demux_req,
    outB_data => stage_s_delta_x_0_demux_data,
    outB_ack  => stage_s_delta_x_0_demux_ack,
    -- Output channel 1
    outC_req  => stage_s_delta_x_1_req,
    outC_data => stage_s_delta_x_1_data,
    outC_ack  => stage_s_delta_x_1_ack
    );

  ----------------------------
  --                        --
  --  STAGE RAW S_DELTA_Y   --
  --                        --
  ----------------------------

  stage_s_delta_y_demux_0 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_raw_s_delta_y_req,
    inA_data => stage_raw_s_delta_y_data,
    inA_ack  => stage_raw_s_delta_y_ack,
    -- Select port 
    inSel_req => stage_delta_x_0_fork_1_req,
    inSel_ack => stage_delta_x_0_fork_1_ack,
    selector  => stage_delta_x_0_fork_1_data(0),
    -- Output channel 0
    outB_req  => stage_s_delta_y_0_demux_req,
    outB_data => stage_s_delta_y_0_demux_data,
    outB_ack  => stage_s_delta_y_0_demux_ack,
    -- Output channel 1
    outC_req  => stage_s_delta_y_demux_select_1_req,
    outC_data => stage_s_delta_y_demux_select_1_data,
    outC_ack  => stage_s_delta_y_demux_select_1_ack
    );

  stage_s_delta_y_demux_1 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_s_delta_y_demux_select_1_req,
    inA_data => stage_s_delta_y_demux_select_1_data,
    inA_ack  => stage_s_delta_y_demux_select_1_ack,
    -- Select port 
    inSel_req => stage_delta_y_0_fork_1_req,
    inSel_ack => stage_delta_y_0_fork_1_ack,
    selector  => stage_delta_y_0_fork_1_data(0),
    -- Output channel 0
    outB_req  => stage_s_delta_y_kill_req,
    outB_data => stage_s_delta_y_kill_data,
    outB_ack  => stage_s_delta_y_kill_ack,
    -- Output channel 1
    outC_req  => stage_s_delta_y_demux_select_1_1_req,
    outC_data => stage_s_delta_y_demux_select_1_1_data,
    outC_ack  => stage_s_delta_y_demux_select_1_1_ack
    );

  stage_s_delta_y_demux_2 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_s_delta_y_demux_select_1_1_req,
    inA_data => stage_s_delta_y_demux_select_1_1_data,
    inA_ack  => stage_s_delta_y_demux_select_1_1_ack,
    -- Select port 
    inSel_req => stage_s_delta_x_1_fork_0_req,
    inSel_ack => stage_s_delta_x_1_fork_0_ack,
    selector  => stage_s_delta_x_1_fork_0_data(0),
    -- Output channel 0
    outB_req  => stage_s_delta_y_1_demux_req,
    outB_data => stage_s_delta_y_1_demux_data,
    outB_ack  => stage_s_delta_y_1_demux_ack,
    -- Output channel 1
    outC_req  => stage_s_delta_y_2_demux_req,
    outC_data => stage_s_delta_y_2_demux_data,
    outC_ack  => stage_s_delta_y_2_demux_ack
    );

  --------------------------
  --                      --
  --  STAGE RAW DELTA_X   --
  --                      --
  --------------------------
  --------------------------
  --                      --
  --  STAGE RAW DELTA_Y   --
  --                      --
  --------------------------

  stage_delta_y_demux_0 : entity work.demux(Behavioral)
    generic
    map(
    DEMUX_DATA_WIDTH => NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH,
    PHASE_INIT_A     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
    PHASE_INIT_B     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
    PHASE_INIT_C     => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port
    map(
    rst => rst,
    -- Input port
    inA_req  => stage_raw_delta_y_req,
    inA_data => stage_raw_delta_y_data,
    inA_ack  => stage_raw_delta_y_ack,
    -- Select port 
    inSel_req => stage_delta_x_0_fork_2_req,
    inSel_ack => stage_delta_x_0_fork_2_ack,
    selector  => stage_delta_x_0_fork_2_data(0),
    -- Output channel 0
    outB_req  => stage_delta_y_kill_req,
    outB_data => stage_delta_y_kill_data,
    outB_ack  => stage_delta_y_kill_ack,
    -- Output channel 1
    outC_req  => stage_delta_y_0_req,
    outC_data => stage_delta_y_0_data,
    outC_ack  => stage_delta_y_0_ack
    );

  ----------------------------
  --                        --
  --  STAGE FORK S_DELTA_X  --
  --                        --
  ----------------------------
  stage_fork_s_delta_x_1 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_s_delta_x_1_req,
    inA_data => stage_s_delta_x_1_data,
    inA_ack  => stage_s_delta_x_1_ack,
    -- Output Port 0
    outB_req  => stage_s_delta_x_1_demux_req,
    outB_data => stage_s_delta_x_1_demux_data,
    outB_ack  => stage_s_delta_x_1_demux_ack,
    -- Output port 1 
    outC_req  => stage_s_delta_x_1_fork_0_req,
    outC_data => stage_s_delta_x_1_fork_0_data,
    outC_ack  => stage_s_delta_x_1_fork_0_ack
    );
  ----------------------------
  --                        --
  --  STAGE FORK S_DELTA_Y  --
  --                        --
  ----------------------------

  --------------------------
  --                      --
  --  STAGE FORK DELTA_X  --
  --                      --
  --------------------------
  stage_fork_delta_x_0 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_raw_delta_x_req,
    inA_data => stage_raw_delta_x_data,
    inA_ack  => stage_raw_delta_x_ack,
    -- Output Port 0
    outB_req  => stage_delta_x_0_fork_intermediate_0_req,
    outB_data => stage_delta_x_0_fork_intermediate_0_data,
    outB_ack  => stage_delta_x_0_fork_intermediate_0_ack,
    -- Output port 1 
    outC_req  => stage_delta_x_0_fork_intermediate_1_req,
    outC_data => stage_delta_x_0_fork_intermediate_1_data,
    outC_ack  => stage_delta_x_0_fork_intermediate_1_ack
    );

  stage_fork_delta_x_1 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_delta_x_0_fork_intermediate_0_req,
    inA_data => stage_delta_x_0_fork_intermediate_0_data,
    inA_ack  => stage_delta_x_0_fork_intermediate_0_ack,
    -- Output Port 0
    outB_req  => stage_delta_x_0_demux_req,
    outB_data => stage_delta_x_0_demux_data,
    outB_ack  => stage_delta_x_0_demux_ack,
    -- Output port 1 
    outC_req  => stage_delta_x_0_fork_0_req,
    outC_data => stage_delta_x_0_fork_0_data,
    outC_ack  => stage_delta_x_0_fork_0_ack
    );

  stage_fork_delta_x_2 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_delta_x_0_fork_intermediate_1_req,
    inA_data => stage_delta_x_0_fork_intermediate_1_data,
    inA_ack  => stage_delta_x_0_fork_intermediate_1_ack,
    -- Output Port 0
    outB_req  => stage_delta_x_0_fork_1_req,
    outB_data => stage_delta_x_0_fork_1_data,
    outB_ack  => stage_delta_x_0_fork_1_ack,
    -- Output port 1 
    outC_req  => stage_delta_x_0_fork_2_req,
    outC_data => stage_delta_x_0_fork_2_data,
    outC_ack  => stage_delta_x_0_fork_2_ack
    );

  --------------------------
  --                      --
  --  STAGE FORK DELTA_Y  --
  --                      --
  --------------------------
  stage_fork_delta__0 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_delta_y_0_req,
    inA_data => stage_delta_y_0_data,
    inA_ack  => stage_delta_y_0_ack,
    -- Output Port 0
    outB_req  => stage_delta_y_0_demux_req,
    outB_data => stage_delta_y_0_demux_data,
    outB_ack  => stage_delta_y_0_demux_ack,
    -- Output port 1 
    outC_req  => stage_delta_y_0_fork_intermediate_0_req,
    outC_data => stage_delta_y_0_fork_intermediate_0_data,
    outC_ack  => stage_delta_y_0_fork_intermediate_0_ack
    );

  stage_fork_delta__1 : entity work.reg_fork(Behavioral)
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
    -- Input channel
    inA_req  => stage_delta_y_0_fork_intermediate_0_req,
    inA_data => stage_delta_y_0_fork_intermediate_0_data,
    inA_ack  => stage_delta_y_0_fork_intermediate_0_ack,
    -- Output Port 0
    outB_req  => stage_delta_y_0_fork_0_req,
    outB_data => stage_delta_y_0_fork_0_data,
    outB_ack  => stage_delta_y_0_fork_0_ack,
    -- Output port 1 
    outC_req  => stage_delta_y_0_fork_1_req,
    outC_data => stage_delta_y_0_fork_1_data,
    outC_ack  => stage_delta_y_0_fork_1_ack
    );
end architecture;