LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.data_if_pkg.ALL;
USE work.noc_defs_pkg.ALL;

ENTITY buffer_rtl IS
    GENERIC (
        buffer_length: integer := 0
    );
    PORT(
        --Reset input
        rst: IN STD_LOGIC;

        -- Input channels
        in_ack : OUT STD_LOGIC;
        in_req : IN STD_LOGIC;
        in_data : IN STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0);

        -- Output channels
        out_ack : IN STD_LOGIC;
        out_req : OUT STD_LOGIC;
        out_data : OUT STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0)
    );
END ENTITY buffer_rtl;

ARCHITECTURE RTL OF buffer_rtl IS

    SIGNAL buffer_ack_array : STD_LOGIC_VECTOR( buffer_length downto 0) := (others => '0');
    SIGNAL buffer_req_array : STD_LOGIC_VECTOR( buffer_length downto 0) := (others => '0');

    TYPE data_array IS ARRAY (0 TO buffer_length) OF STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0);
    SIGNAL buffer_data_array : data_array  := (others => (others => '0'));
BEGIN
    in_ack <= buffer_ack_array(0);
    buffer_req_array(0) <= in_req;
    buffer_data_array(0) <= in_data;

    buffer_ack_array(buffer_ack_array'length - 1) <= out_ack;
    out_req <= buffer_req_array(buffer_req_array'length-1); 
    out_data <= buffer_data_array(buffer_data_array'length - 1);

    click_elements_generation : FOR i IN 0 TO buffer_length - 1 GENERATE
        click_element : ENTITY work.click_element(Behavioral)
        GENERIC MAP(
            DATA_WIDTH => NOC_DATA_WIDTH, -- Replace YOUR_DATA_WIDTH with your desired value
            VALUE => 0, -- Replace YOUR_VALUE with your desired value
            PHASE_INIT => '0' -- Set PHASE_INIT to '0' as per your requirements
        )
        PORT MAP(
            rst => rst,
            in_ack => buffer_ack_array(i),
            in_req => buffer_req_array(i),
            in_data => buffer_data_array(i),
            out_ack => buffer_ack_array(i+1),
            out_req => buffer_req_array(i+1),
            out_data => buffer_data_array(i+1)
        );
    END GENERATE;
END ARCHITECTURE RTL;