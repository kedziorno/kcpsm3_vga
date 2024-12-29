----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12/25/2024
-- Design Name:
-- Module Name:    vga_colorbar
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
use work.p_package1.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.numeric_std.all;

entity vga_colorbar is
generic (
constant g_step : integer := 1
);
port (
i_clock, i_reset : in std_logic;
i_vga_blank : in std_logic;
i_address : in std_logic_vector (13 downto 0);
o_vga_color : out std_logic_vector (5 downto 0)
);
end entity vga_colorbar;

architecture behavioral of vga_colorbar is

  component lsfr is
  port (
  i_clock, i_reset : in std_logic;
  o_lsfr : out std_logic_vector (5 downto 0)
  );
  end component lsfr;

  constant c_cnr : integer := 64;
  constant c_max : integer := 640;
  signal o_lsfr : std_logic_vector (5 downto 0);

begin

  p_bars : process (i_clock, i_reset) is
    variable index : integer range 0 to (c_max / g_step) - 1;
  begin
    if (i_reset = '1') then
      index := 0;
    elsif (rising_edge (i_clock)) then
      if (i_vga_blank = '0') then
        if (index = (c_max / g_step) - 1) then
          index := 0;
        else
          index := index + 1;
        end if;
      end if;
      case (index) is
        when 000 / g_step to 009 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 010 / g_step to 019 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 020 / g_step to 029 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 030 / g_step to 039 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 040 / g_step to 049 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 050 / g_step to 059 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 060 / g_step to 069 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 070 / g_step to 079 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 080 / g_step to 089 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 090 / g_step to 099 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 100 / g_step to 109 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 110 / g_step to 119 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 120 / g_step to 129 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 130 / g_step to 139 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 140 / g_step to 149 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 150 / g_step to 159 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 160 / g_step to 169 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 170 / g_step to 179 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 180 / g_step to 189 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 190 / g_step to 199 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 200 / g_step to 209 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 210 / g_step to 219 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 220 / g_step to 229 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 230 / g_step to 239 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 240 / g_step to 249 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 250 / g_step to 259 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 260 / g_step to 269 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 270 / g_step to 279 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 280 / g_step to 289 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 290 / g_step to 299 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 300 / g_step to 309 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 310 / g_step to 319 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 320 / g_step to 329 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 330 / g_step to 339 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 340 / g_step to 349 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 350 / g_step to 359 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 360 / g_step to 369 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 370 / g_step to 379 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 380 / g_step to 389 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 390 / g_step to 399 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 400 / g_step to 409 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 410 / g_step to 419 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 420 / g_step to 429 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 430 / g_step to 439 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 440 / g_step to 449 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 450 / g_step to 459 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 460 / g_step to 469 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 470 / g_step to 479 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 480 / g_step to 489 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 490 / g_step to 499 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 500 / g_step to 509 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 510 / g_step to 519 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 520 / g_step to 529 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 530 / g_step to 539 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 540 / g_step to 549 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 550 / g_step to 559 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 560 / g_step to 569 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 570 / g_step to 579 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 580 / g_step to 589 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 590 / g_step to 599 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 600 / g_step to 609 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 610 / g_step to 619 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 620 / g_step to 629 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 630 / g_step to 639 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when others => o_vga_color <= (others => '0');
          --synthesis translate_off
          report "index : " & integer'image (index); -- XXX null
          --synthesis translate_on
      end case;
    end if;
  end process p_bars;

  inst_lsfr : lsfr
  port map (
  i_clock => i_clock,
  i_reset => i_reset,
  o_lsfr  => o_lsfr
  );

end architecture behavioral;
