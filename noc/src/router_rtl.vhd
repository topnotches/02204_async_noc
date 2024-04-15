library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity router_rtl I
  generic
  (
    left   : std_logic;
    right  : std_logic;
    top    : std_logic;
    bottom : std_logic;
  );
  port
  (
    rst : in std_logic;

    -- Local Address
    in_local_address_x : in std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
    in_local_address_y : in std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');

    -- DIAGONAL INPUT CHANNELS

    in_north_east_ack  : out std_logic;
    in_north_east_req  : in std_logic;
    in_north_east_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_south_east_ack  : out std_logic;
    in_south_east_req  : in std_logic;
    in_south_east_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_south_west_ack  : out std_logic;
    in_south_west_req  : in std_logic;
    in_south_west_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- STRAIGTH INPUT CHANNELS
    in_north_ack  : out std_logic;
    in_north_req  : in std_logic;
    in_north_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_east_ack  : out std_logic;
    in_east_req  : in std_logic;
    in_east_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_south_ack  : out std_logic;
    in_south_req  : in std_logic;
    in_south_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_west_ack  : out std_logic;
    in_west_req  : in std_logic;
    in_west_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- DIAGONAL OUTPUT CHANNELS
    out_north_west_ack  : out std_logic;
    out_north_west_req  : in std_logic;
    out_north_west_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_north_east_ack  : out std_logic;
    out_north_east_req  : in std_logic;
    out_north_east_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_east_ack  : out std_logic;
    out_south_east_req  : in std_logic;
    out_south_east_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_west_ack  : out std_logic;
    out_south_west_req  : in std_logic;
    out_south_west_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- STRAIGHT OUTPUT CHANNELS
    out_north_ack  : out std_logic;
    out_north_req  : in std_logic;
    out_north_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_east_ack  : out std_logic;
    out_east_req  : in std_logic;
    out_east_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_ack  : out std_logic;
    out_south_req  : in std_logic;
    out_south_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_west_ack  : out std_logic;
    out_west_req  : in std_logic;
    out_west_data : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Output Local
    out_req_local  : out std_logic;
    out_data_local : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    out_ack_local  : in std_logic
  );
end entity router_rtl;

architecture rtl of router_rtl is

    -- NORTH STRAIGHT SIGNALS
    signal north_to_south_ack   : std_logic                                                       := '0';
    signal north_to_south_req   : std_logic                                                       := '0';
    signal north_to_south_data  : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    signal north_to_local_ack   : std_logic                                                       := '0';
    signal north_to_local_req   : std_logic                                                       := '0';
    signal north_to_local_data  : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    -- SOUTH STRAIGHT SIGNALS
    signal east_to_west_ack     : std_logic                                                       := '0';
    signal east_to_west_req     : std_logic                                                       := '0';
    signal east_to_west_data    : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    signal east_to_local_ack    : std_logic                                                       := '0';
    signal east_to_local_req    : std_logic                                                       := '0';
    signal east_to_local_data   : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    -- SOUTH STRAIGHT SIGNALS
    signal south_to_north_ack   : std_logic                                                       := '0';
    signal south_to_north_req   : std_logic                                                       := '0';
    signal south_to_north_data  : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    signal south_to_local_ack   : std_logic                                                       := '0';
    signal south_to_local_req   : std_logic                                                       := '0';
    signal south_to_local_data  : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    -- WEST  STRAIGHT SIGNALS
    signal west_to_east_ack     : std_logic                                                       := '0';
    signal west_to_east_req     : std_logic                                                       := '0';
    signal west_to_east_data    : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    signal west_to_local_ack    : std_logic                                                       := '0';
    signal west_to_local_req    : std_logic                                                       := '0';
    signal west_to_local_data   : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    -- SOUTH EAST INPUT SIGNALS
    signal south_east_to_north_west_ack     : std_logic                                                       := '0';
    signal south_east_to_north_west_req     : std_logic                                                       := '0';
    signal south_east_to_north_west_data    : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    signal south_east_to_north_ack          : std_logic                                                       := '0';
    signal south_east_to_north_req          : std_logic                                                       := '0';
    signal south_east_to_north_data         : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    signal south_east_to_west_ack           : std_logic                                                       := '0';
    signal south_east_to_west_req           : std_logic                                                       := '0';
    signal south_east_to_west_data          : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    signal south_east_to_local_ack          : std_logic                                                       := '0';
    signal south_east_to_local_req          : std_logic                                                       := '0';
    signal south_east_to_local_data         : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');

    -- NORTH EAST INPUT SIGNALS
    signal north_east_to_south_west_ack     : std_logic                                                       := '0';
    signal north_east_to_south_west_req     : std_logic                                                       := '0';
    signal north_east_to_south_west_data    : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
    
    signal north_east_to_south_ack          : std_logic                                                       := '0';
    signal north_east_to_south_req          : std_logic                                                       := '0';
    signal north_east_to_south_data         : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
    
    signal north_east_to_west_ack           : std_logic                                                       := '0';
    signal north_east_to_west_req           : std_logic                                                       := '0';
    signal north_east_to_west_data          : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
    
    signal north_east_to_local_ack          : std_logic                                                       := '0';
    signal north_east_to_local_req          : std_logic                                                       := '0';
    signal north_east_to_local_data         : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
    
    -- NORTH WEST INPUT SIGNALS
    signal north_west_to_south_east_ack     : std_logic                                                       := '0';
    signal north_west_to_south_east_req     : std_logic                                                       := '0';
    signal north_west_to_south_east_data    : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
        
    signal north_west_to_south_ack          : std_logic                                                       := '0';
    signal north_west_to_south_req          : std_logic                                                       := '0';
    signal north_west_to_south_data         : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
        
    signal north_west_to_east_ack           : std_logic                                                       := '0';
    signal north_west_to_east_req           : std_logic                                                       := '0';
    signal north_west_to_east_data          : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
        
    signal north_west_to_local_ack          : std_logic                                                       := '0';
    signal north_west_to_local_req          : std_logic                                                       := '0';
    signal north_west_to_local_data         : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
        
    -- SOUTH WEST INPUT SIGNALS
    signal south_west_to_north_east_ack     : std_logic                                                       := '0';
    signal south_west_to_north_east_req     : std_logic                                                       := '0';
    signal south_west_to_north_east_data    : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
        
    signal south_west_to_north_ack          : std_logic                                                       := '0';
    signal south_west_to_north_req          : std_logic                                                       := '0';
    signal south_west_to_north_data         : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
        
    signal south_west_to_east_ack           : std_logic                                                       := '0';
    signal south_west_to_east_req           : std_logic                                                       := '0';
    signal south_west_to_east_data          : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
        
    signal south_west_to_local_ack          : std_logic                                                       := '0';
    signal south_west_to_local_req          : std_logic                                                       := '0';
    signal south_west_to_local_data         : std_logic_vector(NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH - 1 downto 0) := (others => '0');
begin

    diagonal_south_east_input_component : entity work.diagonal_input(rtl)
    port map
    (
        rst => rst,
        in_local_address_x => in_local_address_x,
        in_local_address_y => in_local_address_y,
        in_ack => in_south_east_ack,
        in_req => in_south_east_req,
        in_data => in_south_east_data,

        -- Output Continue north west
        out_ack_continue => out_north_west_ack,
        out_req_continue => out_north_west_req,
        out_data_continue => out_north_west_data,
    
        -- Output West ???
        out_ack_we => out_west_ack,
        out_req_we => out_west_req,
        out_data_we => out_west_data,
    
        -- Output North ????
        out_ack_ns => out_north_ack,
        out_req_ns => out_north_req,
        out_data_ns => out_north_data
    
        -- Output Local
        out_req_local => out_ack_local,
        out_data_local => out_data_local,
        out_ack_local => out_ack_local
    );

  --    diagonal_output_generation: GENERATE
  --        location_sum = left + right + top + bottom;
  --
  --        if location_sum = 0 then
  --            -- Middle location
  --
  --        elsif location_sum = 1 then
  --            -- Edge location
  --            if left = 0 and top = 0 then
  --                -- North West Diagonal needed
  --
  --            elsif right = 0 and top = 0 then
  --                -- North East Diagonal needed
  --
  --            elsif right = 0 and bottom = 0 then
  --                -- South East Diagonal needed
  --
  --            elsif left = 0 and bottom = 0 then
  --                -- South West Diagonal needed
  --
  --            end if;
  --        else
  --            -- Corner location
  --            if left = 1 and top = 1 then
  --                -- North West Corner => South East Diagonal needed
  --
  --            elsif right = 1 and top = 1 then
  --                -- North East Corner => South West Diagonal needed
  --
  --            elsif left = 1 and bottom = 1 then
  --                -- South West Corner => North East Diagonal needed
  --
  --            else
  --                -- South East Corner => North West Diagonal needed
  --
  --            end if;
  --        end if;
  --    END GENERATE;
  


  --INPUTS

  generate_middle_router : generate

  end generate;

  generate_east_edge_router: generate

end generate;

generate_west_edge_router: generate

end generate;

generate_north_edge_router: generate

end generate;

generate_south_edge_router: generate

end generate;

generate_north_west_corner_router: generate

end generate;

generate_north_east_corner_router: generate

end generate;

generate_south_west_corner_router: generate

end generate;

generate_south_east_corner_router: generate

end generate;

  -- generate compare selectors
  DIAG_SE_INPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  DIAG_SW_INPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  DIAG_NW_INPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  --INPUTS

  -- generate compare selectors
  straight_NE_INPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  straight_SE_INPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  straight_SW_INPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  straight_NW_INPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );
  --output

  -- generate compare selectors
  DIAG_NE_OUTPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  DIAG_SE_OUTPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  DIAG_SW_OUTPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  DIAG_NW_OUTPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  --INPUTS

  -- generate compare selectors
  straight_NE_OUTPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  straight_SE_OUTPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  straight_SW_OUTPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

  straight_NW_OUTPUT : entity work.diagonal_input(rtl)
    port
    map
    (

    );

end architecture;