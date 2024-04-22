library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity subtract_tb is

end entity subtract_tb;
architecture rtl of subtract_tb is

  type arr_stim_4_bits_t is array (0 to 7) of std_logic_vector(3 downto 0);
  type arr_stim_3_bits_t is array (0 to 7) of std_logic_vector(2 downto 0);
  type arr_stim_2_bits_t is array (0 to 7) of std_logic_vector(1 downto 0);
  type arr_stim_1_bits_t is array (0 to 7) of std_logic_vector(0 downto 0);

  signal sarr_stim_4_bits_a : arr_stim_4_bits_t :=
  ("0111",
  "0001",
  "0001",
  "0011",
  "0100",
  "0101",
  "0100",
  "0100"
  );
  signal sarr_stim_4_bits_b : arr_stim_4_bits_t :=
  ("1111",
  "1001",
  "1001",
  "0111",
  "0001",
  "0001",
  "0000",
  "0000"
  );
  signal sarr_stim_3_bits_a : arr_stim_3_bits_t :=
  ("111",
  "111",
  "110",
  "101",
  "011",
  "101",
  "011",
  "001"
  );
  signal sarr_stim_3_bits_b : arr_stim_3_bits_t :=
  ("111",
  "111",
  "111",
  "111",
  "001",
  "100",
  "001",
  "000"
  );
  signal sarr_stim_2_bits_a : arr_stim_2_bits_t := ("10",
  "01",
  "11",
  "01",
  "01",
  "11",
  "10",
  "01"
  );
  signal sarr_stim_2_bits_b : arr_stim_2_bits_t := ("11",
  "11",
  "11",
  "11",
  "00",
  "10",
  "00",
  "11"
  );
  signal sarr_stim_1_bits_a : arr_stim_1_bits_t := ("1",
  "1",
  "1",
  "1",
  "0",
  "0",
  "0",
  "0"
  );
  signal sarr_stim_1_bits_b : arr_stim_1_bits_t := ("0",
  "0",
  "0",
  "0",
  "1",
  "1",
  "1",
  "1"
  );
  signal my_selector : natural range 0 to 7         := 0;
  signal sign_out    : std_logic_vector(3 downto 0) := (others => '0');
begin
  DUT_subtract_4b : entity work.compare_sign_slv_diff_rtl(rtl)
    generic
    map(
    SUBTRACT_LENGTH => 4
    )
    port map
    (
      sub_a    => sarr_stim_4_bits_a(my_selector),
      sub_b    => sarr_stim_4_bits_b(my_selector),
      sign_out => sign_out(4 - 1)
    );
  DUT_subtract_3b : entity work.compare_sign_slv_diff_rtl(rtl)
    generic
    map(
    SUBTRACT_LENGTH => 3
    )
    port
    map
    (
    sub_a    => sarr_stim_3_bits_a(my_selector),
    sub_b    => sarr_stim_3_bits_b(my_selector),
    sign_out => sign_out(3 - 1)
    );
  DUT_subtract_2b : entity work.compare_sign_slv_diff_rtl(rtl)
    generic
    map(
    SUBTRACT_LENGTH => 2
    )
    port
    map
    (
    sub_a    => sarr_stim_2_bits_a(my_selector),
    sub_b    => sarr_stim_2_bits_b(my_selector),
    sign_out => sign_out(2 - 1)
    );

  DUT_subtract_1b : entity work.compare_sign_slv_diff_rtl(rtl)
    generic
    map(
    SUBTRACT_LENGTH => 1
    )
    port
    map
    (
    sub_a    => sarr_stim_1_bits_a(my_selector),
    sub_b    => sarr_stim_1_bits_b(my_selector),
    sign_out => sign_out(1 - 1)
    );

  -- Testbench for diagonal input
  TB : block
  begin
    process
    begin
      if my_selector < 7 then
        my_selector <= my_selector + 1;
      else
        my_selector <= 0;
      end if;
      wait for 10 ns;

    end process;
  end block;
end architecture;