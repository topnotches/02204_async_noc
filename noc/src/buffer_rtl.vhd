LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.data_pkg.ALL;
USE work.noc_defs_pkg.ALL;

entity buffer_rtl is 
    generic (
        buffer_length: integer;
    );
    port(
        --Reset input
        rst: IN STD_LOGIC;

        -- Input channels
        in_ack : OUT STD_LOGIC;
        in_req : IN STD_LOGIC;
        in_data : IN STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0);

        -- Output channels
        out_ack : IN STD_LOGIC;
        out_req : OUT STD_LOGIC;
        out_data : OUT STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0);
    );
end entity buffer_rtl;

ARCHITECTURE RTL OF buffer_rtl IS
    
    signal buffer_ack_array : STD_LOGIC_VECTOR( 0 to buffer_length - 1 );
    signal buffer_req_array : STD_LOGIC_VECTOR( 0 to buffer_length - 1 );
    
    type data_array is array ( 0 to buffer_length - 1 ) of STD_LOGIC_VECTOR(NOC_DATA_WIDTH - 1 downto 0);
    signal buffer_data_array : data_array;

    type click_element_array is array (natural range <>) of work.clickElement;
    signal clickElements : click_element_array(0 to buffer_length - 1);
BEGIN

    -- Input click element that is connected to the input of the buffer and the first element in the width long arrays
    input_click : ENTITY work.click_element(Behavioral)
    GENERIC MAP(
        DATA_WIDTH => NOC_DATA_WIDTH, -- Replace YOUR_DATA_WIDTH with your desired value
        VALUE => YOUR_VALUE, -- Replace YOUR_VALUE with your desired value
        PHASE_INIT => '0' -- Set PHASE_INIT to '0' as per your requirements
    )
    PORT MAP
    (
        rst => rst,
        in_ack => in_ack,
        in_req => in_req,
        in_data => in_data,
        out_ack => buffer_ack_array[0],
        out_req => buffer_req_array[0],
        out_data => data_array[0],
    );

    -- IDK if this makes any sense xd
    -- Generating click elements from the lists and buffer, except the first and last one which is connected to the input and output of the buffer itself
    middle_clicks : FOR i IN 1 TO buffer_length - 2 GENERATE
        mid_click_element : ENTITY work.click_element(Behavioral)
        GENERIC MAP(
            DATA_WIDTH => NOC_DATA_WIDTH, -- Replace YOUR_DATA_WIDTH with your desired value
            VALUE => YOUR_VALUE, -- Replace YOUR_VALUE with your desired value
            PHASE_INIT => '0' -- Set PHASE_INIT to '0' as per your requirements
        )
        PORT MAP
        (
            rst => rst,
            in_ack => buffer_ack_array[i-1],
            in_req => buffer_req_array[i-1],
            in_data => data_array[i-1],
            out_ack => buffer_ack_array[i+1],
            out_req => buffer_req_array[i+1],
            out_data => data_array[i+1],
        );
    END GENERATE;

    -- Output click element 
    -- Has the input from the last element in the buffers signals lists and data array
    -- The output is connected to the output of the buffer
    output_click : ENTITY work.click_element(Behavioral)
    GENERIC MAP(
        DATA_WIDTH => NOC_DATA_WIDTH, -- Replace YOUR_DATA_WIDTH with your desired value
        VALUE => YOUR_VALUE, -- Replace YOUR_VALUE with your desired value
        PHASE_INIT => '0' -- Set PHASE_INIT to '0' as per your requirements
    )
    PORT MAP(
        rst => rst,
        in_ack => buffer_ack_array[buffer_length - 1],
        in_req => buffer_req_array[buffer_length - 1],
        in_data => data_array[buffer_length - 1],
        out_ack => out_ack,
        out_req => out_req,
        out_data => out_data
    );

END ARCHITECTURE RTL;