library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.noc_defs_pkg.all;
entity noc_top_util_fnc_tb is

end entity noc_top_util_fnc_tb;

architecture rtl of noc_top_util_fnc_tb is

    function func_int_to_yint(arg_int : integer) return integer is
        variable v_ret_int                : integer;

    begin
        v_ret_int := to_integer(to_unsigned(arg_int, NOC_ADDRESS_WIDTH * 2)(NOC_ADDRESS_WIDTH * 2 - 1 downto NOC_ADDRESS_WIDTH));
        return v_ret_int;
    end function;

    function func_int_to_xint(arg_int : integer) return integer is
        variable v_ret_int                : integer;

    begin
        v_ret_int := to_integer(to_unsigned(arg_int, NOC_ADDRESS_WIDTH * 2)(NOC_ADDRESS_WIDTH - 1 downto 0));
        return v_ret_int;
    end function;

    function func_get_left_from_int(arg_int : integer) return std_logic is
        variable v_prelim_int                   : integer   := 0;
        variable v_ret_sl                       : std_logic := '0';

    begin
        v_prelim_int := func_int_to_xint(arg_int);
        if (v_prelim_int = 0) then
            v_ret_sl := '1';
        end if;
        return v_ret_sl;
    end function;
    function func_get_right_from_int(arg_int : integer) return std_logic is
        variable v_prelim_int                    : integer   := 0;
        variable v_ret_sl                        : std_logic := '0';

    begin
        v_prelim_int := func_int_to_xint(arg_int);
        if (v_prelim_int = 2 ** NOC_ADDRESS_WIDTH - 1) then
            v_ret_sl := '1';
        end if;
        return v_ret_sl;
    end function;
    function func_get_top_from_int(arg_int : integer) return std_logic is
        variable v_prelim_int                  : integer   := 0;
        variable v_ret_sl                      : std_logic := '0';

    begin
        v_prelim_int := func_int_to_yint(arg_int);
        if (v_prelim_int = 0) then
            v_ret_sl := '1';
        end if;
        return v_ret_sl;
    end function;
    function func_get_bottom_from_int(arg_int : integer) return std_logic is
        variable v_prelim_int                     : integer   := 0;
        variable v_ret_sl                         : std_logic := '0';

    begin
        v_prelim_int := func_int_to_yint(arg_int);
        if (v_prelim_int = 2 ** NOC_ADDRESS_WIDTH - 1) then
            v_ret_sl := '1';
        end if;
        return v_ret_sl;
    end function;

    signal sint_x : integer := 0;
    signal sint_y : integer := 0;
begin

    tb : block is
    begin

        process is
        begin
            for i in 0 to 15 loop
                wait for 10 ns;
                sint_x <= func_int_to_xint(i);
                sint_y <= func_int_to_yint(i);
            end loop;
        end process;

    end block tb;

end architecture;