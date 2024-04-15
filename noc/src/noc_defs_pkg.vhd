-- noc_defs package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package noc_defs_pkg is

  -- Miscellaneous NOC Parameters
  constant NOC_MISC_DELAY_0_5_NS : time := 0.5 ns;
  constant NOC_MISC_DELAY_1_NS   : time := 1 ns;
  constant NOC_MISC_DELAY_2_NS   : time := 2 ns;
  constant NOC_MISC_DELAY_5_NS   : time := 5 ns;
  constant NOC_MISC_DELAY_10_NS  : time := 10 ns;
  constant NOC_MISC_DELAY_15_NS  : time := 15 ns;
  constant NOC_MISC_DELAY_20_NS  : time := 20 ns;
  constant NOC_MISC_DELAY_25_NS  : time := 25 ns;
  constant NOC_MISC_DELAY_30_NS  : time := 30 ns;
  constant NOC_MISC_DELAY_35_NS  : time := 35 ns;
  constant NOC_MISC_DELAY_40_NS  : time := 40 ns;
  constant NOC_MISC_DELAY_45_NS  : time := 45 ns;
  constant NOC_MISC_DELAY_50_NS  : time := 50 ns;
  constant NOC_MISC_DELAY_100_NS : time := 100 ns;
  constant NOC_MISC_DELAY_200_NS : time := 200 ns;

  -- Define Global NoC Parameters
  constant NOC_DATA_WIDTH            : natural := 4;
  constant NOC_ADDRESS_WIDTH         : natural := 2;
  constant NOC_ADDRESS_COMPARE_DELAY : natural := 10;

  -- Define Diagonal Input NoC Parameters
  constant NOC_DIAGONAL_STAGE_0_CLICK_WIDTH : natural   := NOC_DATA_WIDTH;
  constant NOC_DIAGONAL_STAGE_0_CLICK_VALUE : natural   := 0;
  constant NOC_DIAGONAL_STAGE_0_CLICK_PHASE : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_0_FORK_WIDTH   : natural   := NOC_DIAGONAL_STAGE_0_CLICK_WIDTH;
  constant NOC_DIAGONAL_STAGE_0_FORK_VALUE   : natural   := 10;
  constant NOC_DIAGONAL_STAGE_0_FORK_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_0_FORK_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_0_FORK_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH   : natural   := NOC_DIAGONAL_STAGE_0_FORK_WIDTH;
  constant NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_DEMUX_1_WIDTH   : natural   := NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH;
  constant NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_DEMUX_2_WIDTH   : natural   := NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH;
  constant NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_WIDTH   : natural   := NOC_DIAGONAL_STAGE_0_CLICK_WIDTH;
  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_VALUE   : natural   := 10;
  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_WIDTH   : natural   := 1;
  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_VALUE   : natural   := 10;
  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_WIDTH   : natural   := 1;
  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_VALUE   : natural   := 10;
  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_C : std_logic := '0';

end package noc_defs_pkg;

package body noc_defs_pkg is

end package body noc_defs_pkg;