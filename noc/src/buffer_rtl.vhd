library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity buffer_rtl is
    generic (
        buffer_len
    );
    port (
        clk   : in std_logic;
        reset : in std_logic;
        
    );
end entity buffer_rtl;

architecture rtl of buffer_rtl is

begin

    _GEN : for i in 0 to  generate
        
    end generate;

end architecture;