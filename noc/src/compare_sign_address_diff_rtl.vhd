library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;
entity compare_sign_address_diff_rtl is
  generic
  (
    SUBTRACT_DELAY : natural := NOC_COMPARE_DIFF_ADDRESS_DELAY
  );
  port
  (
    -- Local Address
    in_local_address : in std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0);

    -- Input channel
    in_ack  : out std_logic;
    in_req  : in std_logic;
    in_data : in std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0);

    -- Output Continue
    out_req  : out std_logic;
    out_data : out std_logic;
    out_ack  : in std_logic

  );

end entity compare_sign_address_diff_rtl;

architecture rtl of compare_sign_address_diff_rtl is
  signal delayed_req : std_logic;
begin

  out_req <= delayed_req;
  in_ack  <= out_ack;

  delay : entity work.delay_element(lut)
    generic
    map(
    size => SUBTRACT_DELAY
    )
    port map
    (
      d => in_req,
      z => delayed_req
    );

  subtract : entity work.compare_sign_slv_diff_rtl(rtl)
    generic
    map(
    SUBTRACT_LENGTH => NOC_ADDRESS_WIDTH
    )
    port
    map
    (
    subtract_a => in_data,
    subtract_b => in_local_address,
    signed_out => out_data
    );

end architecture;