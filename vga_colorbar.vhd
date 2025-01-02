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
constant g_step_x : integer := 1;
constant g_step_y : integer := 1
);
port (
i_clock, i_reset : in std_logic;
i_vga_blank : in std_logic;
i_address : in std_logic_vector (13 downto 0);
o_vga_color : out std_logic_vector (5 downto 0)
);
end entity vga_colorbar;

architecture mosaic of vga_colorbar is

  constant c_cnr : integer := 64;

begin

  p_bars : process (i_clock, i_reset) is
    variable index_color : integer range 0 to c_cnr - 1;
  begin
    if (i_reset = '1') then
      index_color := 0;
    elsif (rising_edge (i_clock)) then
      if (i_vga_blank = '0') then
        if (index_color = c_cnr - 1) then
          index_color := 0;
        else
          index_color := index_color + 1;
        end if;
        o_vga_color <= c_color (index_color);
      end if;
    end if;
  end process p_bars;

end architecture mosaic;

architecture architecture_lsfr of vga_colorbar is

  component lsfr is
  port (
  i_clock, i_reset : in std_logic;
  o_lsfr : out std_logic_vector (5 downto 0)
  );
  end component lsfr;

  constant c_cnr : integer := 64;
  constant c_max_x : integer := 640;
  signal o_lsfr : std_logic_vector (5 downto 0);

begin

  p_bars : process (i_clock, i_reset) is
    variable index_x : integer range 0 to (c_max_x / g_step_x) - 1;
  begin
    if (i_reset = '1') then
      index_x := 0;
    elsif (rising_edge (i_clock)) then
      if (i_vga_blank = '0') then
        if (index_x = (c_max_x / g_step_x) - 1) then
          index_x := 0;
        else
          index_x := index_x + 1;
        end if;
      end if;
      case (index_x) is
        when 000 / g_step_x to 009 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 010 / g_step_x to 019 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 020 / g_step_x to 029 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 030 / g_step_x to 039 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 040 / g_step_x to 049 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 050 / g_step_x to 059 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 060 / g_step_x to 069 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 070 / g_step_x to 079 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 080 / g_step_x to 089 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 090 / g_step_x to 099 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 100 / g_step_x to 109 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 110 / g_step_x to 119 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 120 / g_step_x to 129 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 130 / g_step_x to 139 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 140 / g_step_x to 149 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 150 / g_step_x to 159 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 160 / g_step_x to 169 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 170 / g_step_x to 179 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 180 / g_step_x to 189 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 190 / g_step_x to 199 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 200 / g_step_x to 209 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 210 / g_step_x to 219 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 220 / g_step_x to 229 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 230 / g_step_x to 239 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 240 / g_step_x to 249 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 250 / g_step_x to 259 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 260 / g_step_x to 269 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 270 / g_step_x to 279 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 280 / g_step_x to 289 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 290 / g_step_x to 299 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 300 / g_step_x to 309 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 310 / g_step_x to 319 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 320 / g_step_x to 329 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 330 / g_step_x to 339 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 340 / g_step_x to 349 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 350 / g_step_x to 359 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 360 / g_step_x to 369 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 370 / g_step_x to 379 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 380 / g_step_x to 389 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 390 / g_step_x to 399 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 400 / g_step_x to 409 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 410 / g_step_x to 419 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 420 / g_step_x to 429 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 430 / g_step_x to 439 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 440 / g_step_x to 449 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 450 / g_step_x to 459 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 460 / g_step_x to 469 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 470 / g_step_x to 479 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 480 / g_step_x to 489 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 490 / g_step_x to 499 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 500 / g_step_x to 509 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 510 / g_step_x to 519 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 520 / g_step_x to 529 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 530 / g_step_x to 539 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 540 / g_step_x to 549 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 550 / g_step_x to 559 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 560 / g_step_x to 569 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 570 / g_step_x to 579 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 580 / g_step_x to 589 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 590 / g_step_x to 599 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 600 / g_step_x to 609 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 610 / g_step_x to 619 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 620 / g_step_x to 629 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 630 / g_step_x to 639 / g_step_x => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when others => o_vga_color <= (others => '0');
          --synthesis translate_off
          report "index_x : " & integer'image (index_x); -- XXX null
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

end architecture architecture_lsfr;
