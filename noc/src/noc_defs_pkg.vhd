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
  constant NOC_ADDRESS_WIDTH              : natural := 2;
  constant NOC_PACKAGE_WIDTH              : natural := 0;
  constant NOC_DATA_WIDTH                 : natural := NOC_ADDRESS_WIDTH * 2 + NOC_PACKAGE_WIDTH;
  constant NOC_MESH_LENGTH                : natural := 2**NOC_ADDRESS_WIDTH;
  
  constant NOC_COMPARE_DIFF_ADDRESS_DELAY : natural := 10;
  constant NOC_COMPARE_SIGN_ADDRESS_DELAY : natural := 10;
  constant NOC_FORK_REG_VALUE             : natural := 0;
  constant NOC_LOCAL_OUTPUT_BUFFER_LENGTH : natural := 1;
  
  --Types
  type mesh_in_out is array (0 to NOC_MESH_LENGTH - 1, 0 to NOC_MESH_LENGTH - 1) of std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
  type mesh_control is array (0 to NOC_MESH_LENGTH - 1, 0 to NOC_MESH_LENGTH - 1) of std_logic;
  type mesh_connector_in_out  is array (0 to NOC_MESH_LENGTH + 1, 0 to NOC_MESH_LENGTH - 2) of std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
  type mesh_connector_control  is array (0 to NOC_MESH_LENGTH + 1, 0 to NOC_MESH_LENGTH - 2) of std_logic;


  -- Define Diagonal Input NoC Parameters
  constant NOC_DIAGONAL_STAGE_0_CLICK_WIDTH : natural   := NOC_DATA_WIDTH;
  constant NOC_DIAGONAL_STAGE_0_CLICK_VALUE : natural   := 0;
  constant NOC_DIAGONAL_STAGE_0_CLICK_PHASE : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_0_FORK_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_DIAGONAL_STAGE_0_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_DIAGONAL_STAGE_0_FORK_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_0_FORK_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_0_FORK_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_DEMUX_0_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_0_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_DEMUX_1_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_1_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_DEMUX_2_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_DEMUX_2_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_FORK_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_WIDTH   : natural   := 1;
  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_X_FORK_PHASE_C : std_logic := '0';

  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_WIDTH   : natural   := 1;
  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_A : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_B : std_logic := '0';
  constant NOC_DIAGONAL_STAGE_COMPARE_Y_DEMUX_PHASE_C : std_logic := '0';

  -- Local Input 

  constant NOC_KILL_WIDTH : natural := 1;

  constant NOC_LOCAL_STAGE_INPUT_CLICK_WIDTH : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_INPUT_CLICK_VALUE : natural   := 0;
  constant NOC_LOCAL_STAGE_INPUT_CLICK_PHASE : std_logic := '0';

  constant NOC_LOCAL_STAGE_INPUT_FORK_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_INPUT_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_LOCAL_STAGE_INPUT_FORK_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_INPUT_FORK_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_INPUT_FORK_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_0_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_0_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_0_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_0_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_1_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_1_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_1_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_1_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_2_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_2_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_2_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_2_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_3_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_3_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_3_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_3_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_4_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_4_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_4_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_4_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_5_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_5_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_5_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_5_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_6_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_6_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_6_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_PACKAGE_DEMUX_6_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_COMPARE_FORK_0_WIDTH   : natural   := NOC_DATA_WIDTH;
  constant NOC_LOCAL_STAGE_COMPARE_FORK_0_VALUE   : natural   := 10;
  constant NOC_LOCAL_STAGE_COMPARE_FORK_0_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_COMPARE_FORK_0_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_COMPARE_FORK_0_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_COMPARE_FORK_1_WIDTH   : natural   := NOC_ADDRESS_WIDTH;
  constant NOC_LOCAL_STAGE_COMPARE_FORK_1_VALUE   : natural   := 10;
  constant NOC_LOCAL_STAGE_COMPARE_FORK_1_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_COMPARE_FORK_1_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_COMPARE_FORK_1_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_COMPARE_FORK_2_WIDTH   : natural   := NOC_ADDRESS_WIDTH;
  constant NOC_LOCAL_STAGE_COMPARE_FORK_2_VALUE   : natural   := 10;
  constant NOC_LOCAL_STAGE_COMPARE_FORK_2_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_COMPARE_FORK_2_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_COMPARE_FORK_2_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_RAW_S_DELTA_X_DEMUX_0_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_X_DEMUX_0_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_X_DEMUX_0_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_X_DEMUX_0_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_RAW_S_DELTA_X_DEMUX_1_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_X_DEMUX_1_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_X_DEMUX_1_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_X_DEMUX_1_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_0_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_0_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_0_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_0_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_1_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_1_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_1_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_1_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_2_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_2_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_2_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_S_DELTA_Y_DEMUX_2_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_RAW_DELTA_X_DEMUX_0_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_RAW_DELTA_X_DEMUX_0_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_DELTA_X_DEMUX_0_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_RAW_DELTA_X_DEMUX_0_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_S_DELTA_X_1_FORK_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_S_DELTA_X_1_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_LOCAL_STAGE_S_DELTA_X_1_FORK_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_S_DELTA_X_1_FORK_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_S_DELTA_X_1_FORK_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_DELTA_X_0_0_FORK_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_DELTA_X_0_0_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_LOCAL_STAGE_DELTA_X_0_0_FORK_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_X_0_0_FORK_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_X_0_0_FORK_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_DELTA_X_0_1_FORK_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_DELTA_X_0_1_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_LOCAL_STAGE_DELTA_X_0_1_FORK_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_X_0_1_FORK_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_X_0_1_FORK_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_DELTA_X_0_2_FORK_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_DELTA_X_0_2_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_LOCAL_STAGE_DELTA_X_0_2_FORK_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_X_0_2_FORK_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_X_0_2_FORK_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_DELTA_Y_0_0_FORK_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_DELTA_Y_0_0_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_LOCAL_STAGE_DELTA_Y_0_0_FORK_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_Y_0_0_FORK_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_Y_0_0_FORK_PHASE_C : std_logic := '0';

  constant NOC_LOCAL_STAGE_DELTA_Y_0_1_FORK_WIDTH   : natural   := 1;
  constant NOC_LOCAL_STAGE_DELTA_Y_0_1_FORK_VALUE   : natural   := NOC_FORK_REG_VALUE;
  constant NOC_LOCAL_STAGE_DELTA_Y_0_1_FORK_PHASE_A : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_Y_0_1_FORK_PHASE_B : std_logic := '0';
  constant NOC_LOCAL_STAGE_DELTA_Y_0_1_FORK_PHASE_C : std_logic := '0';
end package noc_defs_pkg;

package body noc_defs_pkg is

end package body noc_defs_pkg;