----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12/26/2024
-- Design Name:
-- Module Name:    vga_rgb
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_rgb is
port (
i_clock, i_reset : in std_logic;
i_color : in  std_logic_vector (5 downto 0);
i_blank : in  std_logic;
o_r     : out std_logic_vector (1 downto 0);
o_g     : out std_logic_vector (1 downto 0);
o_b     : out std_logic_vector (1 downto 0)
);
end entity vga_rgb;

architecture behavioral of vga_rgb is

begin

  -- 64 colors RGB
  o_r (1) <= i_color (5) when i_blank = '0' else '0';
  o_r (0) <= i_color (4) when i_blank = '0' else '0';
  o_g (1) <= i_color (3) when i_blank = '0' else '0';
  o_g (0) <= i_color (2) when i_blank = '0' else '0';
  o_b (1) <= i_color (1) when i_blank = '0' else '0';
  o_b (0) <= i_color (0) when i_blank = '0' else '0';
--  p0 : process (i_clock, i_reset) is
--  begin
--    if (i_reset = '1') then
--      o_r <= (others => '0');
--      o_g <= (others => '0');
--      o_b <= (others => '0');
--    elsif (rising_edge (i_clock)) then
--      if (i_blank = '0') then
--        o_r (1) <= i_color (5);
--        o_r (0) <= i_color (4);
--        o_g (1) <= i_color (3);
--        o_g (0) <= i_color (2);
--        o_b (1) <= i_color (1);
--        o_b (0) <= i_color (0);
--      else
--        o_r <= (others => '0');
--        o_g <= (others => '0');
--        o_b <= (others => '0');
--      end if;
--    end if;
--  end process p0;

end architecture behavioral;
