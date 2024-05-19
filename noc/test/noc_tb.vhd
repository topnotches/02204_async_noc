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
            locals.local_in(0, 0).data <= init_package_if(0, 0, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(0, 0).data <= init_package_if(0, 0, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 0).req <= not locals.local_in(0, 0).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(0,0).data report "package failure from " & integer'image(0) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(1, 0).data <= init_package_if(1, 0, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 0).req <= not locals.local_in(1, 0).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(1,0).data report "package failure from " & integer'image(1) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(2, 0).data <= init_package_if(2, 0, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 0).req <= not locals.local_in(2, 0).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(2,0).data report "package failure from " & integer'image(2) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(3, 0).data <= init_package_if(3, 0, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 0).req <= not locals.local_in(3, 0).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(3,0).data report "package failure from " & integer'image(3) & "," & integer'image(0) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(0, 1).data <= init_package_if(0, 1, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 1).req <= not locals.local_in(0, 1).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(0,1).data report "package failure from " & integer'image(0) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(1, 1).data <= init_package_if(1, 1, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 1).req <= not locals.local_in(1, 1).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(1,1).data report "package failure from " & integer'image(1) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(2, 1).data <= init_package_if(2, 1, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 1).req <= not locals.local_in(2, 1).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(2,1).data report "package failure from " & integer'image(2) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(3, 1).data <= init_package_if(3, 1, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 1).req <= not locals.local_in(3, 1).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(3,1).data report "package failure from " & integer'image(3) & "," & integer'image(1) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(0, 2).data <= init_package_if(0, 2, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 2).req <= not locals.local_in(0, 2).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(0,2).data report "package failure from " & integer'image(0) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(1, 2).data <= init_package_if(1, 2, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 2).req <= not locals.local_in(1, 2).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(1,2).data report "package failure from " & integer'image(1) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(2, 2).data <= init_package_if(2, 2, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 2).req <= not locals.local_in(2, 2).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(2,2).data report "package failure from " & integer'image(2) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(3, 2).data <= init_package_if(3, 2, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 2).req <= not locals.local_in(3, 2).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(3,2).data report "package failure from " & integer'image(3) & "," & integer'image(2) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(0, 3).data <= init_package_if(0, 3, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(0, 3).req <= not locals.local_in(0, 3).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(0,3).data report "package failure from " & integer'image(0) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                            
            locals.local_in(1, 3).data <= init_package_if(1, 3, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(1, 3).req <= not locals.local_in(1, 3).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(1,3).data report "package failure from " & integer'image(1) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(2, 3).data <= init_package_if(2, 3, 3, 3);
            wait for 10*time_resolution;
            locals.local_in(2, 3).req <= not locals.local_in(2, 3).req;
            wait until locals.local_out(3,3)'event;
            assert locals.local_out(3,3).data = locals.local_in(2,3).data report "package failure from " & integer'image(2) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 3).ack <= not locals.local_in(3, 3).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 0, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(0,0)'event;
            assert locals.local_out(0,0).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 0).ack <= not locals.local_in(0, 0).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 1, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(1,0)'event;
            assert locals.local_out(1,0).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 0).ack <= not locals.local_in(1, 0).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 2, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(2,0)'event;
            assert locals.local_out(2,0).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 0).ack <= not locals.local_in(2, 0).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 3, 0);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(3,0)'event;
            assert locals.local_out(3,0).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(0) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 0).ack <= not locals.local_in(3, 0).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 0, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(0,1)'event;
            assert locals.local_out(0,1).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 1).ack <= not locals.local_in(0, 1).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 1, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(1,1)'event;
            assert locals.local_out(1,1).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 1).ack <= not locals.local_in(1, 1).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 2, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(2,1)'event;
            assert locals.local_out(2,1).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 1).ack <= not locals.local_in(2, 1).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 3, 1);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(3,1)'event;
            assert locals.local_out(3,1).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(1) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 1).ack <= not locals.local_in(3, 1).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 0, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(0,2)'event;
            assert locals.local_out(0,2).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 2).ack <= not locals.local_in(0, 2).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 1, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(1,2)'event;
            assert locals.local_out(1,2).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 2).ack <= not locals.local_in(1, 2).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 2, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(2,2)'event;
            assert locals.local_out(2,2).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 2).ack <= not locals.local_in(2, 2).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 3, 2);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(3,2)'event;
            assert locals.local_out(3,2).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(3) & "," & integer'image(2) severity failure;

            wait for 3*time_resolution;
            locals.local_in(3, 2).ack <= not locals.local_in(3, 2).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 0, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(0,3)'event;
            assert locals.local_out(0,3).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(0) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(0, 3).ack <= not locals.local_in(0, 3).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 1, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(1,3)'event;
            assert locals.local_out(1,3).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(1) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(1, 3).ack <= not locals.local_in(1, 3).ack;
                            
            locals.local_in(3, 3).data <= init_package_if(3, 3, 2, 3);
            wait for 10*time_resolution;
            locals.local_in(3, 3).req <= not locals.local_in(3, 3).req;
            wait until locals.local_out(2,3)'event;
            assert locals.local_out(2,3).data = locals.local_in(3,3).data report "package failure from " & integer'image(3) & "," & integer'image(3) & " to " & integer'image(2) & "," & integer'image(3) severity failure;

            wait for 3*time_resolution;
            locals.local_in(2, 3).ack <= not locals.local_in(2, 3).ack;
                                assert false report "End of Testbench" severity FAILURE;
end process;
end block;
end architecture;