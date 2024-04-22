library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;

entity diagonal_output_rtl is
  port
  (
    rst : in std_logic;

    -- Diagonal input channel
    in_ack_diagonal     : out std_logic;
    in_req_diagonal     : in std_logic;
    in_data_diagonal    : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Local input channel
    in_ack_local        : out std_logic;
    in_req_local        : in std_logic;
    in_data_local       : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Output channel
    out_ack             : in std_logic;
    out_req             : out std_logic;
    out_data            : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0)
  );
end entity diagonal_output_rtl;

architecture rtl of diagonal_output_rtl is
  begin
end architecture rtl;