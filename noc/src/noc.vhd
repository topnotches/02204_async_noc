library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;
use work.noc_connections_pkg.all;

entity noc_rtl is
    port (
        rst : in std_logic;
        in_locals : in noc_local_in;
        out_locals : out noc_local_out);
end entity noc_rtl;

architecture rtl of noc_rtl is


    signal mesh_diagnoals : arrif_diagonal_connections_t :=  (others => (others => (others => (ack => '0', req => '0', data => (others => '0')))));
    signal mesh_horizontals : arrif_horizontal_connections_t :=  (others => (others => (others => (ack => '0', req => '0', data => (others => '0')))));
    signal mesh_verticals : arrif_vertical_connections_t :=  (others => (others => (others => (ack => '0', req => '0', data => (others => '0')))));

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
    gen_x_axis: for x in 0 to NOC_MESH_LENGTH-1 generate
        
        begin
            gen_y_axis: for y in 0 to NOC_MESH_LENGTH - 1 generate
              signal in_north_east_ack   : std_logic;
              signal in_north_east_req   : std_logic;
              signal in_north_east_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal in_north_west_ack   : std_logic;
              signal in_north_west_req   : std_logic;
              signal in_north_west_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal in_south_east_ack   : std_logic;
              signal in_south_east_req   : std_logic;
              signal in_south_east_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal in_south_west_ack   : std_logic;
              signal in_south_west_req   : std_logic;
              signal in_south_west_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              -- STRAIGTH INPUT CHANNELS
              signal in_north_ack        : std_logic;
              signal in_north_req        : std_logic;
              signal in_north_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal in_east_ack         : std_logic;
              signal in_east_req         : std_logic;
              signal in_east_data        : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal in_south_ack        : std_logic;
              signal in_south_req        : std_logic;
              signal in_south_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal in_west_ack         : std_logic;
              signal in_west_req         : std_logic;
              signal in_west_data        : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

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
              signal out_north_ack       : std_logic;
              signal out_north_req       : std_logic;
              signal out_north_data      : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal out_east_ack        : std_logic;
              signal out_east_req        : std_logic;
              signal out_east_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal out_south_ack       : std_logic;
              signal out_south_req       : std_logic;
              signal out_south_data      : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

              signal out_west_ack        : std_logic;
              signal out_west_req        : std_logic;
              signal out_west_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
            begin
              -- DIAGONAL INPUT CHANNELS
              in_north_east_ack   <= '0'             when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x+1, y-1).topright_to_bottomleft.ack;
              in_north_east_req   <= '0'             when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x+1, y-1).topright_to_bottomleft.req;
              in_north_east_data  <= (others => '0') when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x+1, y-1).topright_to_bottomleft.data;

              in_north_west_ack   <= '0'             when ((y = 0) or (x = 0)) else mesh_diagnoals(x-1, y-1).topleft_to_bottomright.ack;
              in_north_west_req   <= '0'             when ((y = 0) or (x = 0)) else mesh_diagnoals(x-1, y-1).topleft_to_bottomright.req;
              in_north_west_data  <= (others => '0') when ((y = 0) or (x = 0)) else mesh_diagnoals(x-1, y-1).topleft_to_bottomright.data;

              in_south_east_ack   <= '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x+1, y+1).bottomright_to_topleft.ack;
              in_south_east_req   <= '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x+1, y+1).bottomright_to_topleft.req;
              in_south_east_data  <= (others => '0') when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x+1, y+1).bottomright_to_topleft.data;

              in_south_west_ack   <= '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else mesh_diagnoals(x-1, y+1).bottomleft_to_topright.ack;
              in_south_west_req   <= '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else mesh_diagnoals(x-1, y+1).bottomleft_to_topright.req;
              in_south_west_data  <= (others => '0') when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else mesh_diagnoals(x-1, y+1).bottomleft_to_topright.data;

              -- STRAIGTH INPUT CHANNELS
              in_north_ack        <= '0'             when (y = 0) else mesh_verticals(x, y-1).top_to_bottom.ack;
              in_north_req        <= '0'             when (y = 0) else mesh_verticals(x, y-1).top_to_bottom.req;
              in_north_data       <= (others => '0') when (y = 0) else mesh_verticals(x, y-1).top_to_bottom.data;

              in_east_ack         <= '0'             when (x = NOC_MESH_LENGTH - 1) else mesh_horizontals(x+1, y).right_to_left.ack;
              in_east_req         <= '0'             when (x = NOC_MESH_LENGTH - 1) else mesh_horizontals(x+1, y).right_to_left.req;
              in_east_data        <= (others => '0') when (x = NOC_MESH_LENGTH - 1) else mesh_horizontals(x+1, y).right_to_left.data;

              in_south_ack        <= '0'             when (y =  NOC_MESH_LENGTH - 1) else mesh_verticals(x, y+1).bottom_to_top.ack;
              in_south_req        <= '0'             when (y =  NOC_MESH_LENGTH - 1) else mesh_verticals(x, y+1).bottom_to_top.req;
              in_south_data       <= (others => '0') when (y =  NOC_MESH_LENGTH - 1) else mesh_verticals(x, y+1).bottom_to_top.data;

              in_west_ack         <= '0'             when (x = 0) else mesh_horizontals(x-1, y).left_to_right.ack;
              in_west_req         <= '0'             when (x = 0) else mesh_horizontals(x-1, y).left_to_right.req;
              in_west_data        <= (others => '0') when (x = 0) else mesh_horizontals(x-1, y).left_to_right.data;

              -- DIAGONAL OUTPUT CHANNELS
              out_north_west_ack  <= '0'             when ((y = 0) or (x = 0)) else mesh_diagnoals(x, y).bottomright_to_topleft.ack;
              out_north_west_req  <= '0'             when ((y = 0) or (x = 0)) else mesh_diagnoals(x, y).bottomright_to_topleft.req;
              out_north_west_data <= (others => '0') when ((y = 0) or (x = 0)) else mesh_diagnoals(x, y).bottomright_to_topleft.data;

              out_north_east_ack  <= '0'             when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x, y).bottomleft_to_topright.ack;
              out_north_east_req  <= '0'             when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x, y).bottomleft_to_topright.req;
              out_north_east_data <= (others => '0') when ((y = 0) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x, y).bottomleft_to_topright.data;

              out_south_east_ack  <= '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x, y).topleft_to_bottomright.ack;
              out_south_east_req  <= '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x, y).topleft_to_bottomright.req;
              out_south_east_data <= (others => '0') when ((y = NOC_MESH_LENGTH - 1) or (x = NOC_MESH_LENGTH - 1)) else mesh_diagnoals(x, y).topleft_to_bottomright.data;

              out_south_west_ack  <= '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else mesh_diagnoals(x, y).topright_to_bottomleft.ack;
              out_south_west_req  <= '0'             when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else mesh_diagnoals(x, y).topright_to_bottomleft.req;
              out_south_west_data <= (others => '0') when ((y = NOC_MESH_LENGTH - 1) or (x = 0)) else mesh_diagnoals(x, y).topright_to_bottomleft.data;

              -- STRAIGHT OUTPUT CHANNELS
              out_north_ack       <= '0'             when (y = 0) else mesh_verticals(x, y).bottom_to_top.ack;
              out_north_req       <= '0'             when (y = 0) else mesh_verticals(x, y).bottom_to_top.req;
              out_north_data      <= (others => '0') when (y = 0) else mesh_verticals(x, y).bottom_to_top.data;

              out_east_ack        <= '0'             when (x = NOC_MESH_LENGTH - 1) else mesh_horizontals(x, y).left_to_right.ack;
              out_east_req        <= '0'             when (x = NOC_MESH_LENGTH - 1) else mesh_horizontals(x, y).left_to_right.req;
              out_east_data       <= (others => '0') when (x = NOC_MESH_LENGTH - 1) else mesh_horizontals(x, y).left_to_right.data;

              out_south_ack       <= '0'             when (y =  NOC_MESH_LENGTH - 1) else mesh_verticals(x, y).top_to_bottom.ack;
              out_south_req       <= '0'             when (y =  NOC_MESH_LENGTH - 1) else mesh_verticals(x, y).top_to_bottom.req;
              out_south_data      <= (others => '0') when (y =  NOC_MESH_LENGTH - 1) else mesh_verticals(x, y).top_to_bottom.data;

              out_west_ack        <= '0'             when (x = 0) else mesh_horizontals(x, y).right_to_left.ack;
              out_west_req        <= '0'             when (x = 0) else mesh_horizontals(x, y).right_to_left.req;
              out_west_data       <= (others => '0') when (x = 0) else mesh_horizontals(x, y).right_to_left.data;

              mesh_node : entity work.router_rtl(rtl)
              generic map (
                left => left(x),
                right => right(x),
                top => top(y),
                bottom => bottom(y),
                address_x => std_logic_vector(to_unsigned(x, NOC_ADDRESS_WIDTH)),
                address_y => std_logic_vector(to_unsigned(y, NOC_ADDRESS_WIDTH))
              )
              port 
              map (
                rst => rst,
                -- DIAGONAL INPUT CHANNELS
                in_north_east_ack   => in_north_east_ack,
                in_north_east_req   => in_north_east_req,
                in_north_east_data  => in_north_east_data,

                in_north_west_ack   => in_north_west_ack,
                in_north_west_req   => in_north_west_req,
                in_north_west_data  => in_north_west_data,

                in_south_east_ack   => in_south_east_ack,
                in_south_east_req   =>  in_south_east_req,
                in_south_east_data  => in_south_east_data,

                in_south_west_ack   => in_south_west_ack,
                in_south_west_req   => in_south_west_req,
                in_south_west_data  => in_south_west_data,

                -- STRAIGTH INPUT CHANNELS
                in_north_ack        => in_north_ack,
                in_north_req        => in_north_req,
                in_north_data       => in_north_data,

                in_east_ack         => in_east_ack,
                in_east_req         => in_east_req,
                in_east_data        => in_east_data,

                in_south_ack        => in_south_ack,
                in_south_req        => in_south_req,
                in_south_data       => in_south_data,

                in_west_ack         => in_west_ack,
                in_west_req         => in_west_req,
                in_west_data        => in_west_data,

                -- DIAGONAL OUTPUT CHANNELS
                out_north_west_ack  => out_north_west_ack,
                out_north_west_req  => out_north_west_req,
                out_north_west_data =>  out_north_west_data,

                out_north_east_ack  => out_north_east_ack,
                out_north_east_req  => out_north_east_req,
                out_north_east_data => out_north_east_data,

                out_south_east_ack  => out_south_east_ack,
                out_south_east_req  => out_south_east_req,
                out_south_east_data => out_south_east_data,

                out_south_west_ack  => out_south_west_ack,
                out_south_west_req  => out_south_west_req,
                out_south_west_data => out_south_west_data,

                -- STRAIGHT OUTPUT CHANNELS
                out_north_ack       => out_north_ack,
                out_north_req       => out_north_req,
                out_north_data      => out_north_data,

                out_east_ack        => out_east_ack,
                out_east_req        => out_east_req,
                out_east_data       => out_east_data,

                out_south_ack       => out_south_ack,
                out_south_req       => out_south_req,
                out_south_data      => out_south_data,

                out_west_ack        => out_west_ack,
                out_west_req        => out_west_req,
                out_west_data       => out_west_data,

                -- LOCAL INPUT
                in_local_ack        => out_locals(x, y).ack,
                in_local_req        => in_locals(x, y).req,
                in_local_data       => in_locals(x, y).data,

                -- LOCAL OUTPUT
                out_local_ack        => in_locals(x, y).ack,
                out_local_req        => out_locals(x, y).req,
                out_local_data       => out_locals(x, y).data
                              );
                            
                end generate;
    end generate;
    
end architecture rtl;