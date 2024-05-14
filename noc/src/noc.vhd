library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;

entity noc_rtl is
    port (
        in_local_data   : in mesh_in_out;
        in_local_ack    : out mesh_control;
        in_local_req    : in mesh_control;

        out_local_data  : out mesh_in_out;
        out_local_ack   : in mesh_control;
        out_local_req   : out mesh_control
        );
end entity noc_rtl;

architecture rtl of noc_rtl is
    signal rst : std_logic := '0';

    signal north_data : mesh_connector_in_out;
    signal north_ack : mesh_connector_control;
    signal north_req : mesh_connector_control;

    signal south_data : mesh_connector_in_out;
    signal south_ack : mesh_connector_control;
    signal south_req : mesh_connector_control;

    signal east_data : mesh_connector_in_out;
    signal east_ack : mesh_connector_control;
    signal east_req : mesh_connector_control;

    signal west_data : mesh_connector_in_out;
    signal west_ack : mesh_connector_control;
    signal west_req : mesh_connector_control;

    signal north_east_data : mesh_connector_in_out;
    signal north_east_ack : mesh_connector_control;
    signal north_east_req : mesh_connector_control;

    signal north_west_data : mesh_connector_in_out;
    signal north_west_ack : mesh_connector_control;
    signal north_west_req : mesh_connector_control;

    signal south_east_data : mesh_connector_in_out;
    signal south_east_ack : mesh_connector_control;
    signal south_east_req : mesh_connector_control;

    signal south_west_data : mesh_connector_in_out;
    signal south_west_ack : mesh_connector_control;
    signal south_west_req : mesh_connector_control;
    begin
    -- generate the mesh nodes
    gen_x_axis: for x in 0 to NOC_MESH_LENGTH-1 generate
        
        begin
            gen_y_axis: for y in 0 to NOC_MESH_LENGTH - 1 generate
                -- calculate the generics

                begin
                  mesh_node : entity work.router_rtl(rtl)
                  generic map (
                    left => '1' when x = 0 else '0',
                    right => '1' when x = NOC_MESH_LENGTH - 1 else '0',
                    top => '1' when y = 0 else '0',
                    bottom => '1' when y = NOC_MESH_LENGTH - 1 else '0',
                    address_x => std_logic_vector(to_unsigned(x, NOC_ADDRESS_WIDTH)),
                    address_y => std_logic_vector(to_unsigned(y, NOC_ADDRESS_WIDTH))
                  )
                  port 
                  map (
                    rst => rst,
                    -- DIAGONAL INPUT CHANNELS
                    in_north_east_ack   => '0'             when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else south_west_ack(x+1, y-1),
                    in_north_east_req   => '0'             when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else south_west_req(x+1, y-1),
                    in_north_east_data  => (others => '0') when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else south_west_data(x+1, y-1),

                    in_north_west_ack   => '0'             when ((y = 0) or (x = 0)) else south_east_ack(x-1, y-1),
                    in_north_west_req   => '0'             when ((y = 0) or (x = 0)) else south_east_req(x-1, y-1),
                    in_north_west_data  => (others => '0') when ((y = 0) or (x = 0)) else south_east_data(x-1, y-1),

                    in_south_east_ack   => '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else north_west_ack(x+1, y+1),
                    in_south_east_req   => '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else north_west_req(x+1, y+1),
                    in_south_east_data  => (others => '0') when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else north_west_data(x+1, y+1),

                    in_south_west_ack   => '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else north_east_ack(x-1, y+1),
                    in_south_west_req   => '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else north_east_req(x-1, y+1),
                    in_south_west_data  => (others => '0') when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else north_east_data(x-1, y+1),

                    -- STRAIGTH INPUT CHANNELS
                    in_north_ack        => '0'             when (y = 0) else south_ack(x, y-1),
                    in_north_req        => '0'             when (y = 0) else south_req(x, y-1),
                    in_north_data       => (others => '0') when (y = 0) else south_data(x, y-1),

                    in_east_ack         => '0'             when (x = NOC_MESH_LENGTH - 1) else west_ack(x+1, y),
                    in_east_req         => '0'             when (x = NOC_MESH_LENGTH - 1) else west_req(x+1, y),
                    in_east_data        => (others => '0') when (x = NOC_MESH_LENGTH - 1) else west_data(x+1, y),

                    in_south_ack        => '0'             when (y =  NOC_MESH_LENGTH - 1) else north_ack(x, y+1),
                    in_south_req        => '0'             when (y =  NOC_MESH_LENGTH - 1) else north_req(x, y+1),
                    in_south_data       => (others => '0') when (y =  NOC_MESH_LENGTH - 1) else north_ack(x, y+1),

                    in_west_ack         => '0'             when (x = 0) else east_ack(x-1, y),
                    in_west_req         => '0'             when (x = 0) else east_req(x-1, y),
                    in_west_data        => (others => '0') when (x = 0) else east_data(x-1, y),

                    -- DIAGONAL OUTPUT CHANNELS
                    out_north_west_ack  => '0'             when ((y = 0) or (x = 0)) else north_west_ack(x, y),
                    out_north_west_req  => '0'             when ((y = 0) or (x = 0)) else north_west_req(x, y),
                    out_north_west_data => (others => '0') when ((y = 0) or (x = 0)) else north_west_data(x, y),

                    out_north_east_ack  => '0'             when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else north_east_ack(x, y),
                    out_north_east_req  => '0'             when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else north_east_req(x, y),
                    out_north_east_data => (others => '0') when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else north_east_data(x, y),

                    out_south_east_ack  => '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else south_east_ack(x, y),
                    out_south_east_req  => '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else south_east_req(x, y),
                    out_south_east_data => (others => '0') when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else south_east_data(x, y),

                    out_south_west_ack  => '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else south_west_ack(x, y),
                    out_south_west_req  => '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else south_west_ack(x, y),
                    out_south_west_data => (others => '0') when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else south_west_ack(x, y),

                    -- STRAIGHT OUTPUT CHANNELS
                    out_north_ack       => '0'             when (y = 0) else north_ack(x, y),
                    out_north_req       => '0'             when (y = 0) else north_req(x, y),
                    out_north_data      => (others => '0') when (y = 0) else north_data(x, y),

                    out_east_ack        => '0'             when (x = NOC_MESH_LENGTH - 1) else east_ack(x, y),
                    out_east_req        => '0'             when (x = NOC_MESH_LENGTH - 1) else east_req(x, y),
                    out_east_data       => (others => '0') when (x = NOC_MESH_LENGTH - 1) else east_data(x, y),

                    out_south_ack       => '0'             when (y =  NOC_MESH_LENGTH - 1) else south_ack(x, y),
                    out_south_req       => '0'             when (y =  NOC_MESH_LENGTH - 1) else south_ack(x, y),
                    out_south_data      => (others => '0') when (y =  NOC_MESH_LENGTH - 1) else south_ack(x, y),

                    out_west_ack        => '0'             when (x = 0) else west_ack(x, y),
                    out_west_req        => '0'             when (x = 0) else west_ack(x, y),
                    out_west_data       => (others => '0') when (x = 0) else west_ack(x, y),

                    -- LOCAL INPUT
                    in_local_ack        => in_local_ack(x, y),
                    in_local_req        => in_local_req(x, y),
                    in_local_data       => in_local_data(x, y),

                    -- LOCAL OUTPUT
                    out_local_ack        => out_local_ack(x, y),
                    out_local_req        => out_local_req(x, y),
                    out_local_data       => out_local_data(x, y)
                                  );
                               
                end generate;
    end generate;
    
end architecture rtl;