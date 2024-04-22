library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;

entity diagonal_output_rtl is
  port (
    rst : in std_logic;

    --Output channel
    out_req : out std_logic;
    out_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack : out std_logic;

    -- Input channel
    in_req_continue : out std_logic;
    in_data_continue : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    in_ack_continue : out std_logic;

    in_req_local : out std_logic;
    in_data_local : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    in_ack_local : out std_logic;
    ) ;
end diagonal_output_rtl

architecture rtl of diagonal_output_rtl is
      -- Stage 0 Signals
    signal stage_0_ack  : std_logic                                     := '0';
    signal stage_0_req  : std_logic                                     := '0';
    signal stage_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    stage_0_arbiter : entity work.arbiter(impl) is
      port (
        rst => rst,
        -- Channel A
        inA_req => in_req_continue,
        inA_data => in_data_continue
        inA_ack   
        -- Channel B
        inB_req   
        inB_data 
        inB_ack   
        -- Output channel
        outC_req  
        outC_data
        outC_ack 
      ) ;


end architecture;