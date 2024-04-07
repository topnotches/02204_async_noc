LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.noc_defs_pkg.ALL;

ENTITY compare_slv_diff_rtl IS
    PORT (
        comp_a : IN STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0);
        comp_b : IN STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0);
        is_diff : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE rtl OF compare_slv_diff_rtl IS
    (
    SIGNAL slv_bitwise_xor : STD_LOGIC_VECTOR(NOC_ADDRESS_WIDTH - 1 DOWNTO 0);

BEGIN
    XOR_GEN : FOR i IN 0 TO (NOC_ADDRESS_WIDTH - 1) GENERATE
        slv_bitwise_xor <= comp_a(i) XOR comp_b(i);
    END GENERATE;

    is_diff <= OR slv_bitwise_xor;
END ARCHITECTURE;