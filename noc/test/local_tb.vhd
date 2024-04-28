library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.data_if_pkg.all;
use work.noc_defs_pkg.all;

entity local_tb is
end entity local_tb;

architecture rtl of local_tb is

  signal signal_rst : std_logic := '1';

  signal signal_in_local_address_x : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
  signal signal_in_local_address_y : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');

  -- Local Address
  signal signal_in_local_address_x : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
  signal signal_in_local_address_y : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := (others => '0');

  -- Input channel
  signal signal_in_ack  : std_logic                                     := '0';
  signal signal_in_req  : std_logic                                     := '0';
  signal signal_in_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

  -- Output West
  signal signal_out_west_req  : std_logic                                     := '0';
  signal signal_out_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal signal_out_west_ack  : std_logic                                     := '0';

  -- Output North West
  signal signal_out_north_west_req  : std_logic                                     := '0';
  signal signal_out_north_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal signal_out_north_west_ack  : std_logic                                     := '0';

  -- Output North
  signal signal_out_north_req  : std_logic                                     := '0';
  signal signal_out_north_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal signal_out_north_ack  : std_logic                                     := '0';

  -- Output North East
  signal signal_out_north_east_req  : std_logic                                     := '0';
  signal signal_out_north_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal signal_out_north_east_ack  : std_logic                                     := '0';

  -- Output East
  signal signal_out_east_req  : std_logic                                     := '0';
  signal signal_out_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal signal_out_east_ack  : std_logic                                     := '0';

  -- Output South East
  signal signal_out_south_east_req  : std_logic                                     := '0';
  signal signal_out_south_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal signal_out_south_east_ack  : std_logic                                     := '0';

  -- Output South
  signal signal_out_south_req  : std_logic                                     := '0';
  signal signal_out_south_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal signal_out_south_ack  : std_logic                                     := '0';

  -- Output South West
  signal signal_out_south_west_req  : std_logic                                     := '0';
  signal signal_out_south_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal signal_out_south_west_ack  : std_logic                                     := '0';
begin

  DUT : entity work.local_input_rtl
    port map
    (
      rst                 => signal_rst,
      in_local_address_x  => signal_in_local_address_x,
      in_local_address_y  => signal_in_local_address_y,
      in_ack              => signal_in_ack,
      in_req              => signal_in_req,
      in_data             => signal_in_data,
      out_west_req        => signal_out_west_req,
      out_west_data       => signal_out_west_data,
      out_west_ack        => signal_out_west_ack,
      out_north_west_req  => signal_out_north_west_req,
      out_north_west_data => signal_out_north_west_data,
      out_north_west_ack  => signal_out_north_west_ack,
      out_north_req       => signal_out_north_req,
      out_north_data      => signal_out_north_data,
      out_north_ack       => signal_out_north_ack,
      out_north_east_req  => signal_out_north_east_req,
      out_north_east_data => signal_out_north_east_data,
      out_north_east_ack  => signal_out_north_east_ack,
      out_east_req        => signal_out_east_req,
      out_east_data       => signal_out_east_data,
      out_east_ack        => signal_out_east_ack,
      out_south_east_req  => signal_out_south_east_req,
      out_south_east_data => signal_out_south_east_data,
      out_south_east_ack  => signal_out_south_east_ack,
      out_south_req       => signal_out_south_req,
      out_south_data      => signal_out_south_data,
      out_south_ack       => signal_out_south_ack,
      out_south_west_req  => signal_out_south_west_req,
      out_south_west_data => signal_out_south_west_data,
      out_south_west_ack  => signal_out_south_west_ack
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
      out_ack_ns_signal <= not out_ack_ns_signal;
      wait for 50 ns;

      insert_data_package_from_stim_vector(2);
      wait for 100 ns;
      out_ack_we_signal <= not out_ack_we_signal;
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