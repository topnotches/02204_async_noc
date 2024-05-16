library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;

entity straight_input_rtl is
  generic(
    north_south: integer := 0
  );
  port
  (
    rst : in std_logic;

    -- Local Address
    in_local_address_xy : in std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');

    -- Input channel
    in_ack  : out std_logic;
    in_req  : in std_logic;
    in_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Output Continue
    out_ack_continue  : in std_logic;
    out_req_continue  : out std_logic;
    out_data_continue : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Output Local
    out_ack_local  : in std_logic;
    out_req_local  : out std_logic;
    out_data_local : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0)
  );
end entity straight_input_rtl;

architecture rtl of straight_input_rtl is
  
  -- Stage 0 Signals
  signal stage_0_ack  : std_logic                                               := '0';
  signal stage_0_req  : std_logic                                               := '0';
  signal stage_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0)           := (others => '0');

  -- Stage 1 Signals (fork)
  -- Port Path
  signal stage_1_port_ack  : std_logic                                          := '0';
  signal stage_1_port_req  : std_logic                                          := '0';
  signal stage_1_port_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0)      := (others => '0');
  -- Compare Path
  signal stage_1_compare_ack  : std_logic                                       := '0';
  signal stage_1_compare_req  : std_logic                                       := '0';
  signal stage_1_compare_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0)   := (others => '0');

  -- Stage DEMUX
  signal stage_demux_sel_0_ack  : std_logic                                     := '0';
  signal stage_demux_sel_0_req  : std_logic                                     := '0';
  signal stage_demux_sel_0_data : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

  signal stage_demux_sel_1_ack  : std_logic                                     := '0';
  signal stage_demux_sel_1_req  : std_logic                                     := '0';
  signal stage_demux_sel_1_data : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

  -- Compare X/Y 
  -- OUTPUT
  signal stage_compare_output_ack  : std_logic                                                  := '0';
  signal stage_compare_output_req  : std_logic                                                  := '0';
  signal stage_compare_output_data : std_logic                                                  := '0';
begin

  stage_demux_sel_0_ack     <= out_ack_continue; 
  out_req_continue          <= stage_demux_sel_0_req;
  out_data_continue         <= stage_demux_sel_0_data;

  stage_demux_sel_1_ack     <= out_ack_local;
  out_req_local             <= stage_demux_sel_1_req;
  out_data_local            <= stage_demux_sel_1_data;

  stage_0_click : entity work.click_element(Behavioral)
    generic 
    map(
      DATA_WIDTH => NOC_DATA_WIDTH,
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
    generic map(
      DATA_WIDTH   => NOC_DATA_WIDTH,
      VALUE        => NOC_DIAGONAL_STAGE_0_FORK_VALUE,
      PHASE_INIT_A => NOC_DIAGONAL_STAGE_0_FORK_PHASE_A,
      PHASE_INIT_B => NOC_DIAGONAL_STAGE_0_FORK_PHASE_B,
      PHASE_INIT_C => NOC_DIAGONAL_STAGE_0_FORK_PHASE_C
    )
    port map(
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
  
  -- NORTH-SOUTH Direction straight input --> We have to check the Y
  north_south_straight_input: 
  if north_south = 1 generate
  stage_compare_x_y : entity work.compare_address_diff_rtl(rtl)
  port
  map
  (
    in_local_address => in_local_address_xy,
    in_ack           => stage_1_compare_ack,
    in_req           => stage_1_compare_req,
    in_data          => slv_to_data_if(stage_1_compare_data).y,
    out_req          => stage_compare_output_req,
    out_data         => stage_compare_output_data,
    out_ack          => stage_compare_output_ack
  );
  end generate north_south_straight_input;

  -- EAST-WEST Direction straight input --> We have to check the X
  east_west_straight_input: 
  if north_south = 0 generate
  stage_compare_x_y : entity work.compare_address_diff_rtl(rtl)
  port
  map
  (
    in_local_address => in_local_address_xy,
    in_ack           => stage_1_compare_ack,
    in_req           => stage_1_compare_req,
    in_data          => slv_to_data_if(stage_1_compare_data).x,
    out_req          => stage_compare_output_req,
    out_data         => stage_compare_output_data,
    out_ack          => stage_compare_output_ack
  );
  end generate east_west_straight_input;

  stage_demux : entity work.demux(Behavioral)
  generic map(
      DATA_WIDTH        => NOC_DATA_WIDTH,
      PHASE_INIT_A      => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A,
      PHASE_INIT_B      => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B,
      PHASE_INIT_C      => NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C
    )
    port map (
      rst => rst,
      -- Input port
      inA_req  => stage_1_port_req,
      inA_data => stage_1_port_data,
      inA_ack  => stage_1_port_ack,
      -- Select port 
      inSel_req => stage_compare_output_req,
      inSel_ack => stage_compare_output_ack,
      selector  => stage_compare_output_data,
      -- Output channel 1
      outB_req  => stage_demux_sel_0_req,
      outB_data => stage_demux_sel_0_data,
      outB_ack  => stage_demux_sel_0_ack,
      -- Output channel 2
      outC_req  => stage_demux_sel_1_req,
      outC_data => stage_demux_sel_1_data,
      outC_ack  => stage_demux_sel_1_ack
    );
end architecture rtl;