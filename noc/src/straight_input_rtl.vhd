library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;

entity straight_input_rtl is
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

    -- Output Continue
    out_req_continue  : out std_logic;
    out_data_continue : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_continue  : in std_logic;

    -- Output Local
    out_req_local  : out std_logic;
    out_data_local : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_local  : in std_logic
  );
end entity straight_input_rtl;

architecture rtl of straight_input_rtl is
end architecture;