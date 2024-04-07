-- noc_defs package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package noc_defs is

    -- Define constants for NoC parameters
    constant NOC_DATA_WIDTH    : natural := 4; 
    constant NOC_ADDRESS_WIDTH : natural := 2; 
    constant NOC_ADDRESS_COMPARE_DELAY : natural := 2; 

end package noc_defs;

package body noc_defs is

end package body noc_defs;