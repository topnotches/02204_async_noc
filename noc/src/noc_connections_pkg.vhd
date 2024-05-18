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


    type noc_diagonal_connections is record
        topleft_to_bottomright : async_bus_if;
        bottomright_to_topleft : async_bus_if;
        topright_to_bottomleft : async_bus_if;
        bottomleft_to_topright : async_bus_if;
    end record;

    type noc_horizontal_connections is record
        left_to_right : async_bus_if;
        right_to_left : async_bus_if;
    end record;
    type noc_vertical_connections is record
        top_to_bottom : async_bus_if;
        bottom_to_top : async_bus_if;
    end record;
    type noc_local_connections is record
        local_in  : async_bus_if;
        local_out : async_bus_if;
    end record;
    type noc_local_in is array (0 to 2 ** NOC_PERIMETER_SIZE - 1, 0 to 2 ** NOC_PERIMETER_SIZE - 1) of async_bus_if;
    type noc_local_out is array (0 to 2 ** NOC_PERIMETER_SIZE - 1, 0 to 2 ** NOC_PERIMETER_SIZE - 1) of async_bus_if;

    type arrif_diagonal_connections_t is array (0 to 2 ** NOC_PERIMETER_SIZE, 0 to 2 ** NOC_PERIMETER_SIZE) of noc_diagonal_connections;
    type arrif_horizontal_connections_t is array (0 to 2 ** NOC_PERIMETER_SIZE - 1, 0 to 2 ** NOC_PERIMETER_SIZE) of noc_horizontal_connections;
    type arrif_vertical_connections_t is array (0 to 2 ** NOC_PERIMETER_SIZE, 0 to 2 ** NOC_PERIMETER_SIZE - 1) of noc_vertical_connections;
    type arrif_local_connections_t is array (0 to 2 ** NOC_PERIMETER_SIZE - 1, 0 to 2 ** NOC_PERIMETER_SIZE - 1) of noc_local_connections;
    type local_connections_t is record
        local_in : noc_local_in;
        local_out : noc_local_out;
    end record;
end package noc_connections_pkg;

package body noc_connections_pkg is

end package body noc_connections_pkg;