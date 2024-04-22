library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity kill_rtl is
  generic
  (
    KILL_LENGTH : integer := 1
  );
  port
  (
    pilv_kill_req : in std_logic_vector(KILL_LENGTH - 1 downto 0);
    polv_kill_ack : out std_logic_vector(KILL_LENGTH - 1 downto 0)
  );
end entity kill_rtl;

architecture rtl of kill_rtl is

begin

  TRINITY_GEN : for i in 0 to KILL_LENGTH - 1 generate
    polv_kill_ack(i) <= pilv_kill_req(i);
  end generate;

end architecture;