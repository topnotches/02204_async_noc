LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.data_pkg.ALL;
USE work.noc_defs_pkg.ALL;


entity compare_address_diff_rtl is
    port (
        -- Local Address
        in_local_address : IN STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0);

        -- Input channel
        in_ack : OUT STD_LOGIC;
        in_req : IN STD_LOGIC;
        in_data : IN STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0);

        -- Output Continue
        out_req : OUT STD_LOGIC;
        out_data : OUT STD_LOGIC;
        out_ack : IN STD_LOGIC;

    );
end entity compare_address_diff_rtl;

architecture rtl of compare_address_diff_rtl is
    signal delayed_req : std_logic;
begin

    out_req <= delayed_req;
    in_ack <= out_ack;

    delay : ENTITY work.delay_element(lut)
    GENERIC MAP(
        size => NOC_ADDRESS_COMPARE_DELAY
    )
    PORT MAP
    (
        d => in_req,
        z => delayed_req
    );

    compare : ENTITY work.compare_slv_diff_rtl(rtl)
    PORT MAP
    (
        comp_a => in_data,
        comp_b => in_local_address,
        is_diff => out_data
    );

    

end architecture;