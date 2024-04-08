LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY router_rtl I
    generic (
        left : std_logic;
        right : std_logic;
        top : std_logic;
        bottom : std_logic;

    );
    PORT (

    );
END ENTITY router_rtl;

ARCHITECTURE rtl OF router_rtl IS

BEGIN

    --INPUTS

    -- generate compare selectors
    DIAG_NE_INPUT : ENTITY work.diagonal_input(rtl)
        PORT MAP
        (

        );

    DIAG_SE_INPUT : ENTITY work.diagonal_input(rtl)
        PORT MAP
        (

        );

    DIAG_SW_INPUT : ENTITY work.diagonal_input(rtl)
        PORT MAP
        (

        );

    DIAG_NW_INPUT : ENTITY work.diagonal_input(rtl)
        PORT MAP
        (

        );

    --INPUTS

    -- generate compare selectors
    straight_NE_INPUT : ENTITY work.diagonal_input(rtl)
        PORT MAP
        (

        );

    straight_SE_INPUT : ENTITY work.diagonal_input(rtl)
        PORT MAP
        (

        );

    straight_SW_INPUT : ENTITY work.diagonal_input(rtl)
        PORT MAP
        (

        );

    straight_NW_INPUT : ENTITY work.diagonal_input(rtl)
        PORT MAP
        (

        );
        --output
    
        -- generate compare selectors
        DIAG_NE_OUTPUT : ENTITY work.diagonal_input(rtl)
            PORT MAP
            (
    
            );
    
        DIAG_SE_OUTPUT : ENTITY work.diagonal_input(rtl)
            PORT MAP
            (
    
            );
    
        DIAG_SW_OUTPUT : ENTITY work.diagonal_input(rtl)
            PORT MAP
            (
    
            );
    
        DIAG_NW_OUTPUT : ENTITY work.diagonal_input(rtl)
            PORT MAP
            (
    
            );
    
        --INPUTS
    
        -- generate compare selectors
        straight_NE_OUTPUT : ENTITY work.diagonal_input(rtl)
            PORT MAP
            (
    
            );
    
        straight_SE_OUTPUT : ENTITY work.diagonal_input(rtl)
            PORT MAP
            (
    
            );
    
        straight_SW_OUTPUT : ENTITY work.diagonal_input(rtl)
            PORT MAP
            (
    
            );
    
        straight_NW_OUTPUT : ENTITY work.diagonal_input(rtl)
            PORT MAP
            (
    
            );

END ARCHITECTURE;