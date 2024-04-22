library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;
use work.buffer_rtl;

entity output_2_inputs is
  generic(buffer_length : integer := 0);
  port (
    rst : in std_logic;

    --Output channel
    out_req : out std_logic;
    out_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack : in std_logic;

    -- Input channel
    in_req_0 : in std_logic;
    in_data_0 : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    in_ack_0 : out std_logic;

    in_req_1 : in std_logic;
    in_data_1 : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    in_ack_1 : out std_logic
    ) ;
end entity;

architecture rtl of output_2_inputs is
      -- Stage 0 Signals
    signal stage_0_ack  : std_logic;
    signal stage_0_req  : std_logic;
    signal stage_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    begin
    stage_0_arbiter : entity work.arbiter(impl)
      generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
      port map(
        rst => rst,
        -- Channel A
        inA_req => in_req_0,
        inA_data => in_data_0,
        inA_ack => in_ack_0,
        -- Channel B
        inB_req => in_req_1,  
        inB_data => in_data_1,
        inB_ack => in_ack_1,
        -- Output channel
        outC_req => stage_0_req,
        outC_data => stage_0_data,
        outC_ack => stage_0_ack);
        
      stage_1_fifo : entity work.buffer_rtl(RTL)
        generic map( buffer_length => buffer_length )
        port map(
          --Reset input
          rst => rst,

          -- Input channels
          in_ack => stage_0_ack,
          in_req => stage_0_req,
          in_data => stage_0_data,

          -- Output channels
          out_ack => out_ack,
          out_req => out_req,
          out_data => out_data
        );
      
  
end architecture;