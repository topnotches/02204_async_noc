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
    signal out_req_signal : std_logic;
    signal out_data_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    signal out_ack_signal : std_logic;

    -- Input channel
    signal in_req_0_signal : std_logic;
    signal in_data_0_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    signal in_ack_0_signal : std_logic;

    signal in_req_1_signal : std_logic;
    signal in_data_1_signal : std_logic_vector(NOC_DATA_WIDTH - 1 downto 0);
    signal in_ack_1_signal : std_logic;
    
    signal start_in_1,start_in_2 : std_logic;
    constant time_resolution : time := 1 ns;
    begin
        rst_signal <= '0' after 0.1 ns;
        start_in_1 <= '1' after 1 ns;
        start_in_2 <= '1' after 2 ns;
        
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
            
            out_ack : process(out_req_signal) begin       
                if out_ack_signal'event then     
                    out_ack_signal <= not(out_ack_signal);
                end if;
            end process;
            in_req_0: process(in_ack_0_signal,start_in_1)
                variable counter : integer := 0;
                variable data : integer := 0;
            begin
                if counter = 0 then
                    in_data_0_signal <= std_logic_vector(to_unsigned(data,NOC_DATA_WIDTH));
                    data := data + 2;
                    in_req_0_signal <= '1';
                    counter := 1;
                
                else
                    if in_ack_0_signal'event then
                        in_data_0_signal <= std_logic_vector(to_unsigned(data,NOC_DATA_WIDTH));
                        data := data + 2;
                        
                        in_req_0_signal <= not(in_req_0_signal);
                    end if;
                    if data = 10 then
                        finish;
                    end if;
                end if;
            end process;
            in_req_1: process(in_ack_1_signal,start_in_2)
                variable counter : integer := 0;
                variable data : integer := 1;
            begin
                if counter = 0 then
                    in_data_1_signal <= std_logic_vector(to_unsigned(data,NOC_DATA_WIDTH));
                    data := data + 2;
                    in_req_1_signal <= '1';
                    counter := 1;
                else
                    if in_ack_1_signal'event then
                        in_data_1_signal <= std_logic_vector(to_unsigned(data,NOC_DATA_WIDTH));
                        data := data + 2;
                        in_req_1_signal <= not(in_req_1_signal);
                    end if;
                end if;
            end process;
            time_res: process begin
                wait for time_resolution;
            end process;
        end block;
end architecture;