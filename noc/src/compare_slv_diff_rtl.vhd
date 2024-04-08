library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;

entity compare_slv_diff_rtl is
  generic
  (
    COMPARE_LENGTH : natural := 1
  );
  port
  (
    comp_a  : in std_logic_vector(COMPARE_LENGTH - 1 downto 0);
    comp_b  : in std_logic_vector(COMPARE_LENGTH - 1 downto 0);
    is_diff : out std_logic

  );
end entity;

architecture rtl of compare_slv_diff_rtl is

  signal slv_bitwise_xor : std_logic_vector(COMPARE_LENGTH - 1 downto 0);

begin
  XOR_GEN : for i in 0 to (COMPARE_LENGTH - 1) generate
    slv_bitwise_xor(i) <= comp_a(i) xor comp_b(i);
  end generate;

  -- Note, only supported in VHDL-2008.
  -- For reference in Vivado:
  -- https://vhdlwhiz.com/snippets/vivado-set-vhdl-2019-or-2008-for-all-vhd-files/
  is_diff <= or slv_bitwise_xor;

end architecture;