library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;

entity compare_slv_sign_diff_rtl is
    generic
    (
        SUBTRACT_LENGTH : natural := NOC_ADDRESS_WIDTH
    );
    port
    (
        sub_a    : in std_logic_vector(SUBTRACT_LENGTH - 1 downto 0);
        sub_b    : in std_logic_vector(SUBTRACT_LENGTH - 1 downto 0);
        sign_out : out std_logic

    );
end entity;

architecture rtl of compare_slv_sign_diff_rtl is

    signal ss_subtract : signed(SUBTRACT_LENGTH downto 0);

begin
    ss_subtract <= signed('0' & sub_a) - signed('0' & sub_b);

    -- Note, only supported in VHDL-2008.
    -- For reference in Vivado:
    -- https://vhdlwhiz.com/snippets/vivado-set-vhdl-2019-or-2008-for-all-vhd-files/
    sign_out <= ss_subtract(ss_subtract'left);

end architecture;