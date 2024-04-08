LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.noc_defs_pkg.ALL;

ENTITY compare_slv_diff_rtl IS
    generic (
        COMPARE_LENGTH : natural := 1;
    );
    PORT (
        comp_a : IN STD_LOGIC_VECTOR(COMPARE_LENGTH - 1 DOWNTO 0);
        comp_b : IN STD_LOGIC_VECTOR(COMPARE_LENGTH - 1 DOWNTO 0);
        is_diff : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE rtl OF compare_slv_diff_rtl IS
    
    SIGNAL slv_bitwise_xor : STD_LOGIC_VECTOR(COMPARE_LENGTH - 1 DOWNTO 0);

BEGIN
    XOR_GEN : FOR i IN 0 TO (COMPARE_LENGTH - 1) GENERATE
        slv_bitwise_xor(i) <= comp_a(i) XOR comp_b(i);
    END GENERATE;

    -- Note, only supported in VHDL-2008.
    -- For reference in Vivado:
    -- https://vhdlwhiz.com/snippets/vivado-set-vhdl-2019-or-2008-for-all-vhd-files/
    is_diff <= OR slv_bitwise_xor;
END ARCHITECTURE;