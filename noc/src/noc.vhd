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
    gen_x_axis: for y in 0 to NOC_MESH_LENGTH-1 generate
        
        begin
            gen_y_axis: for x in 0 to NOC_MESH_LENGTH - 1 generate
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
                 -- DIAGONAL INPUT CHANNELS
              in_north_east_ack   => mesh_diagnoals(y, x + 1).bottomleft_to_topright.ack,        
              in_north_east_req   => mesh_diagnoals(y, x + 1).bottomleft_to_topright.req,        
              in_north_east_data  => mesh_diagnoals(y, x + 1).bottomleft_to_topright.data,       

              in_north_west_ack   => mesh_diagnoals(y, x).bottomright_to_topleft.ack,
              in_north_west_req   => mesh_diagnoals(y, x).bottomright_to_topleft.req,     
              in_north_west_data  => mesh_diagnoals(y, x).bottomright_to_topleft.data,      

              in_south_east_ack   => mesh_diagnoals(y + 1, x + 1).topleft_to_bottomright.ack,        
              in_south_east_req   => mesh_diagnoals(y + 1, x + 1).topleft_to_bottomright.req,        
              in_south_east_data  => mesh_diagnoals(y + 1, x + 1).topleft_to_bottomright.data,       

              in_south_west_ack   => mesh_diagnoals(y + 1, x).topright_to_bottomleft.ack,      
              in_south_west_req   => mesh_diagnoals(y + 1, x).topright_to_bottomleft.req,        
              in_south_west_data  => mesh_diagnoals(y + 1, x).topright_to_bottomleft.data,       

              -- STRAIGTH INPUT CHANNELS
              in_north_ack        => mesh_verticals(y, x).bottom_to_top.ack,              
              in_north_req        => mesh_verticals(y, x).bottom_to_top.req,               
              in_north_data       => mesh_verticals(y, x).bottom_to_top.data,              

              in_east_ack         => mesh_horizontals(y, x + 1).left_to_right.ack,             
              in_east_req         => mesh_horizontals(y, x + 1).left_to_right.req,             
              in_east_data        => mesh_horizontals(y, x + 1).left_to_right.data,            

              in_south_ack        => mesh_verticals(y + 1, x).top_to_bottom.ack,               
              in_south_req        => mesh_verticals(y + 1, x).top_to_bottom.req,               
              in_south_data       => mesh_verticals(y + 1, x).top_to_bottom.data,              

              in_west_ack         => mesh_horizontals(y, x).right_to_left.ack,             
              in_west_req         => mesh_horizontals(y, x).right_to_left.req,             
              in_west_data        => mesh_horizontals(y, x).right_to_left.data,            

              -- DIAGONAL OUTPUT CHANNELS
              out_north_west_ack  => mesh_diagnoals(y, x).topleft_to_bottomright.ack,        
              out_north_west_req  => mesh_diagnoals(y, x).topleft_to_bottomright.req,       
              out_north_west_data => mesh_diagnoals(y, x).topleft_to_bottomright.data,      

              out_north_east_ack  => mesh_diagnoals(y, x + 1).topright_to_bottomleft.ack,        
              out_north_east_req  => mesh_diagnoals(y, x + 1).topright_to_bottomleft.req,        
              out_north_east_data => mesh_diagnoals(y, x + 1).topright_to_bottomleft.data,       

              out_south_east_ack  => mesh_diagnoals(y + 1, x + 1).bottomright_to_topleft.ack,
              out_south_east_req  => mesh_diagnoals(y + 1, x + 1).bottomright_to_topleft.req,        
              out_south_east_data => mesh_diagnoals(y + 1, x + 1).bottomright_to_topleft.data,       

              out_south_west_ack  => mesh_diagnoals(y + 1, x).bottomleft_to_topright.ack,      
              out_south_west_req  => mesh_diagnoals(y + 1, x).bottomleft_to_topright.req,       
              out_south_west_data => mesh_diagnoals(y + 1, x).bottomleft_to_topright.data,     

              -- STRAIGHT OUTPUT CHANNELS
              out_north_ack       => mesh_verticals(y, x).top_to_bottom.ack,             
              out_north_req       => mesh_verticals(y, x).top_to_bottom.req,                
              out_north_data      => mesh_verticals(y, x).top_to_bottom.data,                

              out_east_ack        => mesh_horizontals(y, x + 1).right_to_left.ack,
              out_east_req        => mesh_horizontals(y, x + 1).right_to_left.req,              
              out_east_data       => mesh_horizontals(y, x + 1).right_to_left.data,             

              out_south_ack       => mesh_verticals(y + 1, x).bottom_to_top.ack,                 
              out_south_req       => mesh_verticals(y + 1, x).bottom_to_top.req,                
              out_south_data      => mesh_verticals(y + 1, x).bottom_to_top.data,                

              out_west_ack        => mesh_horizontals(y, x).left_to_right.ack,              
              out_west_req        => mesh_horizontals(y, x).left_to_right.req,              
              out_west_data       => mesh_horizontals(y, x).left_to_right.data,

            -- LOCAL INPUT
            in_local_ack        => out_locals(y, x).ack,
            in_local_req        => in_locals(y, x).req,
            in_local_data       => in_locals(y, x).data,

            -- LOCAL OUTPUT
            out_local_ack        => in_locals(y, x).ack,
            out_local_req        => out_locals(y, x).req,
            out_local_data       => out_locals(y, x).data
                              );
                            
                end generate;
    end generate;
    
end architecture rtl;