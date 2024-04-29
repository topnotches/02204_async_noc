library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;

entity router_rtl IS
  generic
  (
    left            : std_logic     := '0';
    right           : std_logic     := '0';
    top             : std_logic     := '0';
    bottom          : std_logic     := '0';
    address_x       : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
    address_y       : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0')
  );
  port
  (
    rst : in std_logic;

    -- DIAGONAL INPUT CHANNELS
    in_north_east_ack   : out std_logic;
    in_north_east_req   : in std_logic;
    in_north_east_data  : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_north_west_ack   : out std_logic;
    in_north_west_req   : in std_logic;
    in_north_west_data  : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_south_east_ack   : out std_logic;
    in_south_east_req   : in std_logic;
    in_south_east_data  : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_south_west_ack   : out std_logic;
    in_south_west_req   : in std_logic;
    in_south_west_data  : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- STRAIGTH INPUT CHANNELS
    in_north_ack        : out std_logic;
    in_north_req        : in std_logic;
    in_north_data       : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_east_ack         : out std_logic;
    in_east_req         : in std_logic;
    in_east_data        : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_south_ack        : out std_logic;
    in_south_req        : in std_logic;
    in_south_data       : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_west_ack         : out std_logic;
    in_west_req         : in std_logic;
    in_west_data        : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- DIAGONAL OUTPUT CHANNELS
    out_north_west_ack  : in std_logic;
    out_north_west_req  : out std_logic;
    out_north_west_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_north_east_ack  : in std_logic;
    out_north_east_req  : out std_logic;
    out_north_east_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_east_ack  : in std_logic;
    out_south_east_req  : out std_logic;
    out_south_east_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_west_ack  : in std_logic;
    out_south_west_req  : out std_logic;
    out_south_west_data : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- STRAIGHT OUTPUT CHANNELS
    out_north_ack       : in std_logic;
    out_north_req       : out std_logic;
    out_north_data      : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_east_ack        : in std_logic;
    out_east_req        : out std_logic;
    out_east_data       : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_ack       : in std_logic;
    out_south_req       : out std_logic;
    out_south_data      : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_west_ack        : in std_logic;
    out_west_req        : out std_logic;
    out_west_data       : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Output of components to local ports
    out_north_to_local_ack        : in std_logic;
    out_north_to_local_req        : out std_logic;
    out_north_to_local_data       : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_east_to_local_ack         : in std_logic;
    out_east_to_local_req         : out std_logic;
    out_east_to_local_data        : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_to_local_ack        : in std_logic;
    out_south_to_local_req        : out std_logic;
    out_south_to_local_data       : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_west_to_local_ack         : in std_logic;
    out_west_to_local_req         : out std_logic;
    out_west_to_local_data        : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_east_to_local_ack   : in std_logic;
    out_south_east_to_local_req   : out std_logic;
    out_south_east_to_local_data  : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_north_east_to_local_ack   : in std_logic;
    out_north_east_to_local_req   : out std_logic;
    out_north_east_to_local_data  : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_north_west_to_local_ack   : in std_logic;
    out_north_west_to_local_req   : out std_logic;
    out_north_west_to_local_data  : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    out_south_west_to_local_ack   : in std_logic;
    out_south_west_to_local_req   : out std_logic;
    out_south_west_to_local_data  : out std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    -- Input for local ports to componenets
    in_local_to_north_ack         : out std_logic;
    in_local_to_north_req         : in std_logic;
    in_local_to_north_data        : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_local_to_east_ack          : out std_logic;
    in_local_to_east_req          : in std_logic;
    in_local_to_east_data         : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_local_to_south_ack         : out std_logic;
    in_local_to_south_req         : in std_logic;
    in_local_to_south_data        : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_local_to_west_ack          : out std_logic;
    in_local_to_west_req          : in std_logic;
    in_local_to_west_data         : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_local_to_south_east_ack    : out std_logic;
    in_local_to_south_east_req    : in std_logic;
    in_local_to_south_east_data   : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_local_to_north_east_ack    : out std_logic;
    in_local_to_north_east_req    : in std_logic;
    in_local_to_north_east_data   : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_local_to_north_west_ack    : out std_logic;
    in_local_to_north_west_req    : in std_logic;
    in_local_to_north_west_data   : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);

    in_local_to_south_west_ack    : out std_logic;
    in_local_to_south_west_req    : in std_logic;
    in_local_to_south_west_data   : in std_logic_vector(NOC_DATA_WIDTH - 1 downto 0)
  );
end entity router_rtl;

architecture rtl of router_rtl is

    -- NORTH STRAIGHT SIGNALS
    signal north_to_south_ack   : std_logic                                                       := '0';
    signal north_to_south_req   : std_logic                                                       := '0';
    signal north_to_south_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal north_to_local_ack   : std_logic                                                       := '0';
    signal north_to_local_req   : std_logic                                                       := '0';
    signal north_to_local_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- EAST STRAIGHT SIGNALS
    signal east_to_west_ack     : std_logic                                                       := '0';
    signal east_to_west_req     : std_logic                                                       := '0';
    signal east_to_west_data    : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal east_to_local_ack    : std_logic                                                       := '0';
    signal east_to_local_req    : std_logic                                                       := '0';
    signal east_to_local_data   : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- SOUTH STRAIGHT SIGNALS
    signal south_to_north_ack   : std_logic                                                       := '0';
    signal south_to_north_req   : std_logic                                                       := '0';
    signal south_to_north_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal south_to_local_ack   : std_logic                                                       := '0';
    signal south_to_local_req   : std_logic                                                       := '0';
    signal south_to_local_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- WEST  STRAIGHT SIGNALS
    signal west_to_east_ack     : std_logic                                                       := '0';
    signal west_to_east_req     : std_logic                                                       := '0';
    signal west_to_east_data    : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal west_to_local_ack    : std_logic                                                       := '0';
    signal west_to_local_req    : std_logic                                                       := '0';
    signal west_to_local_data   : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- SOUTH EAST INPUT SIGNALS
    signal south_east_to_north_west_ack     : std_logic                                                       := '0';
    signal south_east_to_north_west_req     : std_logic                                                       := '0';
    signal south_east_to_north_west_data    : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal south_east_to_north_ack          : std_logic                                                       := '0';
    signal south_east_to_north_req          : std_logic                                                       := '0';
    signal south_east_to_north_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal south_east_to_west_ack           : std_logic                                                       := '0';
    signal south_east_to_west_req           : std_logic                                                       := '0';
    signal south_east_to_west_data          : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal south_east_to_local_ack          : std_logic                                                       := '0';
    signal south_east_to_local_req          : std_logic                                                       := '0';
    signal south_east_to_local_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- NORTH EAST INPUT SIGNALS
    signal north_east_to_south_west_ack     : std_logic                                                       := '0';
    signal north_east_to_south_west_req     : std_logic                                                       := '0';
    signal north_east_to_south_west_data    : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal north_east_to_south_ack          : std_logic                                                       := '0';
    signal north_east_to_south_req          : std_logic                                                       := '0';
    signal north_east_to_south_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal north_east_to_west_ack           : std_logic                                                       := '0';
    signal north_east_to_west_req           : std_logic                                                       := '0';
    signal north_east_to_west_data          : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal north_east_to_local_ack          : std_logic                                                       := '0';
    signal north_east_to_local_req          : std_logic                                                       := '0';
    signal north_east_to_local_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    -- NORTH WEST INPUT SIGNALS
    signal north_west_to_south_east_ack     : std_logic                                                       := '0';
    signal north_west_to_south_east_req     : std_logic                                                       := '0';
    signal north_west_to_south_east_data    : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
        
    signal north_west_to_south_ack          : std_logic                                                       := '0';
    signal north_west_to_south_req          : std_logic                                                       := '0';
    signal north_west_to_south_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
        
    signal north_west_to_east_ack           : std_logic                                                       := '0';
    signal north_west_to_east_req           : std_logic                                                       := '0';
    signal north_west_to_east_data          : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
        
    signal north_west_to_local_ack          : std_logic                                                       := '0';
    signal north_west_to_local_req          : std_logic                                                       := '0';
    signal north_west_to_local_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
        
    -- SOUTH WEST INPUT SIGNALS
    signal south_west_to_north_east_ack     : std_logic                                                       := '0';
    signal south_west_to_north_east_req     : std_logic                                                       := '0';
    signal south_west_to_north_east_data    : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
        
    signal south_west_to_north_ack          : std_logic                                                       := '0';
    signal south_west_to_north_req          : std_logic                                                       := '0';
    signal south_west_to_north_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
        
    signal south_west_to_east_ack           : std_logic                                                       := '0';
    signal south_west_to_east_req           : std_logic                                                       := '0';
    signal south_west_to_east_data          : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
        
    signal south_west_to_local_ack          : std_logic                                                       := '0';
    signal south_west_to_local_req          : std_logic                                                       := '0';
    signal south_west_to_local_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- LOCAL OUTPUT SIGNALS
    signal local_to_north_ack               : std_logic                                                       := '0';
    signal local_to_north_req               : std_logic                                                       := '0';
    signal local_to_north_data              : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal local_to_east_ack                : std_logic                                                       := '0';
    signal local_to_east_req                : std_logic                                                       := '0';
    signal local_to_east_data               : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal local_to_south_ack               : std_logic                                                       := '0';
    signal local_to_south_req               : std_logic                                                       := '0';
    signal local_to_south_data              : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal local_to_west_ack                : std_logic                                                       := '0';
    signal local_to_west_req                : std_logic                                                       := '0';
    signal local_to_west_data               : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal local_to_south_east_ack          : std_logic                                                       := '0';
    signal local_to_south_east_req          : std_logic                                                       := '0';
    signal local_to_south_east_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal local_to_north_east_ack          : std_logic                                                       := '0';
    signal local_to_north_east_req          : std_logic                                                       := '0';
    signal local_to_north_east_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal local_to_north_west_ack          : std_logic                                                       := '0';
    signal local_to_north_west_req          : std_logic                                                       := '0';
    signal local_to_north_west_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    signal local_to_south_west_ack          : std_logic                                                       := '0';
    signal local_to_south_west_req          : std_logic                                                       := '0';
    signal local_to_south_west_data         : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

begin
  -- Output of components to local ports connection to signals
  north_to_local_ack           <= out_north_to_local_ack;
  out_north_to_local_req       <= north_to_local_req; 
  out_north_to_local_data      <= north_to_local_data;

  east_to_local_ack            <= out_east_to_local_ack;
  out_east_to_local_req        <= east_to_local_req; 
  out_east_to_local_data       <= east_to_local_data;

  south_to_local_ack           <= out_south_to_local_ack;
  out_south_to_local_req       <= south_to_local_req; 
  out_south_to_local_data      <= south_to_local_data;

  west_to_local_ack            <= out_west_to_local_ack;
  out_west_to_local_req        <= west_to_local_req; 
  out_west_to_local_data       <= west_to_local_data;

  south_east_to_local_ack      <= out_south_east_to_local_ack;
  out_south_east_to_local_req  <= south_east_to_local_req; 
  out_south_east_to_local_data <= south_east_to_local_data;

  north_east_to_local_ack      <= out_north_east_to_local_ack;
  out_north_east_to_local_req  <= north_east_to_local_req; 
  out_north_east_to_local_data <= north_east_to_local_data;

  north_west_to_local_ack      <= out_north_west_to_local_ack;
  out_north_west_to_local_req  <= north_west_to_local_req; 
  out_north_west_to_local_data <= north_west_to_local_data;

  south_west_to_local_ack      <= out_south_west_to_local_ack;
  out_south_west_to_local_req  <= south_west_to_local_req; 
  out_south_west_to_local_data <= south_west_to_local_data;

  -- Input for local ports to componenets connection to signals
  in_local_to_north_ack        <= local_to_north_ack;
  local_to_north_req           <= in_local_to_north_req;
  local_to_north_data          <= in_local_to_north_data;

  in_local_to_east_ack         <= local_to_east_ack;
  local_to_east_req            <= in_local_to_east_req;
  local_to_east_data           <= in_local_to_east_data;

  in_local_to_south_ack        <= local_to_south_ack;
  local_to_south_req           <= in_local_to_south_req;
  local_to_south_data          <= in_local_to_south_data; 

  in_local_to_west_ack         <= local_to_west_ack;
  local_to_west_req            <= in_local_to_west_req;  
  local_to_west_data           <= in_local_to_west_data;

  in_local_to_south_east_ack   <= local_to_south_east_ack;
  local_to_south_east_req      <= in_local_to_south_east_req; 
  local_to_south_east_data     <= in_local_to_south_east_data;  

  in_local_to_north_east_ack   <= local_to_north_east_ack;
  local_to_north_east_req      <= in_local_to_north_east_req; 
  local_to_north_east_data     <= in_local_to_north_east_data;  

  in_local_to_north_west_ack   <= local_to_north_west_ack;
  local_to_north_west_req      <= in_local_to_north_west_req;
  local_to_north_west_data     <= in_local_to_north_west_data;

  in_local_to_south_west_ack   <= local_to_south_west_ack;
  local_to_south_west_req      <= in_local_to_south_west_req;
  local_to_south_west_data     <= in_local_to_south_west_data;

  middle_router: 
  if left = '0' and right = '0' and top = '0' and bottom = '0' generate
    -- Generate Middle router
    -- Diagonal inputs
    south_east_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_south_east_ack,
      in_req                => in_south_east_req,
      in_data               => in_south_east_data,
      -- Output Continue north west
      out_ack_continue      => south_east_to_north_west_ack,
      out_req_continue      => south_east_to_north_west_req,
      out_data_continue     => south_east_to_north_west_data,
      -- Output West
      out_ack_we            => south_east_to_west_ack,
      out_req_we            => south_east_to_west_req,
      out_data_we           => south_east_to_west_data,
      -- Output North
      out_ack_ns            => south_east_to_north_ack,
      out_req_ns            => south_east_to_north_req,
      out_data_ns           => south_east_to_north_data,
      -- Output Local
      out_ack_local         => south_east_to_local_ack,
      out_req_local         => south_east_to_local_req,
      out_data_local        => south_east_to_local_data
    );
    north_east_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_north_east_ack,
      in_req                => in_north_east_req,
      in_data               => in_north_east_data,
      -- Output continue south west
      out_ack_continue      => north_east_to_south_west_ack,
      out_req_continue      => north_east_to_south_west_req,
      out_data_continue     => north_east_to_south_west_data,
      -- Output West
      out_ack_we            => north_east_to_west_ack,
      out_req_we            => north_east_to_west_req,
      out_data_we           => north_east_to_west_data,
      -- Output South
      out_ack_ns            => north_east_to_south_ack,
      out_req_ns            => north_east_to_south_req,
      out_data_ns           => north_east_to_south_data,
      -- Output Local
      out_ack_local         => north_east_to_local_ack,
      out_req_local         => north_east_to_local_req,
      out_data_local        => north_east_to_local_data
    );
    north_west_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_north_west_ack,
      in_req                => in_north_west_req,
      in_data               => in_north_west_data,
      -- Output continue south east
      out_ack_continue      => north_west_to_south_east_ack,
      out_req_continue      => north_west_to_south_east_req,
      out_data_continue     => north_west_to_south_east_data,
      -- Output East
      out_ack_we            => north_west_to_east_ack,
      out_req_we            => north_west_to_east_req,
      out_data_we           => north_west_to_east_data,
      -- Output South
      out_ack_ns            => north_west_to_south_ack,
      out_req_ns            => north_west_to_south_req,
      out_data_ns           => north_west_to_south_data,
      -- Output Local
      out_ack_local         => north_west_to_local_ack,
      out_req_local         => north_west_to_local_req,
      out_data_local        => north_west_to_local_data
    );
    south_west_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_south_west_ack,
      in_req                => in_south_west_req,
      in_data               => in_south_west_data,
      -- Output continue south east
      out_ack_continue      => south_west_to_north_east_ack,
      out_req_continue      => south_west_to_north_east_req,
      out_data_continue     => south_west_to_north_east_data,
      -- Output East
      out_ack_we            => south_west_to_east_ack,
      out_req_we            => south_west_to_east_req,
      out_data_we           => south_west_to_east_data,
      -- Output South
      out_ack_ns            => south_west_to_north_ack,
      out_req_ns            => south_west_to_north_req,
      out_data_ns           => south_west_to_north_data,
      -- Output Local
      out_ack_local         => south_west_to_local_ack,
      out_req_local         => south_west_to_local_req,
      out_data_local        => south_west_to_local_data
    );

    -- Straigth inputs
    north_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_north_ack,
      in_req                => in_north_req,
      in_data               => in_north_data,
      -- Output continue south
      out_ack_continue      => north_to_south_ack,
      out_req_continue      => north_to_south_req,
      out_data_continue     => north_to_south_data,
      -- Output Local
      out_ack_local         => north_to_local_ack,
      out_req_local         => north_to_local_req,
      out_data_local        => north_to_local_data
    );
    east_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_east_ack,
      in_req                => in_east_req,
      in_data               => in_east_data,
      -- Output continue west
      out_ack_continue      => east_to_west_ack,
      out_req_continue      => east_to_west_req,
      out_data_continue     => east_to_west_data,
      -- Output Local
      out_ack_local         => east_to_local_ack,
      out_req_local         => east_to_local_req,
      out_data_local        => east_to_local_data
    );
    south_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_south_ack,
      in_req                => in_south_req,
      in_data               => in_south_data,
      -- Output continue north
      out_ack_continue      => south_to_north_ack,
      out_req_continue      => south_to_north_req,
      out_data_continue     => south_to_north_data,
      -- Output Local
      out_ack_local         => north_to_local_ack,
      out_req_local         => north_to_local_req,
      out_data_local        => north_to_local_data
    );
    west_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_west_ack,
      in_req                => in_west_req,
      in_data               => in_west_data,
      -- Output continue east
      out_ack_continue      => west_to_east_ack,
      out_req_continue      => west_to_east_req,
      out_data_continue     => west_to_east_data,
      -- Output Local
      out_ack_local         => west_to_local_ack,
      out_req_local         => west_to_local_req,
      out_data_local        => west_to_local_data
    );

    -- Diagonal outputs
    south_east_output : entity work.output_2_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Diagonal input channel
      in_ack_0            => north_west_to_south_east_ack,
      in_req_0            => north_west_to_south_east_req,
      in_data_0           => north_west_to_south_east_data,
      -- Local input channel
      in_ack_1            => local_to_south_east_ack,
      in_req_1            => local_to_south_east_req,
      in_data_1           => local_to_south_east_data,
      -- Output channel
      out_ack             => out_south_east_ack,
      out_req             => out_south_east_req,
      out_data            => out_south_east_data
    );
    north_east_output : entity work.output_2_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Diagonal input channel
      in_ack_0            => south_west_to_north_east_ack,
      in_req_0            => south_west_to_north_east_req,
      in_data_0           => south_west_to_north_east_data,
      -- Local input channel
      in_ack_1            => local_to_north_east_ack,
      in_req_1            => local_to_north_east_req,
      in_data_1           => local_to_north_east_data,
      -- Output channel
      out_ack             => out_north_east_ack,
      out_req             => out_north_east_req,
      out_data            => out_north_east_data
    );
    north_west_output : entity work.output_2_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Diagonal input channel
      in_ack_0            => south_east_to_north_west_ack,
      in_req_0            => south_east_to_north_west_req,
      in_data_0           => south_east_to_north_west_data,
      -- Local input channel
      in_ack_1            => local_to_north_west_ack,
      in_req_1            => local_to_north_west_req,
      in_data_1           => local_to_north_west_data,
      -- Output channel
      out_ack             => out_north_west_ack,
      out_req             => out_north_west_req,
      out_data            => out_north_west_data
    );
    south_west_output : entity work.output_2_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Diagonal input channel
      in_ack_0            => north_east_to_south_west_ack,
      in_req_0            => north_east_to_south_west_req,
      in_data_0           => north_east_to_south_west_data,
      -- Local input channel
      in_ack_1            => local_to_south_west_ack,
      in_req_1            => local_to_south_west_req,
      in_data_1           => local_to_south_west_data,
      -- Output channel
      out_ack             => out_south_west_ack,
      out_req             => out_south_west_req,
      out_data            => out_south_west_data
    );
        
    -- Straight outputs
    north_output : entity work.output_4_inputs(rtl)
    port map
    (
      rst          => rst,
      -- Straight continue input channel
      in_ack_0     => south_to_north_ack,
      in_req_0     => south_to_north_req,
      in_data_0    => south_to_north_data,
      -- Local input channel
      in_ack_1     => local_to_north_ack,
      in_req_1     => local_to_north_req,
      in_data_1    => local_to_north_data,
      -- Right diagonal input channel (Looking in the direaction out of the output)
      in_ack_2     => south_east_to_north_ack,
      in_req_2     => south_east_to_north_req,
      in_data_2    => south_east_to_north_data,
      -- Left diagonal input channel (Looking in the direaction out of the output)
      in_ack_3     => south_west_to_north_ack,
      in_req_3     => south_west_to_north_req,
      in_data_3    => south_west_to_north_data,
      -- Output channel
      out_ack      => out_north_ack,
      out_req      => out_north_req,
      out_data     => out_north_data
    );
    east_output : entity work.output_4_inputs(rtl)
    port map
    (
      rst          => rst,
      -- Straight continue input channel
      in_ack_0     => west_to_east_ack,
      in_req_0     => west_to_east_req,
      in_data_0    => west_to_east_data,
      -- Local input channel
      in_ack_1     => local_to_east_ack,
      in_req_1     => local_to_east_req,
      in_data_1    => local_to_east_data,
      -- Right diagonal input channel (Looking in the direaction out of the output)
      in_ack_2     => south_west_to_east_ack,
      in_req_2     => south_west_to_east_req,
      in_data_2    => south_west_to_east_data,
      -- Left diagonal input channel (Looking in the direaction out of the output)
      in_ack_3     => north_west_to_east_ack,
      in_req_3     => north_west_to_east_req,
      in_data_3    => north_west_to_east_data,
      -- Output channel
      out_ack      => out_east_ack,
      out_req      => out_east_req,
      out_data     => out_east_data
    );
    south_output : entity work.output_4_inputs(rtl)
    port map
    (
      rst          => rst,
      -- Straight continue input channel
      in_ack_0     => north_to_south_ack,
      in_req_0     => north_to_south_req,
      in_data_0    => north_to_south_data,
      -- Local input channel
      in_ack_1     => local_to_south_ack,
      in_req_1     => local_to_south_req,
      in_data_1    => local_to_south_data,
      -- Right diagonal input channel (Looking in the direaction out of the output)
      in_ack_2     => north_west_to_south_ack,
      in_req_2     => north_west_to_south_req,
      in_data_2    => north_west_to_south_data,
      -- Left diagonal input channel (Looking in the direaction out of the output)
      in_ack_3     => north_east_to_south_ack,
      in_req_3     => north_east_to_south_req,
      in_data_3    => north_east_to_south_data,
      -- Output channel
      out_ack      => out_south_ack,
      out_req      => out_south_req,
      out_data     => out_south_data
    );
    west_output : entity work.output_4_inputs(rtl)
    port map
    (
      rst          => rst,
      -- Straight continue input channel
      in_ack_0     => east_to_west_ack,
      in_req_0     => east_to_west_req,
      in_data_0    => east_to_west_data,
      -- Local input channel
      in_ack_1     => local_to_west_ack,
      in_req_1     => local_to_west_req,
      in_data_1    => local_to_west_data,
      -- Right diagonal input channel (Looking in the direaction out of the output)
      in_ack_2     => north_east_to_west_ack,
      in_req_2     => north_east_to_west_req,
      in_data_2    => north_east_to_west_data,
      -- Left diagonal input channel (Looking in the direaction out of the output)
      in_ack_3     => south_east_to_west_ack,
      in_req_3     => south_east_to_west_req,
      in_data_3    => south_east_to_west_data,
      -- Output channel
      out_ack      => out_south_ack,
      out_req      => out_south_req,
      out_data     => out_south_data
    );
  end generate middle_router;
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  north_edge_router: 
    if left = '0' and right = '0' and top = '1' and bottom = '0' generate
    -- Generate North Edge router
    -- Diagonal inputs
    south_west_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_south_west_ack,
      in_req                => in_south_west_req,
      in_data               => in_south_west_data,
      -- Output continue south east
      out_ack_continue      => south_west_to_local_ack,
      out_req_continue      => south_west_to_local_req,
      out_data_continue     => south_west_to_local_data,
      -- Output East
      out_ack_we            => south_west_to_east_ack,
      out_req_we            => south_west_to_east_req,
      out_data_we           => south_west_to_east_data,
      -- Output North
      out_ack_ns            => south_west_to_local_ack,
      out_req_ns            => south_west_to_local_req,
      out_data_ns           => south_west_to_local_data,
      -- Output Local
      out_ack_local         => south_west_to_local_ack,
      out_req_local         => south_west_to_local_req,
      out_data_local        => south_west_to_local_data
    );
    south_east_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_south_east_ack,
      in_req                => in_south_east_req,
      in_data               => in_south_east_data,
      -- Output continue south east
      out_ack_continue      => south_east_to_local_ack,
      out_req_continue      => south_east_to_local_req,
      out_data_continue     => south_east_to_local_data,
      -- Output West
      out_ack_we            => south_east_to_west_ack,
      out_req_we            => south_east_to_west_req,
      out_data_we           => south_east_to_west_data,
      -- Output North
      out_ack_ns            => south_east_to_local_ack,
      out_req_ns            => south_east_to_local_req,
      out_data_ns           => south_east_to_local_data,
      -- Output Local
      out_ack_local         => south_east_to_local_ack,
      out_req_local         => south_east_to_local_req,
      out_data_local        => south_east_to_local_data
    );

    -- Straight inputs
    west_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_west_ack,
      in_req                => in_west_req,
      in_data               => in_west_data,
      -- Output continue east
      out_ack_continue      => west_to_east_ack,
      out_req_continue      => west_to_east_req,
      out_data_continue     => west_to_east_data,
      -- Output Local
      out_ack_local         => west_to_local_ack,
      out_req_local         => west_to_local_req,
      out_data_local        => west_to_local_data
    );
    east_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_east_ack,
      in_req                => in_east_req,
      in_data               => in_east_data,
      -- Output continue east
      out_ack_continue      => east_to_west_ack,
      out_req_continue      => east_to_west_req,
      out_data_continue     => east_to_west_data,
      -- Output Local
      out_ack_local         => east_to_local_ack,
      out_req_local         => east_to_local_req,
      out_data_local        => east_to_local_data
    );
    south_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_south_ack,
      in_req                => in_south_req,
      in_data               => in_south_data,
      -- Output continue east
      out_ack_continue      => south_to_local_ack,
      out_req_continue      => south_to_local_req,
      out_data_continue     => south_to_local_data,
      -- Output Local
      out_ack_local         => south_to_local_ack,
      out_req_local         => south_to_local_req,
      out_data_local        => south_to_local_data
    );

    -- Diagonal outputs
    south_west_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_south_west_ack,
      in_req              => local_to_south_west_req,
      in_data             => local_to_south_west_data,
      -- Output channel
      out_ack             => out_south_west_ack,
      out_req             => out_south_west_req,
      out_data            => out_south_west_data
    );
    south_east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_south_east_ack,
      in_req              => local_to_south_east_req,
      in_data             => local_to_south_east_data,
      -- Output channel
      out_ack             => out_south_east_ack,
      out_req             => out_south_east_req,
      out_data            => out_south_east_data
    );

    -- Straight outputs
    west_output : entity work.output_3_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Straight continue input channel
      in_ack_0            => east_to_west_ack,
      in_req_0            => east_to_west_req,
      in_data_0           => east_to_west_data,
      -- Local input channel
      in_ack_1            => local_to_west_ack,
      in_req_1            => local_to_west_req,
      in_data_1           => local_to_west_data,
      -- Left diagonal input channel (Looking in the direaction out of the output)
      in_ack_2            => south_east_to_west_ack,
      in_req_2            => south_east_to_west_req,
      in_data_2           => south_east_to_west_data,
      -- Output channel
      out_ack             => out_west_ack,
      out_req             => out_west_req,
      out_data            => out_west_data
    );
    east_output : entity work.output_3_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Straight continue input channel
      in_ack_0            => west_to_east_ack,
      in_req_0            => west_to_east_req,
      in_data_0           => west_to_east_data,
      -- Local input channel
      in_ack_1            => local_to_east_ack,
      in_req_1            => local_to_east_req,
      in_data_1           => local_to_east_data,
      -- Right diagonal input channel (Looking in the direaction out of the output)
      in_ack_2            => south_west_to_east_ack,
      in_req_2            => south_west_to_east_req,
      in_data_2           => south_west_to_east_data,
      -- Output channel
      out_ack             => out_east_ack,
      out_req             => out_east_req,
      out_data            => out_east_data
    );
    south_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_south_ack,
      in_req              => local_to_south_req,
      in_data             => local_to_south_data,
      -- Output channel
      out_ack             => out_south_ack,
      out_req             => out_south_req,
      out_data            => out_south_data
    );
  end generate north_edge_router;
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  east_edge_router: 
    if left = '0' and right = '1' and top = '0' and bottom = '0' generate
    -- Generate East Edge router
    -- Diagonal inputs
    north_west_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_north_west_ack,
      in_req                => in_north_west_req,
      in_data               => in_north_west_data,
      -- Output continue south east
      out_ack_continue      => north_west_to_local_ack,
      out_req_continue      => north_west_to_local_req,
      out_data_continue     => north_west_to_local_data,
      -- Output East
      out_ack_we            => north_west_to_local_ack,
      out_req_we            => north_west_to_local_req,
      out_data_we           => north_west_to_local_data,
      -- Output North
      out_ack_ns            => north_west_to_south_ack,
      out_req_ns            => north_west_to_south_req,
      out_data_ns           => north_west_to_south_data,
      -- Output Local
      out_ack_local         => north_west_to_local_ack,
      out_req_local         => north_west_to_local_req,
      out_data_local        => north_west_to_local_data
    );
    south_west_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_south_west_ack,
      in_req                => in_south_west_req,
      in_data               => in_south_west_data,
      -- Output continue south east
      out_ack_continue      => south_west_to_local_ack,
      out_req_continue      => south_west_to_local_req,
      out_data_continue     => south_west_to_local_data,
      -- Output West
      out_ack_we            => south_west_to_local_ack,
      out_req_we            => south_west_to_local_req,
      out_data_we           => south_west_to_local_data,
      -- Output North
      out_ack_ns            => south_west_to_north_ack,
      out_req_ns            => south_west_to_north_req,
      out_data_ns           => south_west_to_north_data,
      -- Output Local
      out_ack_local         => south_west_to_local_ack,
      out_req_local         => south_west_to_local_req,
      out_data_local        => south_west_to_local_data
    );

    -- Straight inputs
    north_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_north_ack,
      in_req                => in_north_req,
      in_data               => in_north_data,
      -- Output continue east
      out_ack_continue      => north_to_south_ack,
      out_req_continue      => north_to_south_req,
      out_data_continue     => north_to_south_data,
      -- Output Local
      out_ack_local         => north_to_local_ack,
      out_req_local         => north_to_local_req,
      out_data_local        => north_to_local_data
    );
    south_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_south_ack,
      in_req                => in_south_req,
      in_data               => in_south_data,
      -- Output continue east
      out_ack_continue      => south_to_north_ack,
      out_req_continue      => south_to_north_req,
      out_data_continue     => south_to_north_data,
      -- Output Local
      out_ack_local         => south_to_local_ack,
      out_req_local         => south_to_local_req,
      out_data_local        => south_to_local_data
    );
    west_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_west_ack,
      in_req                => in_west_req,
      in_data               => in_west_data,
      -- Output continue east
      out_ack_continue      => west_to_local_ack,
      out_req_continue      => west_to_local_req,
      out_data_continue     => west_to_local_data,
      -- Output Local
      out_ack_local         => west_to_local_ack,
      out_req_local         => west_to_local_req,
      out_data_local        => west_to_local_data
    );

    -- Diagonal outputs
    north_west_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_north_west_ack,
      in_req              => local_to_north_west_req,
      in_data             => local_to_north_west_data,
      -- Output channel
      out_ack             => out_north_west_ack,
      out_req             => out_north_west_req,
      out_data            => out_north_west_data
    );
    south_west_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_south_west_ack,
      in_req              => local_to_south_west_req,
      in_data             => local_to_south_west_data,
      -- Output channel
      out_ack             => out_south_west_ack,
      out_req             => out_south_west_req,
      out_data            => out_south_west_data
    );

    -- Straight outputs
    north_output : entity work.output_3_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Straight continue input channel
      in_ack_0            => south_to_north_ack,
      in_req_0            => south_to_north_req,
      in_data_0           => south_to_north_data,
      -- Local input channel
      in_ack_1            => local_to_north_ack,
      in_req_1            => local_to_north_req,
      in_data_1           => local_to_north_data,
      -- Left diagonal input channel (Looking in the direaction out of the output)
      in_ack_2            => south_west_to_north_ack,
      in_req_2            => south_west_to_north_req,
      in_data_2           => south_west_to_north_data,
      -- Output channel
      out_ack             => out_north_ack,
      out_req             => out_north_req,
      out_data            => out_north_data
    );
    south_output : entity work.output_3_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Straight continue input channel
      in_ack_0            => north_to_south_ack,
      in_req_0            => north_to_south_req,
      in_data_0           => north_to_south_data,
      -- Local input channel
      in_ack_1            => local_to_south_ack,
      in_req_1            => local_to_south_req,
      in_data_1           => local_to_south_data,
      -- Right diagonal input channel (Looking in the direaction out of the output)
      in_ack_2            => north_west_to_south_ack,
      in_req_2            => north_west_to_south_req,
      in_data_2           => north_west_to_south_data,
      -- Output channel
      out_ack             => out_south_ack,
      out_req             => out_south_req,
      out_data            => out_south_data
    );
    west_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_west_ack,
      in_req              => local_to_west_req,
      in_data             => local_to_west_data,
      -- Output channel
      out_ack             => out_west_ack,
      out_req             => out_west_req,
      out_data            => out_west_data
    );
  end generate east_edge_router;
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  south_edge_router:
  if left = '0' and right = '0' and top = '0' and bottom = '1' generate
    -- Generate South Edge router
    -- Diagonal inputs
    north_west_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_north_west_ack,
      in_req                => in_north_west_req,
      in_data               => in_north_west_data,
      -- Output continue south east
      out_ack_continue      => north_west_to_local_ack,
      out_req_continue      => north_west_to_local_req,
      out_data_continue     => north_west_to_local_data,
      -- Output East
      out_ack_we            => north_west_to_east_ack,
      out_req_we            => north_west_to_east_req,
      out_data_we           => north_west_to_east_data,
      -- Output North
      out_ack_ns            => north_west_to_local_ack,
      out_req_ns            => north_west_to_local_req,
      out_data_ns           => north_west_to_local_data,
      -- Output Local
      out_ack_local         => north_west_to_local_ack,
      out_req_local         => north_west_to_local_req,
      out_data_local        => north_west_to_local_data
    );
    north_east_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_north_east_ack,
      in_req                => in_north_east_req,
      in_data               => in_north_east_data,
      -- Output continue south east
      out_ack_continue      => north_east_to_local_ack,
      out_req_continue      => north_east_to_local_req,
      out_data_continue     => north_east_to_local_data,
      -- Output West
      out_ack_we            => north_east_to_west_ack,
      out_req_we            => north_east_to_west_req,
      out_data_we           => north_east_to_west_data,
      -- Output North
      out_ack_ns            => north_east_to_local_ack,
      out_req_ns            => north_east_to_local_req,
      out_data_ns           => north_east_to_local_data,
      -- Output Local
      out_ack_local         => north_east_to_local_ack,
      out_req_local         => north_east_to_local_req,
      out_data_local        => north_east_to_local_data
    );

    -- Straight inputs
    west_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_west_ack,
      in_req                => in_west_req,
      in_data               => in_west_data,
      -- Output continue east
      out_ack_continue      => west_to_east_ack,
      out_req_continue      => west_to_east_req,
      out_data_continue     => west_to_east_data,
      -- Output Local
      out_ack_local         => west_to_local_ack,
      out_req_local         => west_to_local_req,
      out_data_local        => west_to_local_data
    );
    east_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_east_ack,
      in_req                => in_east_req,
      in_data               => in_east_data,
      -- Output continue east
      out_ack_continue      => east_to_west_ack,
      out_req_continue      => east_to_west_req,
      out_data_continue     => east_to_west_data,
      -- Output Local
      out_ack_local         => east_to_local_ack,
      out_req_local         => east_to_local_req,
      out_data_local        => east_to_local_data
    );
    north_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_north_ack,
      in_req                => in_north_req,
      in_data               => in_north_data,
      -- Output continue east
      out_ack_continue      => north_to_local_ack,
      out_req_continue      => north_to_local_req,
      out_data_continue     => north_to_local_data,
      -- Output Local
      out_ack_local         => north_to_local_ack,
      out_req_local         => north_to_local_req,
      out_data_local        => north_to_local_data
    );

    -- Diagonal outputs
    north_west_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_north_west_ack,
      in_req              => local_to_north_west_req,
      in_data             => local_to_north_west_data,
      -- Output channel
      out_ack             => out_north_west_ack,
      out_req             => out_north_west_req,
      out_data            => out_north_west_data
    );
    north_east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_north_east_ack,
      in_req              => local_to_north_east_req,
      in_data             => local_to_north_east_data,
      -- Output channel
      out_ack             => out_north_east_ack,
      out_req             => out_north_east_req,
      out_data            => out_north_east_data
    );

    -- Straight outputs
    west_output : entity work.output_3_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Straight continue input channel
      in_ack_0            => east_to_west_ack,
      in_req_0            => east_to_west_req,
      in_data_0           => east_to_west_data,
      -- Local input channel
      in_ack_1            => local_to_west_ack,
      in_req_1            => local_to_west_req,
      in_data_1           => local_to_west_data,
      -- Right diagonal input channel (Looking in the direaction out of the output)
      in_ack_2            => north_east_to_west_ack,
      in_req_2            => north_east_to_west_req,
      in_data_2           => north_east_to_west_data,
      -- Output channel
      out_ack             => out_west_ack,
      out_req             => out_west_req,
      out_data            => out_west_data
    );
    east_output : entity work.output_3_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Straight continue input channel
      in_ack_0            => west_to_east_ack,
      in_req_0            => west_to_east_req,
      in_data_0           => west_to_east_data,
      -- Local input channel
      in_ack_1            => local_to_east_ack,
      in_req_1            => local_to_east_req,
      in_data_1           => local_to_east_data,
      -- Left diagonal input channel (Looking in the direaction out of the output)
      in_ack_2            => north_west_to_east_ack,
      in_req_2            => north_west_to_east_req,
      in_data_2           => north_west_to_east_data,
      -- Output channel
      out_ack             => out_east_ack,
      out_req             => out_east_req,
      out_data            => out_east_data
    );
    north_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_north_ack,
      in_req              => local_to_north_req,
      in_data             => local_to_north_data,
      -- Output channel
      out_ack             => out_north_ack,
      out_req             => out_north_req,
      out_data            => out_north_data
    );

  end generate south_edge_router;
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  west_edge_router:
  if left = '1' and right = '0' and top = '0' and bottom = '0' generate
    -- Generate West Edge router
    -- Diagonal inputs
    north_east_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_north_east_ack,
      in_req                => in_north_east_req,
      in_data               => in_north_east_data,
      -- Output continue 
      out_ack_continue      => north_east_to_local_ack,
      out_req_continue      => north_east_to_local_req,
      out_data_continue     => north_east_to_local_data,
      -- Output East
      out_ack_we            => north_east_to_local_ack,
      out_req_we            => north_east_to_local_req,
      out_data_we           => north_east_to_local_data,
      -- Output North
      out_ack_ns            => north_east_to_south_ack,
      out_req_ns            => north_east_to_south_req,
      out_data_ns           => north_east_to_south_data,
      -- Output Local
      out_ack_local         => north_east_to_local_ack,
      out_req_local         => north_east_to_local_req,
      out_data_local        => north_east_to_local_data
    );
    south_east_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_south_east_ack,
      in_req                => in_south_east_req,
      in_data               => in_south_east_data,
      -- Output continue 
      out_ack_continue      => south_east_to_local_ack,
      out_req_continue      => south_east_to_local_req,
      out_data_continue     => south_east_to_local_data,
      -- Output West
      out_ack_we            => south_east_to_local_ack,
      out_req_we            => south_east_to_local_req,
      out_data_we           => south_east_to_local_data,
      -- Output North
      out_ack_ns            => south_east_to_north_ack,
      out_req_ns            => south_east_to_north_req,
      out_data_ns           => south_east_to_north_data,
      -- Output Local
      out_ack_local         => south_east_to_local_ack,
      out_req_local         => south_east_to_local_req,
      out_data_local        => south_east_to_local_data
    );

    -- Straight inputs
    north_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_north_ack,
      in_req                => in_north_req,
      in_data               => in_north_data,
      -- Output continue east
      out_ack_continue      => north_to_south_ack,
      out_req_continue      => north_to_south_req,
      out_data_continue     => north_to_south_data,
      -- Output Local
      out_ack_local         => north_to_local_ack,
      out_req_local         => north_to_local_req,
      out_data_local        => north_to_local_data
    );
    south_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_south_ack,
      in_req                => in_south_req,
      in_data               => in_south_data,
      -- Output continue east
      out_ack_continue      => south_to_north_ack,
      out_req_continue      => south_to_north_req,
      out_data_continue     => south_to_north_data,
      -- Output Local
      out_ack_local         => south_to_local_ack,
      out_req_local         => south_to_local_req,
      out_data_local        => south_to_local_data
    );
    east_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_east_ack,
      in_req                => in_east_req,
      in_data               => in_east_data,
      -- Output continue east
      out_ack_continue      => east_to_local_ack,
      out_req_continue      => east_to_local_req,
      out_data_continue     => east_to_local_data,
      -- Output Local
      out_ack_local         => east_to_local_ack,
      out_req_local         => east_to_local_req,
      out_data_local        => east_to_local_data
    );

    -- Diagonal outputs
    north_east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_north_east_ack,
      in_req              => local_to_north_east_req,
      in_data             => local_to_north_east_data,
      -- Output channel
      out_ack             => out_north_east_ack,
      out_req             => out_north_east_req,
      out_data            => out_north_east_data
    );
    south_east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_south_east_ack,
      in_req              => local_to_south_east_req,
      in_data             => local_to_south_east_data,
      -- Output channel
      out_ack             => out_south_east_ack,
      out_req             => out_south_east_req,
      out_data            => out_south_east_data
    );

    -- Straight outputs
    north_output : entity work.output_3_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Straight continue input channel
      in_ack_0            => south_to_north_ack,
      in_req_0            => south_to_north_req,
      in_data_0           => south_to_north_data,
      -- Local input channel
      in_ack_1            => local_to_north_ack,
      in_req_1            => local_to_north_req,
      in_data_1           => local_to_north_data,
      -- Right diagonal input channel (Looking in the direaction out of the output)
      in_ack_2            => south_east_to_north_ack,
      in_req_2            => south_east_to_north_req,
      in_data_2           => south_east_to_north_data,
      -- Output channel
      out_ack             => out_north_ack,
      out_req             => out_north_req,
      out_data            => out_north_data
    );
    south_output : entity work.output_3_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Straight continue input channel
      in_ack_0            => north_to_south_ack,
      in_req_0            => north_to_south_req,
      in_data_0           => north_to_south_data,
      -- Local input channel
      in_ack_1            => local_to_south_ack,
      in_req_1            => local_to_south_req,
      in_data_1           => local_to_south_data,
      -- Left diagonal input channel (Looking in the direaction out of the output)
      in_ack_2            => north_east_to_south_ack,
      in_req_2            => north_east_to_south_req,
      in_data_2           => north_east_to_south_data,
      -- Output channel
      out_ack             => out_south_ack,
      out_req             => out_south_req,
      out_data            => out_south_data
    );
    east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_east_ack,
      in_req              => local_to_east_req,
      in_data             => local_to_east_data,
      -- Output channel
      out_ack             => out_east_ack,
      out_req             => out_east_req,
      out_data            => out_east_data
    );
  end generate west_edge_router;
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  south_east_corner_router:
  if left = '0' and right = '1' and top = '0' and bottom = '1' generate
    -- Generate South East Corner router
    -- Diagonal inputs
    north_west_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_north_west_ack,
      in_req                => in_north_west_req,
      in_data               => in_north_west_data,
      -- Output Continue diagonal
      out_ack_continue      => north_west_to_local_ack,
      out_req_continue      => north_west_to_local_req,
      out_data_continue     => north_west_to_local_data,
      -- Output West/East
      out_ack_we            => north_west_to_local_ack,
      out_req_we            => north_west_to_local_req,
      out_data_we           => north_west_to_local_data,
      -- Output North/South 
      out_ack_ns            => north_west_to_local_ack,
      out_req_ns            => north_west_to_local_req,
      out_data_ns           => north_west_to_local_data,
      -- Output Local
      out_ack_local         => north_west_to_local_ack,
      out_req_local         => north_west_to_local_req,
      out_data_local        => north_west_to_local_data
    );

    -- Straight inputs
    north_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_north_ack,
      in_req                => in_north_req,
      in_data               => in_north_data,
      -- Output continue local
      out_ack_continue      => north_to_local_ack,
      out_req_continue      => north_to_local_req,
      out_data_continue     => north_to_local_data,
      -- Output Local
      out_ack_local         => north_to_local_ack,
      out_req_local         => north_to_local_req,
      out_data_local        => north_to_local_data
    );

    west_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_west_ack,
      in_req                => in_west_req,
      in_data               => in_west_data,
      -- Output continue local
      out_ack_continue      => west_to_local_ack,
      out_req_continue      => west_to_local_req,
      out_data_continue     => west_to_local_data,
      -- Output Local
      out_ack_local         => west_to_local_ack,
      out_req_local         => west_to_local_req,
      out_data_local        => west_to_local_data
    );

    -- Diagonal outputs
    north_west_output_se_corner : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_north_west_ack,
      in_req              => local_to_north_west_req,
      in_data             => local_to_north_west_data,
      -- Output channel
      out_ack             => out_north_west_ack,
      out_req             => out_north_west_req,
      out_data            => out_north_west_data
    );

    -- Straight outputs
    north_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack        => local_to_north_ack,
      in_req        => local_to_north_req,
      in_data       => local_to_north_data,
      -- Output channel
      out_ack             => out_north_ack,
      out_req             => out_north_req,
      out_data            => out_north_data
    );

    west_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack        => local_to_west_ack,
      in_req        => local_to_west_req,
      in_data       => local_to_west_data,
      -- Output channel
      out_ack             => out_west_ack,
      out_req             => out_west_req,
      out_data            => out_west_data
    );
  end generate south_east_corner_router;
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  north_east_corner_router:
  if left = '0' and right = '1' and top = '1' and bottom = '0' generate
    -- Generate North East Corner router
    -- Diagonal inputs
    south_west_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_south_west_ack,
      in_req                => in_south_west_req,
      in_data               => in_south_west_data,
      -- Output Continue diagonal
      out_ack_continue      => south_west_to_local_ack,
      out_req_continue      => south_west_to_local_req,
      out_data_continue     => south_west_to_local_data,
      -- Output West/East
      out_ack_we            => south_west_to_local_ack,
      out_req_we            => south_west_to_local_req,
      out_data_we           => south_west_to_local_data,
      -- Output North/South 
      out_ack_ns            => south_west_to_local_ack,
      out_req_ns            => south_west_to_local_req,
      out_data_ns           => south_west_to_local_data,
      -- Output Local
      out_ack_local         => south_west_to_local_ack,
      out_req_local         => south_west_to_local_req,
      out_data_local        => south_west_to_local_data
    );

    -- Straight inputs
    west_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_west_ack,
      in_req                => in_west_req,
      in_data               => in_west_data,
      -- Output continue local
      out_ack_continue      => west_to_local_ack,
      out_req_continue      => west_to_local_req,
      out_data_continue     => west_to_local_data,
      -- Output Local
      out_ack_local         => west_to_local_ack,
      out_req_local         => west_to_local_req,
      out_data_local        => west_to_local_data
    );

    south_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_south_ack,
      in_req                => in_south_req,
      in_data               => in_south_data,
      -- Output continue local
      out_ack_continue      => south_to_local_ack,
      out_req_continue      => south_to_local_req,
      out_data_continue     => south_to_local_data,
      -- Output Local
      out_ack_local         => south_to_local_ack,
      out_req_local         => south_to_local_req,
      out_data_local        => south_to_local_data
    );

    -- Diagonal outputs
    south_west_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_south_west_ack,
      in_req              => local_to_south_west_req,
      in_data             => local_to_south_west_data,
      -- Output channel
      out_ack             => out_south_west_ack,
      out_req             => out_south_west_req,
      out_data            => out_south_west_data
    );

    -- Straight outputs
    west_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack        => local_to_west_ack,
      in_req        => local_to_west_req,
      in_data       => local_to_west_data,
      -- Output channel
      out_ack             => out_west_ack,
      out_req             => out_west_req,
      out_data            => out_west_data
    );

    south_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack        => local_to_south_ack,
      in_req        => local_to_south_req,
      in_data       => local_to_south_data,
      -- Output channel
      out_ack             => out_south_ack,
      out_req             => out_south_req,
      out_data            => out_south_data
    );
  end generate north_east_corner_router;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  north_west_corner_router:
  if left = '1' and right = '0' and top = '1' and bottom = '0' generate
    -- Generate North West Corner router
    -- Diagonal inputs
    south_east_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_south_east_ack,
      in_req                => in_south_east_req,
      in_data               => in_south_east_data,
      -- Output Continue north west
      out_ack_continue      => south_east_to_local_ack,
      out_req_continue      => south_east_to_local_req,
      out_data_continue     => south_east_to_local_data,
      -- Output West
      out_ack_we            => south_east_to_local_ack,
      out_req_we            => south_east_to_local_req,
      out_data_we           => south_east_to_local_data,
      -- Output North
      out_ack_ns            => south_east_to_local_ack,
      out_req_ns            => south_east_to_local_req,
      out_data_ns           => south_east_to_local_data,
      -- Output Local
      out_ack_local         => south_east_to_local_ack,
      out_req_local         => south_east_to_local_req,
      out_data_local        => south_east_to_local_data
    );

    -- Straight inputs
    east_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_east_ack,
      in_req                => in_east_req,
      in_data               => in_east_data,
      -- Output continue local
      out_ack_continue      => east_to_local_ack,
      out_req_continue      => east_to_local_req,
      out_data_continue     => east_to_local_data,
      -- Output Local
      out_ack_local         => east_to_local_ack,
      out_req_local         => east_to_local_req,
      out_data_local        => east_to_local_data
    );

    south_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_south_ack,
      in_req                => in_south_req,
      in_data               => in_south_data,
      -- Output continue local
      out_ack_continue      => south_to_local_ack,
      out_req_continue      => south_to_local_req,
      out_data_continue     => south_to_local_data,
      -- Output Local
      out_ack_local         => south_to_local_ack,
      out_req_local         => south_to_local_req,
      out_data_local        => south_to_local_data
    );

    -- Diagonal outputs
    south_east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_south_east_ack,
      in_req              => local_to_south_east_req,
      in_data             => local_to_south_east_data,
      -- Output channel
      out_ack             => out_south_east_ack,
      out_req             => out_south_east_req,
      out_data            => out_south_east_data
    );

    -- Straight outputs
    east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack        => local_to_east_ack,
      in_req        => local_to_east_req,
      in_data       => local_to_east_data,
      -- Output channel
      out_ack             => out_east_ack,
      out_req             => out_east_req,
      out_data            => out_east_data
    );

    south_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack        => local_to_south_ack,
      in_req        => local_to_south_req,
      in_data       => local_to_south_data,
      -- Output channel
      out_ack             => out_south_ack,
      out_req             => out_south_req,
      out_data            => out_south_data
    );
  end generate north_west_corner_router;
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  south_west_corner_router:  
  if left = '1' and right = '0' and top = '0' and bottom = '1' generate
    -- Generate South West Corner router
    -- Diagonal inputs
    north_east_input : entity work.diagonal_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_x    => address_x,
      in_local_address_y    => address_y,
      in_ack                => in_north_east_ack,
      in_req                => in_north_east_req,
      in_data               => in_north_east_data,
      -- Output Continue diagonal
      out_ack_continue      => north_east_to_local_ack,
      out_req_continue      => north_east_to_local_req,
      out_data_continue     => north_east_to_local_data,
      -- Output West/East
      out_ack_we            => north_east_to_local_ack,
      out_req_we            => north_east_to_local_req,
      out_data_we           => north_east_to_local_data,
      -- Output North/South 
      out_ack_ns            => north_east_to_local_ack,
      out_req_ns            => north_east_to_local_req,
      out_data_ns           => north_east_to_local_data,
      -- Output Local
      out_ack_local         => north_east_to_local_ack,
      out_req_local         => north_east_to_local_req,
      out_data_local        => north_east_to_local_data
    );

    -- Straight inputs
    north_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_y,
      in_ack                => in_north_ack,
      in_req                => in_north_req,
      in_data               => in_north_data,
      -- Output continue local
      out_ack_continue      => north_to_local_ack,
      out_req_continue      => north_to_local_req,
      out_data_continue     => north_to_local_data,
      -- Output Local
      out_ack_local         => north_to_local_ack,
      out_req_local         => north_to_local_req,
      out_data_local        => north_to_local_data
    );

    east_input : entity work.straight_input_rtl(rtl)
    port map
    (
      rst                   => rst,
      in_local_address_xy   => address_x,
      in_ack                => in_east_ack,
      in_req                => in_east_req,
      in_data               => in_east_data,
      -- Output continue local
      out_ack_continue      => east_to_local_ack,
      out_req_continue      => east_to_local_req,
      out_data_continue     => east_to_local_data,
      -- Output Local
      out_ack_local         => east_to_local_ack,
      out_req_local         => east_to_local_req,
      out_data_local        => east_to_local_data
    );

    -- Diagonal outputs
    north_east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack              => local_to_north_east_ack,
      in_req              => local_to_north_east_req,
      in_data             => local_to_north_east_data,
      -- Output channel
      out_ack             => out_north_east_ack,
      out_req             => out_north_east_req,
      out_data            => out_north_east_data
    );

    -- Straight outputs
    north_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack        => local_to_north_ack,
      in_req        => local_to_north_req,
      in_data       => local_to_north_data,
      -- Output channel
      out_ack             => out_north_ack,
      out_req             => out_north_req,
      out_data            => out_north_data
    );

    east_output : entity work.output_1_inputs(rtl)
    port map
    (
      rst                 => rst,
      -- Local input channel
      in_ack        => local_to_east_ack,
      in_req        => local_to_east_req,
      in_data       => local_to_east_data,
      -- Output channel
      out_ack             => out_east_ack,
      out_req             => out_east_req,
      out_data            => out_east_data
    );
  end generate south_west_corner_router;
end architecture rtl;