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
--        when 000 / g_step to 009 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 010 / g_step to 019 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 020 / g_step to 029 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 030 / g_step to 039 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 040 / g_step to 049 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 050 / g_step to 059 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 060 / g_step to 069 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 070 / g_step to 079 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 080 / g_step to 089 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 090 / g_step to 099 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 100 / g_step to 109 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 110 / g_step to 119 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 120 / g_step to 129 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 130 / g_step to 139 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 140 / g_step to 149 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 150 / g_step to 159 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 160 / g_step to 169 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 170 / g_step to 179 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 180 / g_step to 189 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 190 / g_step to 199 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 200 / g_step to 209 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 210 / g_step to 219 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 220 / g_step to 229 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 230 / g_step to 239 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 240 / g_step to 249 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 250 / g_step to 259 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 260 / g_step to 269 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 270 / g_step to 279 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 280 / g_step to 289 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 290 / g_step to 299 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 300 / g_step to 309 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 310 / g_step to 319 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 320 / g_step to 329 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 330 / g_step to 339 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 340 / g_step to 349 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 350 / g_step to 359 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 360 / g_step to 369 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 370 / g_step to 379 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 380 / g_step to 389 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 390 / g_step to 399 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 400 / g_step to 409 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 410 / g_step to 419 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 420 / g_step to 429 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 430 / g_step to 439 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 440 / g_step to 449 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 450 / g_step to 459 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 460 / g_step to 469 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 470 / g_step to 479 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 480 / g_step to 489 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 490 / g_step to 499 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 500 / g_step to 509 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 510 / g_step to 519 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 520 / g_step to 529 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 530 / g_step to 539 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 540 / g_step to 549 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 550 / g_step to 559 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 560 / g_step to 569 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 570 / g_step to 579 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 580 / g_step to 589 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 590 / g_step to 599 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 600 / g_step to 609 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 610 / g_step to 619 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 620 / g_step to 629 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
--        when 630 / g_step to 639 / g_step => o_vga_color <= c_color (to_integer (unsigned (o_lsfr)));
        when 000/5 to 009/5 => o_vga_color <= c_color (00);
        when 010/5 to 019/5 => o_vga_color <= c_color (01);
        when 020/5 to 029/5 => o_vga_color <= c_color (02);
        when 030/5 to 039/5 => o_vga_color <= c_color (03);
        when 040/5 to 049/5 => o_vga_color <= c_color (04);
        when 050/5 to 059/5 => o_vga_color <= c_color (05);
        when 060/5 to 069/5 => o_vga_color <= c_color (06);
        when 070/5 to 079/5 => o_vga_color <= c_color (07);
        when 080/5 to 089/5 => o_vga_color <= c_color (08);
        when 090/5 to 099/5 => o_vga_color <= c_color (09);
        when 100/5 to 109/5 => o_vga_color <= c_color (10);
        when 110/5 to 119/5 => o_vga_color <= c_color (11);
        when 120/5 to 129/5 => o_vga_color <= c_color (12);
        when 130/5 to 139/5 => o_vga_color <= c_color (13);
        when 140/5 to 149/5 => o_vga_color <= c_color (14);
        when 150/5 to 159/5 => o_vga_color <= c_color (15);
        when 160/5 to 169/5 => o_vga_color <= c_color (16);
        when 170/5 to 179/5 => o_vga_color <= c_color (17);
        when 180/5 to 189/5 => o_vga_color <= c_color (18);
        when 190/5 to 199/5 => o_vga_color <= c_color (19);
        when 200/5 to 209/5 => o_vga_color <= c_color (20);
        when 210/5 to 219/5 => o_vga_color <= c_color (21);
        when 220/5 to 229/5 => o_vga_color <= c_color (22);
        when 230/5 to 239/5 => o_vga_color <= c_color (23);
        when 240/5 to 249/5 => o_vga_color <= c_color (24);
        when 250/5 to 259/5 => o_vga_color <= c_color (25);
        when 260/5 to 269/5 => o_vga_color <= c_color (26);
        when 270/5 to 279/5 => o_vga_color <= c_color (27);
        when 280/5 to 289/5 => o_vga_color <= c_color (28);
        when 290/5 to 299/5 => o_vga_color <= c_color (29);
        when 300/5 to 309/5 => o_vga_color <= c_color (30);
        when 310/5 to 319/5 => o_vga_color <= c_color (31);
        when 320/5 to 329/5 => o_vga_color <= c_color (32);
        when 330/5 to 339/5 => o_vga_color <= c_color (33);
        when 340/5 to 349/5 => o_vga_color <= c_color (34);
        when 350/5 to 359/5 => o_vga_color <= c_color (35);
        when 360/5 to 369/5 => o_vga_color <= c_color (36);
        when 370/5 to 379/5 => o_vga_color <= c_color (37);
        when 380/5 to 389/5 => o_vga_color <= c_color (38);
        when 390/5 to 399/5 => o_vga_color <= c_color (39);
        when 400/5 to 409/5 => o_vga_color <= c_color (40);
        when 410/5 to 419/5 => o_vga_color <= c_color (41);
        when 420/5 to 429/5 => o_vga_color <= c_color (42);
        when 430/5 to 439/5 => o_vga_color <= c_color (43);
        when 440/5 to 449/5 => o_vga_color <= c_color (44);
        when 450/5 to 459/5 => o_vga_color <= c_color (45);
        when 460/5 to 469/5 => o_vga_color <= c_color (46);
        when 470/5 to 479/5 => o_vga_color <= c_color (47);
        when 480/5 to 489/5 => o_vga_color <= c_color (48);
        when 490/5 to 499/5 => o_vga_color <= c_color (49);
        when 500/5 to 509/5 => o_vga_color <= c_color (50);
        when 510/5 to 519/5 => o_vga_color <= c_color (51);
        when 520/5 to 529/5 => o_vga_color <= c_color (52);
        when 530/5 to 539/5 => o_vga_color <= c_color (53);
        when 540/5 to 549/5 => o_vga_color <= c_color (54);
        when 550/5 to 559/5 => o_vga_color <= c_color (55);
        when 560/5 to 569/5 => o_vga_color <= c_color (56);
        when 570/5 to 579/5 => o_vga_color <= c_color (57);
        when 580/5 to 589/5 => o_vga_color <= c_color (58);
        when 590/5 to 599/5 => o_vga_color <= c_color (59);
        when 600/5 to 609/5 => o_vga_color <= c_color (60);
        when 610/5 to 619/5 => o_vga_color <= c_color (61);
        when 620/5 to 629/5 => o_vga_color <= c_color (62);
        when 630/5 to 639/5 => o_vga_color <= c_color (63);
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
