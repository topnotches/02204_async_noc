library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;
use work.buffer_rtl;

entity local_output_rtl is
  generic(buffer_length : integer := 1);
  port (
    rst : in std_logic;

    --Output channel
    out_req : out std_logic;
    out_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack : in std_logic;

    -- Input channel
    out_north_to_local_ack        : out std_logic;
    out_north_to_local_req        : in std_logic;
    out_north_to_local_data       : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_to_local_ack        : out std_logic;
    out_south_to_local_req        : in std_logic;
    out_south_to_local_data       : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_east_to_local_ack         : out std_logic;
    out_east_to_local_req         : in std_logic;
    out_east_to_local_data        : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_west_to_local_ack         : out std_logic;
    out_west_to_local_req         : in std_logic;
    out_west_to_local_data        : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_east_to_local_ack   : out std_logic;
    out_south_east_to_local_req   : in std_logic;
    out_south_east_to_local_data  : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_west_to_local_ack   : out std_logic;
    out_south_west_to_local_req   : in std_logic;
    out_south_west_to_local_data  : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_north_east_to_local_ack   : out std_logic;
    out_north_east_to_local_req   : in std_logic;
    out_north_east_to_local_data  : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_north_west_to_local_ack   : out std_logic;
    out_north_west_to_local_req   : in std_logic;
    out_north_west_to_local_data  : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0)    
    ) ;
end entity;

architecture rtl of local_output_rtl is
      -- Stage 0 Signals
    signal stage_0_arbiter_0_ack  : std_logic;
    signal stage_0_arbiter_0_req  : std_logic;
    signal stage_0_arbiter_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    signal stage_0_arbiter_1_ack  : std_logic;
    signal stage_0_arbiter_1_req  : std_logic;
    signal stage_0_arbiter_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    signal stage_0_arbiter_2_ack  : std_logic;
    signal stage_0_arbiter_2_req  : std_logic;
    signal stage_0_arbiter_2_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    signal stage_0_arbiter_3_ack  : std_logic;
    signal stage_0_arbiter_3_req  : std_logic;
    signal stage_0_arbiter_3_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    signal stage_1_arbiter_0_ack  : std_logic;
    signal stage_1_arbiter_0_req  : std_logic;
    signal stage_1_arbiter_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    signal stage_1_arbiter_1_ack  : std_logic;
    signal stage_1_arbiter_1_req  : std_logic;
    signal stage_1_arbiter_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    signal stage_2_arbiter_0_ack  : std_logic;
    signal stage_2_arbiter_0_req  : std_logic;
    signal stage_2_arbiter_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    begin
    stage_0_arbiter_0 : entity work.arbiter(impl)
      generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
      port map(
        rst => rst,
        -- Channel A
        inA_req => out_north_to_local_req,
        inA_data => out_north_to_local_data,
        inA_ack => out_north_to_local_ack,
        -- Channel B
        inB_req => out_south_to_local_req,  
        inB_data => out_south_to_local_data,
        inB_ack => out_south_to_local_ack,
        -- Output channel
        outC_req => stage_0_arbiter_0_req,
        outC_data => stage_0_arbiter_0_data,
        outC_ack => stage_0_arbiter_0_ack);

    stage_0_arbiter_1 : entity work.arbiter(impl)
      generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
      port map(
        rst => rst,
        -- Channel A
        inA_req => out_east_to_local_req,
        inA_data => out_east_to_local_data,
        inA_ack => out_east_to_local_ack,
        -- Channel B
        inB_req => out_west_to_local_req,  
        inB_data => out_west_to_local_data,
        inB_ack => out_west_to_local_ack,
        -- Output channel
        outC_req => stage_0_arbiter_1_req,
        outC_data => stage_0_arbiter_1_data,
        outC_ack => stage_0_arbiter_1_ack);

    stage_0_arbiter_2 : entity work.arbiter(impl)
      generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
      port map(
        rst => rst,
        -- Channel A
        inA_req => out_south_east_to_local_req,
        inA_data => out_south_east_to_local_data,
        inA_ack => out_south_east_to_local_ack,
        -- Channel B
        inB_req => out_south_west_to_local_req,  
        inB_data => out_south_west_to_local_data,
        inB_ack => out_south_west_to_local_ack,
        -- Output channel
        outC_req => stage_0_arbiter_2_req,
        outC_data => stage_0_arbiter_2_data,
        outC_ack => stage_0_arbiter_2_ack);
      
    stage_0_arbiter_3 : entity work.arbiter(impl)
      generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
      port map(
        rst => rst,
        -- Channel A
        inA_req => out_north_east_to_local_req,
        inA_data => out_north_east_to_local_data,
        inA_ack => out_north_east_to_local_ack,
        -- Channel B
        inB_req => out_north_west_to_local_req,  
        inB_data => out_north_west_to_local_data,
        inB_ack => out_north_west_to_local_ack,
        -- Output channel
        outC_req => stage_0_arbiter_3_req,
        outC_data => stage_0_arbiter_3_data,
        outC_ack => stage_0_arbiter_3_ack);


    stage_1_arbiter_0 : entity work.arbiter(impl)
      generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
      port map(
        rst => rst,
        -- Channel A
        inA_req => stage_0_arbiter_0_req,
        inA_data => stage_0_arbiter_0_data,
        inA_ack => stage_0_arbiter_0_ack,
        -- Channel B
        inB_req => stage_0_arbiter_1_req,  
        inB_data => stage_0_arbiter_1_data,
        inB_ack => stage_0_arbiter_1_ack,
        -- Output channel
        outC_req => stage_1_arbiter_0_req,
        outC_data => stage_1_arbiter_0_data,
        outC_ack => stage_1_arbiter_0_ack);

      stage_1_arbiter_1 : entity work.arbiter(impl)
        generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
        port map(
          rst => rst,
          -- Channel A
          inA_req => stage_0_arbiter_2_req,
          inA_data => stage_0_arbiter_2_data,
          inA_ack => stage_0_arbiter_2_ack,
          -- Channel B
          inB_req => stage_0_arbiter_3_req,  
          inB_data => stage_0_arbiter_3_data,
          inB_ack => stage_0_arbiter_3_ack,
          -- Output channel
          outC_req => stage_1_arbiter_1_req,
          outC_data => stage_1_arbiter_1_data,
          outC_ack => stage_1_arbiter_1_ack);

      stage_2_arbiter_0 : entity work.arbiter(impl)
        generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
        port map(
          rst => rst,
          -- Channel A
          inA_req => stage_1_arbiter_0_req,
          inA_data => stage_1_arbiter_0_data,
          inA_ack => stage_1_arbiter_0_ack,
          -- Channel B
          inB_req => stage_1_arbiter_1_req,  
          inB_data => stage_1_arbiter_1_data,
          inB_ack => stage_1_arbiter_1_ack,
          -- Output channel
          outC_req => stage_2_arbiter_0_req,
          outC_data => stage_2_arbiter_0_data,
          outC_ack => stage_2_arbiter_0_ack);
      stage_1_fifo : entity work.buffer_rtl(RTL)
        generic map( buffer_length => buffer_length )
        port map(
          --Reset input
          rst => rst,

          -- Input channels
          in_ack => stage_2_arbiter_0_ack,
          in_req => stage_2_arbiter_0_req,
          in_data => stage_2_arbiter_0_data,

          -- Output channels
          out_ack => out_ack,
          out_req => out_req,
          out_data => out_data
        );
      
  
end architecture;