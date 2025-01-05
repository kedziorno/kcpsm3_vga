----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    01/05/2025
-- Design Name:
-- Module Name:    vga_clock_25mhz
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

use work.p_package1.all;

entity vga_clock_25mhz is
port (
i_clock, i_reset : in  std_logic;
o_vga_clock      : out std_logic
);
end entity vga_clock_25mhz;

architecture behavioral of vga_clock_25mhz is

  signal vga25_q   : integer range 0 to c_vga_clock_divider_25mhz - 1;
  signal vga_clock : std_logic;
begin

  o_vga_clock <= vga_clock;

  p_vga_clock_divider_25mhz : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      vga25_q     <= 0;
      vga_clock <= '0';
    elsif (rising_edge (i_clock)) then
      if (vga25_q = c_vga_clock_divider_25mhz - 1) then
        vga25_q     <= 0;
        vga_clock <= not vga_clock;
      else
        vga25_q     <= vga25_q + 1;
        vga_clock <= vga_clock;
      end if;
    end if;
  end process p_vga_clock_divider_25mhz;

end architecture behavioral;
