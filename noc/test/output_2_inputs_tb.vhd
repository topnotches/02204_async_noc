library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.finish;
use work.noc_defs_pkg.all;
use work.data_if_pkg.all;
use work.output_2_inputs;


entity output_2_inputs_tb is
end entity;

architecture behavioral of output_2_inputs_tb is
    signal rst_signal : std_logic := '1';
    --Output channel
    signal out_req_signal : std_logic := '0';
    signal out_data_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal out_ack_signal : std_logic := '0';

    -- Input channel
    signal in_req_0_signal : std_logic := '0';
    signal in_data_0_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal in_ack_0_signal : std_logic := '0';

    signal in_req_1_signal : std_logic := '0';
    signal in_data_1_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal in_ack_1_signal : std_logic := '0';
    
    signal old_out_req_signal : std_logic := '0';
    signal old_in_ack_1_signal, old_in_ack_0_signal : std_logic := '0';
    
    constant time_resolution : time := 2 ns;
    begin
        
        
        DUT: entity work.output_2_inputs
        generic map (buffer_length => 1)
        port map(
            rst => rst_signal,
            -- Output channel
            out_req => out_req_signal,
            out_data => out_data_signal,
            out_ack => out_ack_signal,

            -- Input channel
            in_req_0 => in_req_0_signal,
            in_data_0 => in_data_0_signal,
            in_ack_0 => in_ack_0_signal,

            in_req_1 => in_req_1_signal,
            in_data_1 => in_data_1_signal,
            in_ack_1 => in_ack_1_signal);

        
        TB: block begin
            
                 
            
            
            process

                variable data_0 : integer := 5;
                variable data_1 : integer := 7;
            begin
            
                wait for time_resolution;
                rst_signal <= '0';
                wait for 10*time_resolution;
                in_data_0_signal <= std_logic_vector(to_unsigned(data_0,NOC_DATA_WIDTH));                
                wait for 10*time_resolution;
                in_req_0_signal <= '1';
                
                wait until out_req_signal'event;
                wait for 3*time_resolution;
                assert out_data_signal = in_data_0_signal report "Error in data" severity error;
                out_ack_signal <= not(out_ack_signal);

                in_data_1_signal <= std_logic_vector(to_unsigned(data_1,NOC_DATA_WIDTH));
                wait for 10*time_resolution;
                in_req_1_signal <= '1';

                wait until out_req_signal'event;
                wait for 3*time_resolution;
                assert out_data_signal = in_data_1_signal report "Error in data" severity error;
                out_ack_signal <= not(out_ack_signal);
                assert false report "End of test" severity failure;
            end process;
            
            
        end block;
end architecture;