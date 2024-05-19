library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.noc_defs_pkg.all;
use work.noc_connections_pkg.all;
entity noc_hw_top is
    generic
    (
        NOC_ADDRESS_WIDTH : natural := NOC_ADDRESS_WIDTH
    );
    port
    (
        pil_clk : in std_logic;
        pil_rst : in std_logic;
        -- Switches
        pil4_switches_destination_from_0_0 : in std_logic_vector(NOC_NIBBLE_LENGTH - 1 downto 0);
        pil4_switches_destination_from_2_2 : in std_logic_vector(NOC_NIBBLE_LENGTH - 1 downto 0);
        -- LEDs
        pol16_leds : out std_logic_vector(NOC_HALFWORD_LENGTH - 1 downto 0);

        pol_local_ack_at_0_0 : out std_logic;
        pol_local_ack_at_2_2 : out std_logic;
        pil_button_left      : in std_logic;
        pil_button_center    : in std_logic
    );
end entity noc_hw_top;

architecture rtl of noc_hw_top is
    -- buttons
    signal sl_button_left_db, sl_button_center_db                   : std_logic                    := '0';
    signal slv2_button_left_db_sample, slv2_button_center_db_sample : std_logic_vector(1 downto 0) := (others => '0');
    signal sl_button_left_db_toggle, sl_button_center_db_toggle     : std_logic                    := '0';
    type arrslv_address_t is array (natural range 0 to 2 ** NOC_ADDRESS_WIDTH - 1) of std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0);
    impure function func_seq_local_address_gen return arrslv_address_t is
        variable v_return_seq_addr_constant : arrslv_address_t := (others => (others => '0'));
    begin
        for i in 0 to 2 ** NOC_ADDRESS_WIDTH - 1 loop
            v_return_seq_addr_constant(i) := std_logic_vector(to_unsigned(i, v_return_seq_addr_constant(i)'length));
        end loop;
        return v_return_seq_addr_constant;
    end function;

    signal sarrslv_local_y_addresses : arrslv_address_t := func_seq_local_address_gen;
    signal sarrslv_local_x_addresses : arrslv_address_t := func_seq_local_address_gen;

    signal sarrif_mesh_diagonal       : arrif_diagonal_connections_t;
    signal sarrif_mesh_horizonal      : arrif_horizontal_connections_t;
    signal sarrif_mesh_vertical       : arrif_vertical_connections_t;
    signal sarrif_mesh_local          : arrif_local_connections_t;
    function func_int_to_yint(arg_int : integer) return integer is
        variable v_ret_int                : integer;

    begin
        v_ret_int := to_integer(to_unsigned(arg_int, NOC_ADDRESS_WIDTH * 2)(NOC_ADDRESS_WIDTH * 2 - 1 downto NOC_ADDRESS_WIDTH));
        return v_ret_int;
    end function;

    function func_int_to_xint(arg_int : integer) return integer is
        variable v_ret_int                : integer;

    begin
        v_ret_int := to_integer(to_unsigned(arg_int, NOC_ADDRESS_WIDTH * 2)(NOC_ADDRESS_WIDTH - 1 downto 0));
        return v_ret_int;
    end function;

    function func_get_left_from_int(arg_int : integer) return std_logic is
        variable v_prelim_int                   : integer   := 0;
        variable v_ret_sl                       : std_logic := '0';

    begin
        v_prelim_int := func_int_to_xint(arg_int);
        if (v_prelim_int = 0) then
            v_ret_sl := '1';
        end if;
        return v_ret_sl;
    end function;
    function func_get_right_from_int(arg_int : integer) return std_logic is
        variable v_prelim_int                    : integer   := 0;
        variable v_ret_sl                        : std_logic := '0';

    begin
        v_prelim_int := func_int_to_xint(arg_int);
        if (v_prelim_int = 2 ** NOC_ADDRESS_WIDTH - 1) then
            v_ret_sl := '1';
        end if;
        return v_ret_sl;
    end function;
    function func_get_top_from_int(arg_int : integer) return std_logic is
        variable v_prelim_int                  : integer   := 0;
        variable v_ret_sl                      : std_logic := '0';

    begin
        v_prelim_int := func_int_to_yint(arg_int);
        if (v_prelim_int = 0) then
            v_ret_sl := '1';
        end if;
        return v_ret_sl;
    end function;
    function func_get_bottom_from_int(arg_int : integer) return std_logic is
        variable v_prelim_int                     : integer   := 0;
        variable v_ret_sl                         : std_logic := '0';

    begin
        v_prelim_int := func_int_to_yint(arg_int);
        if (v_prelim_int = 2 ** NOC_ADDRESS_WIDTH - 1) then
            v_ret_sl := '1';
        end if;
        return v_ret_sl;
    end function;
begin
    sl_button_left_db   <= pil_button_left;
    sl_button_center_db <= pil_button_center;
    --   COMPONENT_BTN_CENTER : entity work.debounce_btn(behav)
    --       port
    --       map
    --       (
    --
    --       clk      => pil_clk,
    --       rst      => pil_rst,
    --       i_btn    => pil_button_center,
    --       o_switch => sl_button_center_db
    --
    --       );
    --
    COMPONENT_NOC_GEN : for i in 0 to (2 ** NOC_ADDRESS_WIDTH) ** 2 - 1 generate
        COMPONENT_ROUTER_NODE : entity work.router_rtl(rtl)
            generic
            map
            (
            left      => func_get_left_from_int(i),
            right     => func_get_right_from_int(i),
            top       => func_get_top_from_int(i),
            bottom    => func_get_bottom_from_int(i),
            address_x => std_logic_vector(to_unsigned(func_int_to_xint(i), NOC_ADDRESS_WIDTH)),
            address_y => std_logic_vector(to_unsigned(func_int_to_yint(i), NOC_ADDRESS_WIDTH))
            )
            port map
            (
                rst => pil_rst,

                -- DIAGONAL INPUT CHANNELS
                in_north_east_ack  => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).northeast_to_southwest.ack,
                in_north_east_req  => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).northeast_to_southwest.req,
                in_north_east_data => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).northeast_to_southwest.data,

                in_north_west_ack  => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).northwest_to_southeast.ack,
                in_north_west_req  => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).northwest_to_southeast.req,
                in_north_west_data => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).northwest_to_southeast.data,

                in_south_east_ack  => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 1).southeast_to_northwest.ack,
                in_south_east_req  => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 1).southeast_to_northwest.req,
                in_south_east_data => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 1).southeast_to_northwest.data,

                in_south_west_ack  => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).southwest_to_northeast.ack,
                in_south_west_req  => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).southwest_to_northeast.req,
                in_south_west_data => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).southwest_to_northeast.data,

                -- STRAIGTH INPUT CHANNELS
                in_north_ack  => sarrif_mesh_vertical(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).north_to_south.ack,
                in_north_req  => sarrif_mesh_vertical(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).north_to_south.req,
                in_north_data => sarrif_mesh_vertical(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).north_to_south.data,

                in_east_ack  => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).east_to_west.ack,
                in_east_req  => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).east_to_west.req,
                in_east_data => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).east_to_west.data,

                in_south_ack  => sarrif_mesh_vertical(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).south_to_north.ack,
                in_south_req  => sarrif_mesh_vertical(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).south_to_north.req,
                in_south_data => sarrif_mesh_vertical(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).south_to_north.data,

                in_west_ack  => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).west_to_east.ack,
                in_west_req  => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).west_to_east.req,
                in_west_data => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).west_to_east.data,

                -- DIAGONAL OUTPUT CHANNELS
                out_north_west_ack  => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).southeast_to_northwest.ack,
                out_north_west_req  => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).southeast_to_northwest.req,
                out_north_west_data => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).southeast_to_northwest.data,

                out_north_east_ack  => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).southwest_to_northeast.ack,
                out_north_east_req  => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).southwest_to_northeast.req,
                out_north_east_data => sarrif_mesh_diagonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).southwest_to_northeast.data,

                out_south_east_ack  => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 1).northwest_to_southeast.ack,
                out_south_east_req  => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 1).northwest_to_southeast.req,
                out_south_east_data => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 1).northwest_to_southeast.data,

                out_south_west_ack  => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).northeast_to_southwest.ack,
                out_south_west_req  => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).northeast_to_southwest.req,
                out_south_west_data => sarrif_mesh_diagonal(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).northeast_to_southwest.data,

                -- STRAIGHT OUTPUT CHANNELS
                out_north_ack  => sarrif_mesh_vertical(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).south_to_north.ack,
                out_north_req  => sarrif_mesh_vertical(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).south_to_north.req,
                out_north_data => sarrif_mesh_vertical(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).south_to_north.data,

                out_east_ack  => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).west_to_east.ack,
                out_east_req  => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).west_to_east.req,
                out_east_data => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 1).west_to_east.data,

                out_south_ack  => sarrif_mesh_vertical(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).north_to_south.ack,
                out_south_req  => sarrif_mesh_vertical(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).north_to_south.req,
                out_south_data => sarrif_mesh_vertical(func_int_to_yint(i) + 1, func_int_to_xint(i) + 0).north_to_south.data,

                out_west_ack  => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).east_to_west.ack,
                out_west_req  => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).east_to_west.req,
                out_west_data => sarrif_mesh_horizonal(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).east_to_west.data,

                -- Output to local port
                out_local_ack  => sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_out.ack,
                out_local_req  => sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_out.req,
                out_local_data => sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_out.data,
                -- Input for local ports to componenets
                in_local_ack  => sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_in.ack,
                in_local_req  => sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_in.req,
                in_local_data => sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_in.data
            );
    end generate;
    COMPONENT_NOC_LOCAL_OUTPUT_GEN : for i in 0 to (2 ** NOC_ADDRESS_WIDTH) ** 2 - 1 generate
        suck : entity work.delay_element(lut)
            generic
            map
            (
            size => 10) -- Delay  size
            port
            map
            (
            d => sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_out.req,
            z => sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_out.ack
            );
        pol16_leds(i) <= sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_out.req;

    end generate;
    COMPONENT_NOC_INPUT_LOOPGEN : for i in 1 to (2 ** NOC_ADDRESS_WIDTH) ** 2 - 1 generate
        COMPONENT_NOC_INPUT_IFGEN : if (i /= 10) generate
            sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_in.data <= (others => '0');
            sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_in.req  <= sarrif_mesh_local(func_int_to_yint(i) + 0, func_int_to_xint(i) + 0).local_in.ack;
        end generate;
    end generate;
    pol_local_ack_at_0_0                  <= sarrif_mesh_local(func_int_to_yint(0) + 0, func_int_to_xint(0) + 0).local_in.ack;
    sarrif_mesh_local(0, 0).local_in.data <= pil4_switches_destination_from_0_0;
    sarrif_mesh_local(0, 0).local_in.req  <= sl_button_center_db_toggle;

    pol_local_ack_at_2_2                  <= sarrif_mesh_local(func_int_to_yint(10) + 0, func_int_to_xint(10) + 0).local_in.ack;
    sarrif_mesh_local(2, 2).local_in.data <= pil4_switches_destination_from_2_2;
    sarrif_mesh_local(2, 2).local_in.req  <= sl_button_left_db_toggle;

    process (pil_clk, pil_rst)
    begin
        if rising_edge(pil_clk) then
            if (pil_rst = '1') then
                slv2_button_center_db_sample <= (others => '0');
                sl_button_center_db_toggle   <= '0';
                sl_button_left_db_toggle     <= '0';

            else
                slv2_button_center_db_sample <= slv2_button_center_db_sample(0) & sl_button_center_db;
                if (slv2_button_center_db_sample = "01") then
                    sl_button_center_db_toggle <= not sl_button_center_db_toggle;
                end if;
                slv2_button_left_db_sample <= slv2_button_left_db_sample(0) & sl_button_left_db;
                if (slv2_button_left_db_sample = "01") then
                    sl_button_left_db_toggle <= not sl_button_left_db_toggle;
                end if;
            end if;
        end if;
    end process;
end architecture;