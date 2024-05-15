library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;
use work.buffer_rtl;

entity output_3_inputs is
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
    in_ack_1 : out std_logic;

    in_req_2 : in std_logic;
    in_data_2 : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    in_ack_2 : out std_logic

    );
end entity;

architecture rtl of output_3_inputs is

  -- Stage 0 Signals
  signal stage_0_arbiter_1_ack  : std_logic;
  signal stage_0_arbiter_1_req  : std_logic;
  signal stage_0_arbtier_1_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

  -- Stage 1 Signals
  signal stage_1_arbiter_2_ack  : std_logic;
  signal stage_1_arbiter_2_req  : std_logic;
  signal stage_1_arbtier_2_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);


  begin
  stage_0_arbiter_1 : entity work.arbiter(impl)
    generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
    port map(
      rst       => rst,
      -- Channel A
      inA_req   => in_req_0,
      inA_data  => in_data_0,
      inA_ack   => in_ack_0,
      -- Channel B
      inB_req   => in_req_1,  
      inB_data  => in_data_1,
      inB_ack   => in_ack_1,
      -- Output channel
      outC_req  => stage_0_arbiter_1_req,
      outC_data => stage_0_arbtier_1_data,
      outC_ack  => stage_0_arbiter_1_ack
  );

  stage_1_arbiter_3 : entity work.arbiter(impl)
    generic map (ARBITER_DATA_WIDTH => NOC_DATA_WIDTH)
    port map(
      rst       => rst,
      -- Channel A
      inA_req   => stage_0_arbiter_1_req,
      inA_data  => stage_0_arbtier_1_data,
      inA_ack   => stage_0_arbiter_1_ack,
      -- Channel B
      inB_req   => in_req_2,  
      inB_data  => in_data_2,
      inB_ack   => in_ack_2,
      -- Output channel
      outC_req  => stage_1_arbiter_3_req,
      outC_data => stage_1_arbtier_3_data,
      outC_ack  => stage_1_arbiter_3_ack
  );
      
  stage_1_fifo : entity work.buffer_rtl(RTL)
    generic map( buffer_length => buffer_length )
    port map(
      --Reset input
      rst       => rst,
      -- Input channels
      in_ack    => stage_1_arbiter_3_ack,
      in_req    => stage_1_arbiter_3_req,
      in_data   => stage_1_arbtier_3_data,
     -- Output channels
      out_ack   => out_ack,
      out_req   => out_req,
      out_data  => out_data
  );

end architecture;