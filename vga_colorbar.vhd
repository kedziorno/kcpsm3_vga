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

entity vga_colorbar is
port (
i_clock, i_reset : in std_logic;
i_vga_blank : in std_logic;
o_vga_color : out std_logic_vector (5 downto 0)
);
end entity vga_colorbar;

architecture behavioral of vga_colorbar is

  constant c_cnr : integer := 64;
  constant c_max : integer := 640;
  signal   index : integer range 0 to c_max - 1;

begin

  p_bars : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      index <= 0;
    elsif (rising_edge (i_clock)) then
      if (i_vga_blank = '0') then
        if (index = c_max - 1) then
          index <= 0;
        else
          index <= index + 1;
        end if;
      end if;
      case (index) is
        when 000 to 009 => o_vga_color <= c_color (00);
        when 010 to 019 => o_vga_color <= c_color (01);
        when 020 to 029 => o_vga_color <= c_color (02);
        when 030 to 039 => o_vga_color <= c_color (03);
        when 040 to 049 => o_vga_color <= c_color (04);
        when 050 to 059 => o_vga_color <= c_color (05);
        when 060 to 069 => o_vga_color <= c_color (06);
        when 070 to 079 => o_vga_color <= c_color (07);
        when 080 to 089 => o_vga_color <= c_color (08);
        when 090 to 099 => o_vga_color <= c_color (09);
        when 100 to 109 => o_vga_color <= c_color (10);
        when 110 to 119 => o_vga_color <= c_color (11);
        when 120 to 129 => o_vga_color <= c_color (12);
        when 130 to 139 => o_vga_color <= c_color (13);
        when 140 to 149 => o_vga_color <= c_color (14);
        when 150 to 159 => o_vga_color <= c_color (15);
        when 160 to 169 => o_vga_color <= c_color (16);
        when 170 to 179 => o_vga_color <= c_color (17);
        when 180 to 189 => o_vga_color <= c_color (18);
        when 190 to 199 => o_vga_color <= c_color (19);
        when 200 to 209 => o_vga_color <= c_color (20);
        when 210 to 219 => o_vga_color <= c_color (21);
        when 220 to 229 => o_vga_color <= c_color (22);
        when 230 to 239 => o_vga_color <= c_color (23);
        when 240 to 249 => o_vga_color <= c_color (24);
        when 250 to 259 => o_vga_color <= c_color (25);
        when 260 to 269 => o_vga_color <= c_color (26);
        when 270 to 279 => o_vga_color <= c_color (27);
        when 280 to 289 => o_vga_color <= c_color (28);
        when 290 to 299 => o_vga_color <= c_color (29);
        when 300 to 309 => o_vga_color <= c_color (30);
        when 310 to 319 => o_vga_color <= c_color (31);
        when 320 to 329 => o_vga_color <= c_color (32);
        when 330 to 339 => o_vga_color <= c_color (33);
        when 340 to 349 => o_vga_color <= c_color (34);
        when 350 to 359 => o_vga_color <= c_color (35);
        when 360 to 369 => o_vga_color <= c_color (36);
        when 370 to 379 => o_vga_color <= c_color (37);
        when 380 to 389 => o_vga_color <= c_color (38);
        when 390 to 399 => o_vga_color <= c_color (39);
        when 400 to 409 => o_vga_color <= c_color (40);
        when 410 to 419 => o_vga_color <= c_color (41);
        when 420 to 429 => o_vga_color <= c_color (42);
        when 430 to 439 => o_vga_color <= c_color (43);
        when 440 to 449 => o_vga_color <= c_color (44);
        when 450 to 459 => o_vga_color <= c_color (45);
        when 460 to 469 => o_vga_color <= c_color (46);
        when 470 to 479 => o_vga_color <= c_color (47);
        when 480 to 489 => o_vga_color <= c_color (48);
        when 490 to 499 => o_vga_color <= c_color (49);
        when 500 to 509 => o_vga_color <= c_color (50);
        when 510 to 519 => o_vga_color <= c_color (51);
        when 520 to 529 => o_vga_color <= c_color (52);
        when 530 to 539 => o_vga_color <= c_color (53);
        when 540 to 549 => o_vga_color <= c_color (54);
        when 550 to 559 => o_vga_color <= c_color (55);
        when 560 to 569 => o_vga_color <= c_color (56);
        when 570 to 579 => o_vga_color <= c_color (57);
        when 580 to 589 => o_vga_color <= c_color (58);
        when 590 to 599 => o_vga_color <= c_color (59);
        when 600 to 609 => o_vga_color <= c_color (60);
        when 610 to 619 => o_vga_color <= c_color (61);
        when 620 to 629 => o_vga_color <= c_color (62);
        when 630 to 639 => o_vga_color <= c_color (63);
      end case;
    end if;
  end process p_bars;

end architecture behavioral;