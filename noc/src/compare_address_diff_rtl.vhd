library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;
entity compare_address_diff_rtl is
    generic
    (
        COMPARE_DELAY : natural := NOC_COMPUTE_SLV_DIFF_DELAY_N
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
end entity compare_address_diff_rtl;

architecture rtl of compare_address_diff_rtl is
    signal delayed_req : std_logic;
begin

    out_req <= delayed_req;
    in_ack  <= out_ack;

    delay : entity work.delay_element(lut)
        generic
        map(
        size => COMPARE_DELAY
        )
        port map
        (
            d => in_req,
            z => delayed_req
        );

    compare : entity work.compare_slv_diff_rtl(rtl)
        generic
        map(
        COMPARE_LENGTH => NOC_ADDRESS_WIDTH
        )
        port
        map
        (
        comp_a  => in_data,
        comp_b  => in_local_address,
        is_diff => out_data
        );

end architecture;