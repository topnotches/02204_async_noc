LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.noc_defs_pkg.ALL;
USE work.data_if_pkg.ALL;

ENTITY buffer_tb IS
END buffer_tb;

ARCHITECTURE behavioral OF buffer_tb IS
    CONSTANT BUFFER_LENGTH : INTEGER := 4;

    -- Assuming NOC_ADDRESS_WIDTH, NOC_DATA_WIDTH are previously defined constants
    SIGNAL rst_signal : STD_LOGIC := '0';

    SIGNAL in_ack_signal : STD_LOGIC := '0';
    SIGNAL in_req_signal : STD_LOGIC := '0';
    SIGNAL in_data_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

    SIGNAL out_ack_signal : STD_LOGIC := '0';
    SIGNAL out_req_signal : STD_LOGIC := '0';
    SIGNAL out_data_signal : STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0) := (others => '0');

BEGIN

    DUT : ENTITY work.buffer_rtl
        GENERIC MAP (
            buffer_length => BUFFER_LENGTH
        )
        PORT MAP(
            rst => rst_signal,

            in_ack => in_ack_signal,
            in_req => in_req_signal,
            in_data => in_data_signal,

            out_ack => out_ack_signal,
            out_req => out_req_signal,
            out_data => out_data_signal
        );

  -- Testbench for diagonal input
  TB : block
  begin
    process
      constant DATA_PREP_DELAY : time := NOC_MISC_DELAY_10_NS;

      procedure insert_data(data : in std_logic_vector) is
      begin
        in_data_signal <= data;
        in_req_signal <= not in_req_signal;
        wait until in_ack_signal'event;
      end procedure;
    begin

      rst_signal <= '1';
      wait for 10 ns;
      rst_signal <= '0';
      wait for 10 ns;      
      insert_data("1111");
      insert_data("0101");
      insert_data("1010");
      insert_data("0111");
      wait for 100 ns;
      assert out_data_signal = "1111" report "Error in out_data_signal" severity error;
      out_ack_signal <= not out_ack_signal;

      wait until out_req_signal'event;
      wait for 10 ns;
      assert out_data_signal = "0101" report "Error in out_data_signal" severity error;
      out_ack_signal <= not out_ack_signal;

      wait until out_req_signal'event;
      wait for 10 ns;
      assert out_data_signal = "1010" report "Error in out_data_signal" severity error;
      out_ack_signal <= not out_ack_signal;

      wait until out_req_signal'event;
      wait for 10 ns;
      assert out_data_signal = "0111" report "Error in out_data_signal" severity error;
      out_ack_signal <= not out_ack_signal;

      assert false report "End of Testbench" severity FAILURE;
    end process;
  end block;
END ARCHITECTURE behavioral;