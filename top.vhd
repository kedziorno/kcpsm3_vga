----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12/25/2024
-- Design Name:
-- Module Name:    top
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
port (
i_clock  : in  std_logic;
i_reset  : in  std_logic;
o_hsync  : out std_logic;
o_vsync  : out std_logic;
o_blank  : out std_logic;
o_r      : out std_logic_vector (1 downto 0);
o_g      : out std_logic_vector (1 downto 0);
o_b      : out std_logic_vector (1 downto 0)
);
end top;

architecture behavioral of top is

component vga_timing is
port (
i_clock : in  std_logic;
i_reset : in  std_logic;
o_hsync : out std_logic;
o_vsync : out std_logic;
o_blank : out std_logic
);
end component vga_timing;

component vga_rgb is
port (
i_color  : in  std_logic_vector (5 downto 0);
i_blank  : in  std_logic;
o_r      : out std_logic_vector (1 downto 0);
o_g      : out std_logic_vector (1 downto 0);
o_b      : out std_logic_vector (1 downto 0)
);
end component vga_rgb;

type t_color_array is array (63 downto 0) of std_logic_vector (5 downto 0);
constant c_color : t_color_array := (
  std_logic_vector (to_unsigned (63, 6)),
  std_logic_vector (to_unsigned (62, 6)),
  std_logic_vector (to_unsigned (61, 6)),
  std_logic_vector (to_unsigned (60, 6)),
  std_logic_vector (to_unsigned (59, 6)),
  std_logic_vector (to_unsigned (58, 6)),
  std_logic_vector (to_unsigned (57, 6)),
  std_logic_vector (to_unsigned (56, 6)),
  std_logic_vector (to_unsigned (55, 6)),
  std_logic_vector (to_unsigned (54, 6)),
  std_logic_vector (to_unsigned (53, 6)),
  std_logic_vector (to_unsigned (52, 6)),
  std_logic_vector (to_unsigned (51, 6)),
  std_logic_vector (to_unsigned (50, 6)),
  std_logic_vector (to_unsigned (49, 6)),
  std_logic_vector (to_unsigned (48, 6)),
  std_logic_vector (to_unsigned (47, 6)),
  std_logic_vector (to_unsigned (46, 6)),
  std_logic_vector (to_unsigned (45, 6)),
  std_logic_vector (to_unsigned (44, 6)),
  std_logic_vector (to_unsigned (43, 6)),
  std_logic_vector (to_unsigned (42, 6)),
  std_logic_vector (to_unsigned (41, 6)),
  std_logic_vector (to_unsigned (40, 6)),
  std_logic_vector (to_unsigned (39, 6)),
  std_logic_vector (to_unsigned (38, 6)),
  std_logic_vector (to_unsigned (37, 6)),
  std_logic_vector (to_unsigned (36, 6)),
  std_logic_vector (to_unsigned (35, 6)),
  std_logic_vector (to_unsigned (34, 6)),
  std_logic_vector (to_unsigned (33, 6)),
  std_logic_vector (to_unsigned (32, 6)),
  std_logic_vector (to_unsigned (31, 6)),
  std_logic_vector (to_unsigned (30, 6)),
  std_logic_vector (to_unsigned (29, 6)),
  std_logic_vector (to_unsigned (28, 6)),
  std_logic_vector (to_unsigned (27, 6)),
  std_logic_vector (to_unsigned (26, 6)),
  std_logic_vector (to_unsigned (25, 6)),
  std_logic_vector (to_unsigned (24, 6)),
  std_logic_vector (to_unsigned (23, 6)),
  std_logic_vector (to_unsigned (22, 6)),
  std_logic_vector (to_unsigned (21, 6)),
  std_logic_vector (to_unsigned (20, 6)),
  std_logic_vector (to_unsigned (19, 6)),
  std_logic_vector (to_unsigned (18, 6)),
  std_logic_vector (to_unsigned (17, 6)),
  std_logic_vector (to_unsigned (16, 6)),
  std_logic_vector (to_unsigned (15, 6)),
  std_logic_vector (to_unsigned (14, 6)),
  std_logic_vector (to_unsigned (13, 6)),
  std_logic_vector (to_unsigned (12, 6)),
  std_logic_vector (to_unsigned (11, 6)),
  std_logic_vector (to_unsigned (10, 6)),
  std_logic_vector (to_unsigned (09, 6)),
  std_logic_vector (to_unsigned (08, 6)),
  std_logic_vector (to_unsigned (07, 6)),
  std_logic_vector (to_unsigned (06, 6)),
  std_logic_vector (to_unsigned (05, 6)),
  std_logic_vector (to_unsigned (04, 6)),
  std_logic_vector (to_unsigned (03, 6)),
  std_logic_vector (to_unsigned (02, 6)),
  std_logic_vector (to_unsigned (01, 6)),
  std_logic_vector (to_unsigned (00, 6))
);

signal vga_blank : std_logic;
signal vga_color : std_logic_vector (5 downto 0);

constant c_cnr : integer := 64;
constant c_max : integer := 640;
signal   index : integer range 0 to c_max - 1;

begin

p_bars : process (i_clock, i_reset) is
begin
  if (i_reset = '1') then
    index <= 0;
  elsif (rising_edge (i_clock)) then
    if (vga_blank = '0') then
      if (index = c_max - 1) then
        index <= 0;
      else
        index <= index + 1;
      end if;
    end if;
    case (index) is
      when 000 to 009 => vga_color <= c_color (00);
      when 010 to 019 => vga_color <= c_color (01);
      when 020 to 029 => vga_color <= c_color (02);
      when 030 to 039 => vga_color <= c_color (03);
      when 040 to 049 => vga_color <= c_color (04);
      when 050 to 059 => vga_color <= c_color (05);
      when 060 to 069 => vga_color <= c_color (06);
      when 070 to 079 => vga_color <= c_color (07);
      when 080 to 089 => vga_color <= c_color (08);
      when 090 to 099 => vga_color <= c_color (09);
      when 100 to 109 => vga_color <= c_color (10);
      when 110 to 119 => vga_color <= c_color (11);
      when 120 to 129 => vga_color <= c_color (12);
      when 130 to 139 => vga_color <= c_color (13);
      when 140 to 149 => vga_color <= c_color (14);
      when 150 to 159 => vga_color <= c_color (15);
      when 160 to 169 => vga_color <= c_color (16);
      when 170 to 179 => vga_color <= c_color (17);
      when 180 to 189 => vga_color <= c_color (18);
      when 190 to 199 => vga_color <= c_color (19);
      when 200 to 209 => vga_color <= c_color (20);
      when 210 to 219 => vga_color <= c_color (21);
      when 220 to 229 => vga_color <= c_color (22);
      when 230 to 239 => vga_color <= c_color (23);
      when 240 to 249 => vga_color <= c_color (24);
      when 250 to 259 => vga_color <= c_color (25);
      when 260 to 269 => vga_color <= c_color (26);
      when 270 to 279 => vga_color <= c_color (27);
      when 280 to 289 => vga_color <= c_color (28);
      when 290 to 299 => vga_color <= c_color (29);
      when 300 to 309 => vga_color <= c_color (30);
      when 310 to 319 => vga_color <= c_color (31);
      when 320 to 329 => vga_color <= c_color (32);
      when 330 to 339 => vga_color <= c_color (33);
      when 340 to 349 => vga_color <= c_color (34);
      when 350 to 359 => vga_color <= c_color (35);
      when 360 to 369 => vga_color <= c_color (36);
      when 370 to 379 => vga_color <= c_color (37);
      when 380 to 389 => vga_color <= c_color (38);
      when 390 to 399 => vga_color <= c_color (39);
      when 400 to 409 => vga_color <= c_color (40);
      when 410 to 419 => vga_color <= c_color (41);
      when 420 to 429 => vga_color <= c_color (42);
      when 430 to 439 => vga_color <= c_color (43);
      when 440 to 449 => vga_color <= c_color (44);
      when 450 to 459 => vga_color <= c_color (45);
      when 460 to 469 => vga_color <= c_color (46);
      when 470 to 479 => vga_color <= c_color (47);
      when 480 to 489 => vga_color <= c_color (48);
      when 490 to 499 => vga_color <= c_color (49);
      when 500 to 509 => vga_color <= c_color (50);
      when 510 to 519 => vga_color <= c_color (51);
      when 520 to 529 => vga_color <= c_color (52);
      when 530 to 539 => vga_color <= c_color (53);
      when 540 to 549 => vga_color <= c_color (54);
      when 550 to 559 => vga_color <= c_color (55);
      when 560 to 569 => vga_color <= c_color (56);
      when 570 to 579 => vga_color <= c_color (57);
      when 580 to 589 => vga_color <= c_color (58);
      when 590 to 599 => vga_color <= c_color (59);
      when 600 to 609 => vga_color <= c_color (60);
      when 610 to 619 => vga_color <= c_color (61);
      when 620 to 629 => vga_color <= c_color (62);
      when 630 to 639 => vga_color <= c_color (63);
    end case;
  end if;
end process p_bars;

o_blank <= vga_blank;

inst_vga_timing : vga_timing
port map (
i_clock => i_clock,
i_reset => i_reset,
o_hsync => o_hsync,
o_vsync => o_vsync,
o_blank => vga_blank
);

inst_vga_rgb : vga_rgb
port map (
i_color => vga_color,
i_blank => vga_blank,
o_r => o_r,
o_g => o_g,
o_b => o_b
);

end architecture behavioral;
