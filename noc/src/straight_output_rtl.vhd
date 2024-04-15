library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;

entity straight_output_rtl is
  port
  (
    rst : in std_logic;


    -- TODO : FIX 2 diagonal channels needed and only on straight!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    -- Diagonal input channel 1
    in_ack_diagonal     : out std_logic;
    in_req_diagonal     : in std_logic;
    in_data_diagonal    : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Local input channel
    in_ack_local        : out std_logic;
    in_req_local        : in std_logic;
    in_data_local       : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- West/East input channel
    in_ack_we           : out std_logic;
    in_req_we           : in std_logic;
    in_data_we          : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- North/South input channel
    in_ack_ns           : out std_logic;
    in_req_ns           : in std_logic;
    in_data_ns          : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Output channel
    out_ack             : in std_logic
    out_req             : out std_logic;
    out_data            : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
  );
end entity straight_output_rtl;

architecture rtl of straight_output_rtl is
end architecture;