library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.env.finish;
use work.noc_defs_pkg.all;
use work.data_if_pkg.all;
use work.router_rtl;
use work.noc_connections_pkg.all;
use work.noc_defs_pkg.all;

entity noc_tb is
end entity;

architecture behavioral of noc_tb is
    signal rst : std_logic := '1';
    signal local_req : std_logic := '0';
    signal locals    :local_connections_t := (local_in => (others => (others => (ack => '0', req => '0', data => (others => '0')))),local_out=>(others => (others => (ack => '0', req => '0', data => (others => '0')))));
    constant time_resolution : time := 2 ns;
    begin 
        DUT: entity work.noc_rtl(rtl)
        port map (
            rst => rst,
            in_locals => locals.local_in,
            out_locals => locals.local_out

        );
    TB: block begin  
        
        process   
            function init_package_if(in_y, in_x, out_y, out_x : integer) return std_logic_vector is     
                variable package_return : std_logic_vector(NOC_DATA_WIDTH-1 downto 0);
                variable package_data : std_logic_vector(NOC_PACKAGE_WIDTH-1 downto 0);
                begin
                    package_data := std_logic_vector(to_unsigned(in_y, NOC_PACKAGE_WIDTH/2)) & std_logic_vector(to_unsigned(in_x, NOC_PACKAGE_WIDTH/2));
                    package_return := data_if_to_slv(init_data_if(out_x,out_y)) & package_data;
                    return package_return;
            end function;
        -- reset
        begin
            wait for time_resolution;
            rst <= '0';
            wait for 10*time_resolution;