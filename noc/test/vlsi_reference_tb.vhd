library IEEE;
use IEEE.std_logic_1164.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_signed.all;
use ieee.math_real.all;
entity E is
    generic (
        GENERIC_SEED_1 : integer := 11;
        GENERIC_SEED_2 : integer := 55
        
    );
end E;

architecture A of E is

    signal CLOCK        : std_logic;
    signal RESET        : std_logic;
    signal ENABLE       : std_logic;
    signal QK           : std_logic_vector (7 downto 0);
    signal Q            : std_logic_vector (31 downto 0);
    constant iterations : integer range 0 to 999999 := 0;
    component SHIFTREG
        port
        (
            pl_sr_clk_i  : in std_logic;
            pl_reset_i   : in std_logic;
            pl_enable_i  : in std_logic;
            plv8_data_i  : in std_logic_vector (7 downto 0);
            plv32_data_o : inout std_logic_vector (31 downto 0));
    end component;

begin
    UUT : SHIFTREG
    port map
        (CLOCK, RESET, ENABLE, QK, Q);

    TB : block
    begin
        process
            constant NLOOPS            : integer := 200;
            file cmdfile               : TEXT; -- Define the file 'handle'
            variable line_in, line_out : Line; -- Line buffers
            variable good              : boolean; -- Status of the read operations
            variable A, B              : std_logic_vector(7 downto 0);
            variable S                 : std_logic_vector(55 downto 0);
            variable Z                 : std_logic_vector(31 downto 0);
            variable ERR               : std_logic_vector(55 downto 0);
            variable c                 : integer;
            variable seed1             : integer                   := GENERIC_SEED_1;
            variable seed2             : integer                   := GENERIC_SEED_2;
            variable counter           : integer range 0 to 999999 := 0;

            -- constant TEST_PASSED: string := "Test passed:";
            -- constant TEST_FAILED: string := "Test FAILED:";
            impure function rand_slv(len : integer) return std_logic_vector is
                variable r                   : real;
                variable slv                 : std_logic_vector(len - 1 downto 0);
            begin
                for i in slv'range loop
                    uniform(seed1, seed2, r);
                    if r > 0.5 then
                        slv(i) := '1';
                    else
                        slv(i) := '0';
                    end if;
                    
                end loop;
                return slv;
            end function;
        begin
            c := 0;
            FILE_OPEN(cmdfile, "testvecs.in", READ_MODE);

            reset <= '0';
            clock <= '1';
            wait for 5 ns;
            reset  <= '1';
            ENABLE <= '1';
            clock  <= '0';
            wait for 5 ns;

            -- -------------------------------------------------------------------------
            loop
                if (counter = NLOOPS) then -- Check EOF
                    assert false
                    report "End of test encountered; exiting."
                        severity NOTE;
                    exit;
                end if;
                QK(7 downto 0) <= rand_slv(8);

                clock <= '1';
                wait for 5 ns;
                clock <= '0';
                wait for 5 ns;

                Z(31 downto 0) := Q(31 downto 0);

                if (c = 4) then
                    write(line_out, string'(" -> "));
                    hwrite(line_out, Z, RIGHT, 8);
                    writeline(OUTPUT, line_out); -- write the message
                    c := 0;
                end if;
                write(line_out, string'("byte "));
                write(line_out, c);
                write(line_out, string'(" : "));
                hwrite(line_out, QK, RIGHT, 2);
                if (c < 3) then
                    writeline(OUTPUT, line_out); -- write the message
                end if;
                --assert (Z = S) report "Z does not match in pattern " severity error;
                c       := c + 1;
                counter := counter + 1;
            end loop;
            -- -------------------------------------------------------------------------

            write(line_out, string'("--------- END SHIFT REG ------------------"));
            writeline(OUTPUT, line_out);

            -- ===============================================================
            clock <= '1';
            wait for 1000 ns;
            assert q = "11111111111111111111111111111111"
            report "--------- END SIMULATION  ------------------ " severity error;
                -- ===============================================================
            end process;
        end block;
    end A;

    configuration CFG_tb_shiftreg_STRUCTURAL of E is
        for A
            for UUT : SHIFTREG
                -- use configuration WORK.CFG_SHIFTREG_STRUCTURAL;
            end for;

            for TB
            end for;

        end for;
    end CFG_tb_shiftreg_STRUCTURAL;