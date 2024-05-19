-- noc_defs package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.noc_defs_pkg.all;

package noc_connections_pkg is
    constant NOC_PERIMETER_SIZE : natural := NOC_ADDRESS_WIDTH;

    type async_bus_if is record
        req  : std_logic;
        ack  : std_logic;
        data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    end record;
    type noc_diagonal_connections_if is record
        northwest_to_southeast : async_bus_if;
        southeast_to_northwest : async_bus_if;
        northeast_to_southwest : async_bus_if;
        southwest_to_northeast : async_bus_if;
    end record;

    type noc_horizontal_connections_if is record
        west_to_east : async_bus_if;
        east_to_west : async_bus_if;
    end record;
    type noc_vertical_connections_if is record
        north_to_south : async_bus_if;
        south_to_north : async_bus_if;
    end record;
    type noc_local_connections_if is record
        local_in  : async_bus_if;
        local_out : async_bus_if;
    end record;
    type noc_local_in is array (0 to 2 ** NOC_PERIMETER_SIZE - 1, 0 to 2 ** NOC_PERIMETER_SIZE - 1) of async_bus_if;
    type noc_local_out is array (0 to 2 ** NOC_PERIMETER_SIZE - 1, 0 to 2 ** NOC_PERIMETER_SIZE - 1) of async_bus_if;

    type arrif_diagonal_connections_t is array (0 to 2 ** NOC_PERIMETER_SIZE, 0 to 2 ** NOC_PERIMETER_SIZE) of noc_diagonal_connections_if;
    type arrif_horizontal_connections_t is array (0 to 2 ** NOC_PERIMETER_SIZE - 1, 0 to 2 ** NOC_PERIMETER_SIZE) of noc_horizontal_connections_if;
    type arrif_vertical_connections_t is array (0 to 2 ** NOC_PERIMETER_SIZE, 0 to 2 ** NOC_PERIMETER_SIZE - 1) of noc_vertical_connections_if;
    type arrif_local_connections_t is array (0 to 2 ** NOC_PERIMETER_SIZE - 1, 0 to 2 ** NOC_PERIMETER_SIZE - 1) of noc_local_connections_if;
    type local_connections_t is record
        local_in  : noc_local_in;
        local_out : noc_local_out;
    end record;
end package noc_connections_pkg;

package body noc_connections_pkg is

end package body noc_connections_pkg;