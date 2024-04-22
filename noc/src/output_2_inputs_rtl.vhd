library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;

entity output_2_inputs is
  port (
    rst : in std_logic;

    --Output channel
    out_req : out std_logic;
    out_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack : out std_logic;

    -- Input channel
    in_req_0 : out std_logic;
    in_data_0 : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    in_ack_0 : out std_logic;

    in_req_1 : out std_logic;
    in_data_1 : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    in_ack_1 : out std_logic;
    ) ;
end output_2_inputs

architecture rtl of output_2_inputs is
      -- Stage 0 Signals
    signal stage_0_ack  : std_logic                                     := '0';
    signal stage_0_req  : std_logic                                     := '0';
    signal stage_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    stage_0_arbiter : entity work.arbiter(impl) is
      port (
        rst => rst,
        -- Channel A
        inA_req => in_req_0,
        inA_data => in_data_0,
        inA_ack => in_ack_0,
        -- Channel B
        inB_req => in_req_1,  
        inB_data => in_data_1,
        inB_ack => in_ack_1
        -- Output channel
        outC_req => stage_0_req,
        outC_data => stage_0_data,
        outC_ack => stage_0_ack
      ) ;
      stage_1_fifo : entity work.buffer_rtl(rtl) is
        port (
          clk   : in std_logic;
          reset : in std_logic;
          
        );
      end entity;

end architecture;