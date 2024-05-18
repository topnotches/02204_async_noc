library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.finish;
use work.noc_defs_pkg.all;
use work.data_if_pkg.all;
use work.router_rtl;


entity router_tb is
end entity;

architecture behavioral of router_tb is
        signal rst : std_logic := '1';

    -- DIAGONAL INPUT CHANNELS
        signal in_north_east_ack   : std_logic := '0';
        signal in_north_east_req   : std_logic := '0';
        signal in_north_east_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal in_north_west_ack   : std_logic := '0';
        signal in_north_west_req   : std_logic := '0';
        signal in_north_west_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal in_south_east_ack   : std_logic := '0';
        signal in_south_east_req   : std_logic := '0';
        signal in_south_east_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal in_south_west_ack   : std_logic := '0';
        signal in_south_west_req   : std_logic := '0';
        signal in_south_west_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- STRAIGTH INPUT CHANNELS
        signal in_north_ack        : std_logic := '0';
        signal in_north_req        : std_logic := '0';
        signal in_north_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal in_east_ack         : std_logic := '0';
        signal in_east_req         : std_logic := '0';
        signal in_east_data        : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal in_south_ack        : std_logic := '0';
        signal in_south_req        : std_logic := '0';
        signal in_south_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal in_west_ack         : std_logic := '0';
        signal in_west_req         : std_logic := '0';
        signal in_west_data        : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    -- DIAGONAL OUTPUT CHANNELS
        signal out_north_west_ack  : std_logic := '0';
        signal out_north_west_req  : std_logic := '0';
        signal out_north_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal out_north_east_ack  : std_logic := '0';
        signal out_north_east_req  : std_logic := '0';
        signal out_north_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal out_south_east_ack  : std_logic := '0';
        signal out_south_east_req  : std_logic := '0';
        signal out_south_east_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal out_south_west_ack  : std_logic := '0';
        signal out_south_west_req  : std_logic := '0';
        signal out_south_west_data : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- STRAIGHT OUTPUT CHANNELS
        signal out_north_ack       : std_logic := '0';
        signal out_north_req       : std_logic := '0';
        signal out_north_data      : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal out_east_ack        : std_logic := '0';
        signal out_east_req        : std_logic := '0';
        signal out_east_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal out_south_ack       : std_logic := '0';
        signal out_south_req       : std_logic := '0';
        signal out_south_data      : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

        signal out_west_ack        : std_logic := '0';
        signal out_west_req        : std_logic := '0';
        signal out_west_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- Output to local port
        signal out_local_ack        : std_logic := '0';
        signal out_local_req        : std_logic := '0';
        signal out_local_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    -- Input for local ports to componenets
        signal in_local_ack         : std_logic := '0';
        signal in_local_req         : std_logic := '0';
        signal in_local_data        : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    
    constant time_resolution : time := 2 ns;
    begin
        DUT: entity work.router_rtl(rtl)
            generic map (
                left        => '0',
                right       => '0',
                top         => '0',
                bottom      => '0',
                address_x   => (0 => '1',
                                others => '0'),
                address_y   => (0 => '1',
                                others => '0'))
            port map(
                rst => rst,

                -- DIAGONAL INPUT CHANNELS
                in_north_east_ack => in_north_east_ack,
                in_north_east_req => in_north_east_req,
                in_north_east_data => in_north_east_data,
            
                in_north_west_ack => in_north_west_ack,
                in_north_west_req => in_north_west_req,
                in_north_west_data => in_north_west_data,
            
                in_south_east_ack => in_south_east_ack,
                in_south_east_req => in_south_east_req,
                in_south_east_data => in_south_east_data,
            
                in_south_west_ack => in_south_west_ack,
                in_south_west_req => in_south_west_req,
                in_south_west_data => in_south_west_data,
            
                -- STRAIGTH INPUT CHANNELS
                in_north_ack => in_north_ack,
                in_north_req => in_north_req,
                in_north_data => in_north_data,
            
                in_east_ack => in_east_ack,
                in_east_req => in_east_req,
                in_east_data => in_east_data,
            
                in_south_ack => in_south_ack,
                in_south_req => in_south_req,
                in_south_data => in_south_data,
            
                in_west_ack => in_west_ack,
                in_west_req => in_west_req,
                in_west_data => in_west_data,
            
                -- DIAGONAL OUTPUT CHANNELS
                out_north_west_ack => out_north_west_ack,
                out_north_west_req => out_north_west_req,
                out_north_west_data => out_north_west_data,
            
                out_north_east_ack => out_north_east_ack,
                out_north_east_req => out_north_east_req,
                out_north_east_data => out_north_east_data,
            
                out_south_east_ack => out_south_east_ack,
                out_south_east_req => out_south_east_req,
                out_south_east_data => out_south_east_data,
            
                out_south_west_ack => out_south_west_ack,
                out_south_west_req => out_south_west_req,
                out_south_west_data => out_south_west_data,
            
                -- STRAIGHT OUTPUT CHANNELS
                out_north_ack => out_north_ack,
                out_north_req => out_north_req,
                out_north_data => out_north_data,
            
                out_east_ack => out_east_ack,
                out_east_req => out_east_req,
                out_east_data => out_east_data,
            
                out_south_ack => out_south_ack,
                out_south_req => out_south_req,
                out_south_data => out_south_data,
            
                out_west_ack => out_west_ack,
                out_west_req => out_west_req,
                out_west_data => out_west_data,
            
                -- Output to local port
                out_local_ack => out_local_ack,
                out_local_req => out_local_req,
                out_local_data => out_local_data,
            
                -- Input for local ports to componenets
                in_local_ack => in_local_ack,
                in_local_req => in_local_req,
                in_local_data => in_local_data
                );

        
       

        
        TB: block begin           
            process
                variable data : integer := 0;
            begin
                wait for time_resolution;
                rst <= '0';
                wait for 10*time_resolution;
            -- NORTH INPUT TEST
                -- LOCAL PORT
                in_north_data <= data_if_to_slv(init_data_if(1,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));
                
                wait for 10*time_resolution;
                in_north_req <= not(in_north_req);
                
                wait until out_local_req'event;
                assert out_local_data = in_north_data report "north to local failed" severity failure;
                wait for time_resolution;
                out_local_ack <= not(out_local_ack);
                data := data + 1;
                -- SOUTH PORT
                in_north_data <= data_if_to_slv(init_data_if(1,0)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));
                wait for 10*time_resolution;
                in_north_req <= not(in_north_req);
                
                wait until out_south_req'event;
                assert out_south_data = in_north_data report "north to south failed" severity failure;
                out_south_ack <= not(out_south_ack);
                data := data + 1;
            -- SOUTH INPUT TEST
                -- LOCAL PORT
                in_south_data <= data_if_to_slv(init_data_if(1,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_req <= not(in_south_req);
                
                wait until out_local_req'event;
                assert out_local_data = in_south_data report "nouth to local failed" severity failure;
                out_local_ack <= not(out_local_ack);
                data := data + 1;
                -- NORTH PORT
                in_south_data <= data_if_to_slv(init_data_if(1,2)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_req <= not(in_south_req);
                
                wait until out_north_req'event;
                assert out_north_data = in_south_data report "nouth to north failed" severity failure;
                out_north_ack <= not(out_north_ack);
                data := data + 1;
            -- EAST INPUT TEST
                -- LOCAL PORT
                in_east_data <= data_if_to_slv(init_data_if(1,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_east_req <= not(in_east_req);
                
                wait until out_local_req'event;
                assert out_local_data = in_east_data report "east to local failed" severity failure;
                out_local_ack <= not(out_local_ack);
                data := data + 1;
                -- WEST PORT
                in_east_data <= data_if_to_slv(init_data_if(0,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_east_req <= not(in_east_req);
                
                wait until out_west_req'event;
                assert out_west_data = in_east_data report "east to west failed" severity failure;
                out_west_ack <= not(out_west_ack);
                data := data + 1;
            -- WEST INPUT TEST
                -- LOCAL PORT
                in_west_data <= data_if_to_slv(init_data_if(1,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_west_req <= not(in_west_req);
                
                wait until out_local_req'event;
                assert out_local_data = in_west_data report "west to local failed" severity failure;
                out_local_ack <= not(out_local_ack);
                data := data + 1;
                -- EAST PORT
                in_west_data <= data_if_to_slv(init_data_if(2,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_west_req <= not(in_west_req);
                
                wait until out_east_req'event;
                assert out_east_data = in_west_data report "west to east failed" severity failure;
                out_east_ack <= not(out_east_ack);
                data := data + 1;
            -- NORTH WEST INPUT TEST
                -- LOCAL PORT
                in_north_west_data <= data_if_to_slv(init_data_if(1,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_north_west_req <= not(in_north_west_req);
                
                wait until out_local_req'event;
                assert out_local_data = in_north_west_data report "north west to local failed" severity failure;
                wait for 3*time_resolution;
                out_local_ack <= not(out_local_ack);
                data := data + 1;
                -- SOUTH EAST PORT
                in_north_west_data <= data_if_to_slv(init_data_if(2,2)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_north_west_req <= not(in_north_west_req);
                
                wait until out_south_east_req'event;
                assert out_south_east_data = in_north_west_data report "north west to south east failed" severity failure;
                wait for 3*time_resolution;
                out_south_east_ack <= not(out_south_east_ack);
                data := data + 1;
                -- SOUTH PORT
                in_north_west_data <= data_if_to_slv(init_data_if(1,2)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_north_west_req <= not(in_north_west_req);

                wait until out_south_req'event;
                assert out_south_data = in_north_west_data report "north west to south failed" severity failure;
                wait for 3*time_resolution;
                out_south_ack <= not(out_south_ack);
                data := data + 1;
                -- EAST PORT
                in_north_west_data <= data_if_to_slv(init_data_if(2,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_north_west_req <= not(in_north_west_req);

                wait until out_east_req'event;
                assert out_east_data = in_north_west_data report "north west to east failed" severity failure;
                wait for 3*time_resolution;
                out_east_ack <= not(out_east_ack);
                data := data + 1;
            -- NORTH EAST INPUT TEST
                -- LOCAL PORT
                in_north_east_data <= data_if_to_slv(init_data_if(1,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_north_east_req <= not(in_north_east_req);
                
                wait until out_local_req'event;
                assert out_local_data = in_north_east_data report "north east to local failed" severity failure;
                wait for 3*time_resolution;
                out_local_ack <= not(out_local_ack);
                data := data + 1;
                -- SOUTH WEST PORT
                in_north_east_data <= data_if_to_slv(init_data_if(0,2)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_north_east_req <= not(in_north_east_req);
                
                wait until out_south_west_req'event;
                assert out_south_west_data = in_north_east_data report "north east to south west failed" severity failure;
                wait for 3*time_resolution;
                out_south_west_ack <= not(out_south_west_ack);
                data := data + 1;
                -- SOUTH PORT
                in_north_east_data <= data_if_to_slv(init_data_if(1,2)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_north_east_req <= not(in_north_east_req);

                wait until out_south_req'event;
                assert out_south_data = in_north_east_data report "north east to south failed" severity failure;
                wait for 3*time_resolution;
                out_south_ack <= not(out_south_ack);
                data := data + 1;
                -- WEST PORT
                in_north_east_data <= data_if_to_slv(init_data_if(0,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_north_east_req <= not(in_north_east_req);

                wait until out_west_req'event;
                assert out_west_data = in_north_east_data report "north east to west failed" severity failure;
                wait for 3*time_resolution;
                out_west_ack <= not(out_west_ack);
                data := data + 1;
            -- SOUTH WEST INPUT TEST
                -- LOCAL PORT
                in_south_west_data <= data_if_to_slv(init_data_if(1,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_west_req <= not(in_south_west_req);
                
                wait until out_local_req'event;
                assert out_local_data = in_south_west_data report "south west to local failed" severity failure;
                wait for 3*time_resolution;
                out_local_ack <= not(out_local_ack);
                data := data + 1;
                -- NORTH EAST PORT
                in_south_west_data <= data_if_to_slv(init_data_if(2,0)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_west_req <= not(in_south_west_req);
                
                wait until out_north_east_req'event;
                assert out_north_east_data = in_south_west_data report "south west to north east failed" severity failure;
                wait for 3*time_resolution;
                out_north_east_ack <= not(out_north_east_ack);
                data := data + 1;
                -- NORTH PORT
                in_south_west_data <= data_if_to_slv(init_data_if(1,2)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_west_req <= not(in_south_west_req);

                wait until out_north_req'event;
                assert out_north_data = in_south_west_data report "south west to north failed" severity failure;
                wait for 3*time_resolution;
                out_north_ack <= not(out_north_ack);
                data := data + 1;
                -- EAST PORT
                in_south_west_data <= data_if_to_slv(init_data_if(2,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_west_req <= not(in_south_west_req);

                wait until out_east_req'event;
                assert out_east_data = in_south_west_data report "south west to east failed" severity failure;
                wait for 3*time_resolution;
                out_east_ack <= not(out_east_ack);
                data := data + 1;
            -- SOUTH EAST INPUT TEST
                -- LOCAL PORT
                in_south_east_data <= data_if_to_slv(init_data_if(1,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_east_req <= not(in_south_east_req);
                
                wait until out_local_req'event;
                assert out_local_data = in_south_east_data report "south east to local failed" severity failure;
                wait for 3*time_resolution;
                out_local_ack <= not(out_local_ack);
                data := data + 1;
                -- NORTH WEST PORT
                in_south_east_data <= data_if_to_slv(init_data_if(0,0)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_east_req <= not(in_south_east_req);
                
                wait until out_north_west_req'event;
                assert out_north_west_data = in_south_east_data report "south east to north west failed" severity failure;
                wait for 3*time_resolution;
                out_north_west_ack <= not(out_north_west_ack);
                data := data + 1;
                -- NORTH PORT
                in_south_east_data <= data_if_to_slv(init_data_if(1,0)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_east_req <= not(in_south_east_req);

                wait until out_north_req'event;
                assert out_north_data = in_south_east_data report "south east to north failed" severity failure;
                wait for 3*time_resolution;
                out_north_ack <= not(out_north_ack);
                data := data + 1;
                -- WEST PORT
                in_south_east_data <= data_if_to_slv(init_data_if(0,1)) & std_logic_vector(to_unsigned(data,NOC_PACKAGE_WIDTH));

                wait for 10*time_resolution;
                in_south_east_req <= not(in_south_east_req);

                wait until out_west_req'event;
                assert out_west_data = in_south_east_data report "south east to west failed" severity failure;
                wait for 3*time_resolution;
                out_west_ack <= not(out_west_ack);
                data := data + 1;
            end process;
            
            
        end block;
end architecture;