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
    signal locals    : arrif_local_connections_t := (others => (others => (others => (ack => '0', req => '0', data => (others => '0')))));
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
            function init_package_if(in_x, in_y, out_x, out_y : integer) return std_logic_vector is     
                variable package_return : std_logic_vector(NOC_DATA_WIDTH-1 downto 0);
                variable package_data : std_logic_vector(NOC_PACKAGE_WIDTH-1 downto 0);
                begin
                    package_data := std_logic_vector(to_unsigned(in_x, NOC_PACKAGE_WIDTH/2)) & std_logic_vector(to_unsigned(in_y, NOC_PACKAGE_WIDTH/2));
                    package_return := data_if_to_slv(init_data_if(0,1)) & package_data;
                    return package_return;
            end function;
        -- reset
        begin
            wait for time_resolution;
            rst <= '0';
            wait for 10*time_resolution;
        -- OUTER FOR-LOOP
        for in_x in 0 to NOC_MESH_LENGTH - 1 loop
        for in_y in 0 to NOC_MESH_LENGTH - 1 loop
            for out_x in 0 to NOC_MESH_LENGTH - 1 loop
            for out_y in 0 to NOC_MESH_LENGTH - 1 loop
                local_req <= locals(out_x,out_y).local_out.req;
                locals(in_x, in_y).local_in.data <= (others => '1');
                wait for 10*time_resolution;
                locals(in_x, in_y).local_in.req <= not locals(in_x, in_y).local_in.req;
                wait until local_req'event;
                assert locals(out_x,out_y).local_out.data = locals(in_x,in_y).local_in.data report "package failure from " & integer'image(in_x) & "," & integer'image(in_y) & " to " & integer'image(out_x) & "," & integer'image(out_y) severity failure;

                wait for 3*time_resolution;
                locals(out_x, out_y).local_out.ack <= not locals(out_x, out_y).local_out.ack;
            end loop;
            end loop;
        end loop;
        end loop;
        end process;
    end block;
end architecture;