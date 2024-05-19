library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;
use work.noc_connections_pkg.all;

entity noc_rtl is
    port
    (
        rst        : in std_logic;
        in_locals  : in noc_local_in;
        out_locals : out noc_local_out);
end entity noc_rtl;

architecture rtl of noc_rtl is
    signal mesh_diagnoals   : arrif_diagonal_connections_t   := (others => (others => (others => (ack => '0', req => '0', data => (others => '0')))));
    signal mesh_horizontals : arrif_horizontal_connections_t := (others => (others => (others => (ack => '0', req => '0', data => (others => '0')))));
    signal mesh_verticals   : arrif_vertical_connections_t   := (others => (others => (others => (ack => '0', req => '0', data => (others => '0')))));

    function left(x : integer) return std_logic is
    begin
        if x = 0 then
            return '1';
        else
            return '0';
        end if;
    end function;
    function right(x : integer) return std_logic is
    begin
        if x = NOC_MESH_LENGTH - 1 then
            return '1';
        else
            return '0';
        end if;
    end function;
    function top(y : integer) return std_logic is
    begin
        if y = 0 then
            return '1';
        else
            return '0';
        end if;
    end function;
    function bottom(y : integer) return std_logic is
    begin
        if y = NOC_MESH_LENGTH - 1 then
            return '1';
        else
            return '0';
        end if;
    end function;
begin
    -- generate the mesh nodes
    gen_x_axis : for y in 0 to NOC_MESH_LENGTH - 1 generate

    begin
        gen_y_axis : for x in 0 to NOC_MESH_LENGTH - 1 generate
            signal in_north_east_ack  : std_logic;
            signal in_north_east_req  : std_logic;
            signal in_north_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal in_north_west_ack  : std_logic;
            signal in_north_west_req  : std_logic;
            signal in_north_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal in_south_east_ack  : std_logic;
            signal in_south_east_req  : std_logic;
            signal in_south_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal in_south_west_ack  : std_logic;
            signal in_south_west_req  : std_logic;
            signal in_south_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            -- STRAIGTH INPUT CHANNELS
            signal in_north_ack  : std_logic;
            signal in_north_req  : std_logic;
            signal in_north_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal in_east_ack  : std_logic;
            signal in_east_req  : std_logic;
            signal in_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal in_south_ack  : std_logic;
            signal in_south_req  : std_logic;
            signal in_south_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal in_west_ack  : std_logic;
            signal in_west_req  : std_logic;
            signal in_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            -- DIAGONAL OUTPUT CHANNELS
            signal out_north_west_ack  : std_logic;
            signal out_north_west_req  : std_logic;
            signal out_north_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal out_north_east_ack  : std_logic;
            signal out_north_east_req  : std_logic;
            signal out_north_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal out_south_east_ack  : std_logic;
            signal out_south_east_req  : std_logic;
            signal out_south_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal out_south_west_ack  : std_logic;
            signal out_south_west_req  : std_logic;
            signal out_south_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            -- STRAIGHT OUTPUT CHANNELS
            signal out_north_ack  : std_logic;
            signal out_north_req  : std_logic;
            signal out_north_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal out_east_ack  : std_logic;
            signal out_east_req  : std_logic;
            signal out_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal out_south_ack  : std_logic;
            signal out_south_req  : std_logic;
            signal out_south_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

            signal out_west_ack  : std_logic;
            signal out_west_req  : std_logic;
            signal out_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
        begin

            mesh_node : entity work.router_rtl(rtl)
                generic
                map (
                left      => left(x),
                right     => right(x),
                top       => top(y),
                bottom    => bottom(y),
                address_x => std_logic_vector(to_unsigned(x, NOC_ADDRESS_WIDTH)),
                address_y => std_logic_vector(to_unsigned(y, NOC_ADDRESS_WIDTH))
                )
                port map
                (
                    rst => rst,
                    -- DIAGONAL INPUT CHANNELS
                    -- DIAGONAL INPUT CHANNELS
                    in_north_east_ack  => mesh_diagnoals(y, x + 1).southwest_to_northeast.ack,
                    in_north_east_req  => mesh_diagnoals(y, x + 1).southwest_to_northeast.req,
                    in_north_east_data => mesh_diagnoals(y, x + 1).southwest_to_northeast.data,

                    in_north_west_ack  => mesh_diagnoals(y, x).southeast_to_northwest.ack,
                    in_north_west_req  => mesh_diagnoals(y, x).southeast_to_northwest.req,
                    in_north_west_data => mesh_diagnoals(y, x).southeast_to_northwest.data,

                    in_south_east_ack  => mesh_diagnoals(y + 1, x + 1).northwest_to_southeast.ack,
                    in_south_east_req  => mesh_diagnoals(y + 1, x + 1).northwest_to_southeast.req,
                    in_south_east_data => mesh_diagnoals(y + 1, x + 1).northwest_to_southeast.data,

                    in_south_west_ack  => mesh_diagnoals(y + 1, x).northeast_to_southwest.ack,
                    in_south_west_req  => mesh_diagnoals(y + 1, x).northeast_to_southwest.req,
                    in_south_west_data => mesh_diagnoals(y + 1, x).northeast_to_southwest.data,

                    -- STRAIGTH INPUT CHANNELS
                    in_north_ack  => mesh_verticals(y, x).south_to_north.ack,
                    in_north_req  => mesh_verticals(y, x).south_to_north.req,
                    in_north_data => mesh_verticals(y, x).south_to_north.data,

                    in_east_ack  => mesh_horizontals(y, x + 1).left_to_right.ack,
                    in_east_req  => mesh_horizontals(y, x + 1).left_to_right.req,
                    in_east_data => mesh_horizontals(y, x + 1).left_to_right.data,

                    in_south_ack  => mesh_verticals(y + 1, x).north_to_south.ack,
                    in_south_req  => mesh_verticals(y + 1, x).north_to_south.req,
                    in_south_data => mesh_verticals(y + 1, x).north_to_south.data,

                    in_west_ack  => mesh_horizontals(y, x).right_to_left.ack,
                    in_west_req  => mesh_horizontals(y, x).right_to_left.req,
                    in_west_data => mesh_horizontals(y, x).right_to_left.data,

                    -- DIAGONAL OUTPUT CHANNELS
                    out_north_west_ack  => mesh_diagnoals(y, x).northwest_to_southeast.ack,
                    out_north_west_req  => mesh_diagnoals(y, x).northwest_to_southeast.req,
                    out_north_west_data => mesh_diagnoals(y, x).northwest_to_southeast.data,

                    out_north_east_ack  => mesh_diagnoals(y, x + 1).northeast_to_southwest.ack,
                    out_north_east_req  => mesh_diagnoals(y, x + 1).northeast_to_southwest.req,
                    out_north_east_data => mesh_diagnoals(y, x + 1).northeast_to_southwest.data,

                    out_south_east_ack  => mesh_diagnoals(y + 1, x + 1).southeast_to_northwest.ack,
                    out_south_east_req  => mesh_diagnoals(y + 1, x + 1).southeast_to_northwest.req,
                    out_south_east_data => mesh_diagnoals(y + 1, x + 1).southeast_to_northwest.data,

                    out_south_west_ack  => mesh_diagnoals(y + 1, x).southwest_to_northeast.ack,
                    out_south_west_req  => mesh_diagnoals(y + 1, x).southwest_to_northeast.req,
                    out_south_west_data => mesh_diagnoals(y + 1, x).southwest_to_northeast.data,

                    -- STRAIGHT OUTPUT CHANNELS
                    out_north_ack  => mesh_verticals(y, x).north_to_south.ack,
                    out_north_req  => mesh_verticals(y, x).north_to_south.req,
                    out_north_data => mesh_verticals(y, x).north_to_south.data,

                    out_east_ack  => mesh_horizontals(y, x + 1).right_to_left.ack,
                    out_east_req  => mesh_horizontals(y, x + 1).right_to_left.req,
                    out_east_data => mesh_horizontals(y, x + 1).right_to_left.data,

                    out_south_ack  => mesh_verticals(y + 1, x).south_to_north.ack,
                    out_south_req  => mesh_verticals(y + 1, x).south_to_north.req,
                    out_south_data => mesh_verticals(y + 1, x).south_to_north.data,

                    out_west_ack  => mesh_horizontals(y, x).left_to_right.ack,
                    out_west_req  => mesh_horizontals(y, x).left_to_right.req,
                    out_west_data => mesh_horizontals(y, x).left_to_right.data,

                    -- LOCAL INPUT
                    in_local_ack  => out_locals(y, x).ack,
                    in_local_req  => in_locals(y, x).req,
                    in_local_data => in_locals(y, x).data,

                    -- LOCAL OUTPUT
                    out_local_ack  => in_locals(y, x).ack,
                    out_local_req  => out_locals(y, x).req,
                    out_local_data => out_locals(y, x).data
                );

        end generate;
    end generate;

end architecture rtl;