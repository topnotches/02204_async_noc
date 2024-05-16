library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;
use work.buffer_rtl;

entity output_1_inputs is
    generic(buffer_length : integer := 1);
    port (
        rst : in std_logic;
  
        --Output channel
        out_req : out std_logic;
        out_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
        out_ack : in std_logic;
  
        -- Input channel
        in_req : in std_logic;
        in_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
        in_ack : out std_logic
    );
end entity;
  
architecture rtl of output_1_inputs is
    -- Stage 0 Signals
    signal stage_0_ack  : std_logic;
    signal stage_0_req  : std_logic;
    signal stage_0_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    begin
    stage_0_click_element : entity work.click_element(Behavioral)
    generic map(
        DATA_WIDTH => NOC_DATA_WIDTH, -- Replace YOUR_DATA_WIDTH with your desired value
        VALUE => 0, -- Replace YOUR_VALUE with your desired value
        PHASE_INIT => '0' -- Set PHASE_INIT to '0' as per your requirements
    )
    port map(
        rst => rst,
        -- Channel A
        in_req => in_req,
        in_data => in_data,
        in_ack => in_ack,
        -- Output channel
        out_req => stage_0_req,
        out_data => stage_0_data,
        out_ack => stage_0_ack
    );
        
    stage_1_fifo : entity work.buffer_rtl(RTL)
    generic map( 
        buffer_length => buffer_length 
    )
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