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
        -- for in_x in 0 to NOC_MESH_LENGTH - 1 loop
        -- for in_y in 0 to NOC_MESH_LENGTH - 1 loop
        --     for out_x in 0 to NOC_MESH_LENGTH - 1 loop
        --     for out_y in 0 to NOC_MESH_LENGTH - 1 loop
        --         if in_x /= out_x and in_y /= out_y then
        --             local_req <= locals.local_out(out_x,out_y).req;
        --             locals.local_in(in_x, in_y).data <= "0001";--init_package_if(in_x, in_y, out_x, out_y);
        --             wait for 10*time_resolution;
        --             locals.local_in(in_x, in_y).req <= not locals.local_in(in_x, in_y).req;
        --             wait until local_req'event;
        --             assert locals.local_out(out_x,out_y).data = locals.local_in(in_x,in_y).data report "package failure from " & integer'image(in_x) & "," & integer'image(in_y) & " to " & integer'image(out_x) & "," & integer'image(out_y) severity failure;

        --             wait for 3*time_resolution;
        --             locals.local_in(out_x, out_y).ack <= not locals.local_in(out_x, out_y).ack;
        --         end if;
        --     end loop;
        --     end loop;
        -- end loop;
        -- end loop;
        local_req <= locals.local_out(2,2).req;
        locals.local_in(1, 1).data <= "1010";--init_package_if(in_x, in_y, out_x, out_y);
        wait for 10*time_resolution;
        locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
        wait until local_req'event;
        assert locals.local_out(2,2).data = locals.local_in(1, 1).data report "package failure" severity failure;
        wait for 3*time_resolution;
        locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
        end process;
    end block;
end architecture;