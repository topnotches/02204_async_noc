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

    signal signal_in_local_address_x : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := "01";
    signal signal_in_local_address_y : std_logic_vector(NOC_ADDRESS_WIDTH - 1 downto 0) := "01";

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

    type a8_data_if_t is array (natural range 0 to 7) of data_if;

    signal sa8_data_if_stimuli : a8_data_if_t := (init_data_if(0, 0),
    init_data_if(1, 0),
    init_data_if(2, 0),
    init_data_if(2, 1),
    init_data_if(2, 2),
    init_data_if(1, 2),
    init_data_if(0, 2),
    init_data_if(0, 1));

begin

    dut : entity work.local_input_rtl
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

    tb : block is
    begin

        process is

            constant data_prep_delay : time := NOC_MISC_DELAY_10_NS;

            procedure insert_data_package_from_stim_vector (
                index_sel_data : in natural
            ) is
            begin

                signal_in_data <= data_if_to_slv(sa8_data_if_stimuli(index_sel_data));
                wait for DATA_PREP_DELAY;
                signal_in_req <= not signal_in_req;
                wait until signal_in_ack'event;

            end procedure;

        begin

            wait for 100 ns;
            insert_data_package_from_stim_vector(0);
            wait until signal_out_north_west_req'event;
            wait for 10 ns;
            assert signal_out_north_west_data = signal_in_data report "Data Mismatch" severity failure;
            signal_out_north_west_ack <= not signal_out_north_west_ack;

            insert_data_package_from_stim_vector(1);
            wait until signal_out_north_req'event;
            wait for 10 ns;
            assert signal_out_north_data = signal_in_data report "Data Mismatch" severity failure;
            signal_out_north_ack <= not signal_out_north_ack;

            insert_data_package_from_stim_vector(2);
            wait until signal_out_north_east_req'event;
            wait for 10 ns;
            assert signal_out_north_east_data = signal_in_data report "Data Mismatch" severity failure;
            signal_out_north_east_ack <= not signal_out_north_east_ack;

            insert_data_package_from_stim_vector(3);
            wait until signal_out_east_req'event;
            wait for 10 ns;
            assert signal_out_east_data = signal_in_data report "Data Mismatch" severity failure;
            signal_out_east_ack <= not signal_out_east_ack;

            wait for 100 ns;
            insert_data_package_from_stim_vector(4);
            wait until signal_out_south_east_req'event;
            wait for 10 ns;
            assert signal_out_south_east_data = signal_in_data report "Data Mismatch" severity failure;
            signal_out_south_east_ack <= not signal_out_south_east_ack;

            insert_data_package_from_stim_vector(5);
            wait until signal_out_south_req'event;
            wait for 10 ns;
            assert signal_out_south_data = signal_in_data report "Data Mismatch" severity failure;
            signal_out_south_ack <= not signal_out_south_ack;

            insert_data_package_from_stim_vector(6);
            wait until signal_out_south_west_req'event;
            wait for 10 ns;
            assert signal_out_south_west_data = signal_in_data report "Data Mismatch" severity failure;
            signal_out_south_west_ack <= not signal_out_south_west_ack;

            insert_data_package_from_stim_vector(7);
            wait until signal_out_west_req'event;
            wait for 10 ns;
            assert signal_out_west_data = signal_in_data report "Data Mismatch" severity failure;
            signal_out_west_ack <= not signal_out_west_ack;
            assert false report "End of Test" severity failure;

        end process;

    end block tb;

    -- Reset Signal Goes Low
    signal_rst <= '0' after 50 ns;

end architecture rtl;