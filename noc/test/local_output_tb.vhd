library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.finish;
use work.noc_defs_pkg.all;
use work.data_if_pkg.all;
use work.output_4_inputs;


entity local_output_tb is
end entity;

architecture behavioral of local_output_tb is
    signal rst_signal : std_logic := '1';
    --Output channel
    signal out_req_signal : std_logic := '0';
    signal out_data_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal out_ack_signal : std_logic := '0';

    -- Input channel
    signal out_north_to_local_ack        : std_logic := '0';
    signal out_north_to_local_req        : std_logic := '0';
    signal out_north_to_local_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal out_south_to_local_ack        : std_logic := '0';
    signal out_south_to_local_req        : std_logic := '0';
    signal out_south_to_local_data       : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal out_east_to_local_ack         : std_logic := '0';
    signal out_east_to_local_req         : std_logic := '0';
    signal out_east_to_local_data        : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal out_west_to_local_ack         : std_logic := '0';
    signal out_west_to_local_req         : std_logic := '0';
    signal out_west_to_local_data        : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal out_south_east_to_local_ack   : std_logic := '0';
    signal out_south_east_to_local_req   : std_logic := '0';
    signal out_south_east_to_local_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal out_south_west_to_local_ack   : std_logic := '0';
    signal out_south_west_to_local_req   : std_logic := '0';
    signal out_south_west_to_local_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal out_north_east_to_local_ack   : std_logic := '0';
    signal out_north_east_to_local_req   : std_logic := '0';
    signal out_north_east_to_local_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal out_north_west_to_local_ack   : std_logic := '0';
    signal out_north_west_to_local_req   : std_logic := '0';
    signal out_north_west_to_local_data  : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');  
    constant time_resolution : time := 2 ns;
    begin
        
        
        DUT: entity work.local_output_rtl
        generic map (buffer_length => 1)
        port map(
            rst => rst_signal,
            -- Output channel
            out_req => out_req_signal,
            out_data => out_data_signal,
            out_ack => out_ack_signal,

            -- Input channel
            out_north_to_local_ack => out_north_to_local_ack,
            out_north_to_local_req => out_north_to_local_req,
            out_north_to_local_data => out_north_to_local_data,

            out_south_to_local_ack => out_south_to_local_ack,
            out_south_to_local_req => out_south_to_local_req, 
            out_south_to_local_data => out_south_to_local_data,

            out_east_to_local_ack => out_east_to_local_ack, 
            out_east_to_local_req => out_east_to_local_req,
            out_east_to_local_data => out_east_to_local_data,

            out_west_to_local_ack => out_west_to_local_ack,
            out_west_to_local_req => out_west_to_local_req,
            out_west_to_local_data => out_west_to_local_data,

            out_south_east_to_local_ack => out_south_east_to_local_ack,
            out_south_east_to_local_req => out_south_east_to_local_req,
            out_south_east_to_local_data => out_south_east_to_local_data,

            out_south_west_to_local_ack => out_south_west_to_local_ack,
            out_south_west_to_local_req => out_south_west_to_local_req, 
            out_south_west_to_local_data => out_south_west_to_local_data,

            out_north_east_to_local_ack => out_north_east_to_local_ack,
            out_north_east_to_local_req => out_north_east_to_local_req,
            out_north_east_to_local_data => out_north_east_to_local_data,

            out_north_west_to_local_ack => out_north_west_to_local_ack,
            out_north_west_to_local_req => out_north_west_to_local_req,
            out_north_west_to_local_data => out_north_west_to_local_data);

        
        TB: block begin
            
                 
            
            
            process
                variable counter : integer := 0;
                variable data_north : integer := 0;
                variable data_south : integer := 1;
                variable data_east : integer := 2;
                variable data_west : integer := 3;
                variable data_north_west : integer := 4;
                variable data_north_east : integer := 5;
                variable data_south_west : integer := 6;
                variable data_south_east : integer := 7;
            begin
            
                wait for time_resolution;
                rst_signal <= '0';
                wait for 10*time_resolution;
                -- NORTH
                out_north_to_local_data <= std_logic_vector(to_unsigned(data_north,NOC_DATA_WIDTH));
                data_north := data_north + 8;
                wait for 10*time_resolution;
                out_north_to_local_req <= not(out_north_to_local_req);
                
                wait for 50*time_resolution;
                out_ack_signal <= not(out_ack_signal);

                -- SOUTH
                out_south_to_local_data <= std_logic_vector(to_unsigned(data_south,NOC_DATA_WIDTH));
                data_south := data_south + 8;
                wait for 10*time_resolution;
                out_south_to_local_req <= not(out_south_to_local_req);
                
                wait for 50*time_resolution;
                out_ack_signal <= not(out_ack_signal);

                -- EAST
                out_east_to_local_data <= std_logic_vector(to_unsigned(data_east,NOC_DATA_WIDTH));
                data_east := data_east + 8;
                wait for 10*time_resolution;
                out_east_to_local_req <= not(out_east_to_local_req);
                
                wait for 50*time_resolution;
                out_ack_signal <= not(out_ack_signal);

                -- WEST
                out_west_to_local_data <= std_logic_vector(to_unsigned(data_west,NOC_DATA_WIDTH));
                data_west := data_west + 8;
                wait for 10*time_resolution;
                out_west_to_local_req <= not(out_west_to_local_req);
                
                wait for 50*time_resolution;
                out_ack_signal <= not(out_ack_signal);
                
                -- NORTH WEST
                out_north_west_to_local_data <= std_logic_vector(to_unsigned(data_north_west,NOC_DATA_WIDTH));
                data_north_west := data_north_west + 8;
                wait for 10*time_resolution;
                out_north_west_to_local_req <= not(out_north_west_to_local_req);
                
                wait for 50*time_resolution;
                out_ack_signal <= not(out_ack_signal);

                -- NORTH EAST
                out_north_east_to_local_data <= std_logic_vector(to_unsigned(data_north_east,NOC_DATA_WIDTH));
                data_north_east := data_north_east + 8;
                wait for 10*time_resolution;
                out_north_east_to_local_req <= not(out_north_east_to_local_req);
                
                wait for 50*time_resolution;
                out_ack_signal <= not(out_ack_signal);

                -- SOUTH WEST
                out_south_west_to_local_data <= std_logic_vector(to_unsigned(data_south_west,NOC_DATA_WIDTH));
                data_south_west := data_south_west + 8;
                wait for 10*time_resolution;
                out_south_west_to_local_req <= not(out_south_west_to_local_req);
                
                wait for 50*time_resolution;
                out_ack_signal <= not(out_ack_signal);

                -- SOUTH EAST
                out_south_east_to_local_data <= std_logic_vector(to_unsigned(data_south_east,NOC_DATA_WIDTH));
                data_south_east := data_south_east + 8;
                wait for 10*time_resolution;
                out_south_east_to_local_req <= not(out_south_west_to_local_req);
                
                wait for 50*time_resolution;
                out_ack_signal <= not(out_ack_signal);
            end process;
            
            
        end block;
end architecture;