library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;
use work.data_if_pkg.all;

entity straight_input_tb is
end straight_input_tb;

architecture behavioral of straight_input_tb is
  -- Assuming NOC_ADDRESS_WIDTH, NOC_DATA_WIDTH are previously defined constants
  signal north_south_block : integer := 1;

  signal rst_signal : std_logic := '1';

  signal in_local_address_xy_signal : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');

  signal in_ack_signal  : std_logic                                     := '0';
  signal in_req_signal  : std_logic                                     := '0';
  signal in_data_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

  signal out_req_continue_signal  : std_logic                                     := '0';
  signal out_data_continue_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal out_ack_continue_signal  : std_logic                                     := '0';

  signal out_req_local_signal  : std_logic                                     := '0';
  signal out_data_local_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal out_ack_local_signal  : std_logic                                     := '0';
  type a8_data_if_t is array (natural range 0 to 3) of data_if;
  signal sa8_data_if_stimuli : a8_data_if_t := (init_data_if(0, 0),
  init_data_if(0, 1),
  init_data_if(1, 0),
  init_data_if(1, 1));
BEGIN

  DUT : entity work.straight_input_rtl
    generic map(
      north_south => 1
    )
    port map
    (
      rst => rst_signal,

      in_local_address_xy => in_local_address_xy_signal,

      in_ack  => in_ack_signal,
      in_req  => in_req_signal,
      in_data => in_data_signal,

      out_req_continue  => out_req_continue_signal,
      out_data_continue => out_data_continue_signal,
      out_ack_continue  => out_ack_continue_signal,

      out_req_local  => out_req_local_signal,
      out_data_local => out_data_local_signal,
      out_ack_local  => out_ack_local_signal
    );
  -- Testbench for diagonal input
  TB : block
  begin
    process
      constant DATA_PREP_DELAY : time := NOC_MISC_DELAY_10_NS;

      procedure insert_data_package_from_stim_vector(index_sel_data : in natural) is
      begin

        in_data_signal <= data_if_to_slv(sa8_data_if_stimuli(index_sel_data));
        wait for DATA_PREP_DELAY;
        in_req_signal <= not in_req_signal;
        wait until in_ack_signal'event;

      end procedure;
    begin
      wait for 100 ns;
      insert_data_package_from_stim_vector(0);
      wait for 50 ns;
      out_ack_local_signal <= not out_ack_local_signal;

      insert_data_package_from_stim_vector(1);
      wait for 100 ns;
      out_ack_continue_signal <= not out_ack_continue_signal;
      wait for 50 ns;

      insert_data_package_from_stim_vector(2);
      wait for 100 ns;
      out_ack_local_signal <= not out_ack_local_signal;
      wait for 50 ns;

      insert_data_package_from_stim_vector(3);
      wait for 100 ns;
      out_ack_continue_signal <= not out_ack_continue_signal;
      wait for 50 ns;

    end process;
  end block;
  -- Reset Signal Goes Low
  rst_signal <= '0' after 50 ns;
end architecture;