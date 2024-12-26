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
i_color : in std_logic_vector (2 downto 0);
i_blank : in std_logic;
o_r, o_g, o_b : out std_logic
);
end entity vga_rgb;

architecture behavioral of vga_rgb is

begin

  -- 8 colors RGB
  o_r <= i_color (2) when i_blank = '0' else '0';
  o_g <= i_color (1) when i_blank = '0' else '0';
  o_b <= i_color (0) when i_blank = '0' else '0';

end architecture behavioral;
