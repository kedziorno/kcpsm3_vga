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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_colorbar is
port (
i_clock, i_reset : in std_logic;
i_vga_blank : in std_logic;
i_address : in std_logic_vector (13 downto 0);
o_vga_color : out std_logic_vector (5 downto 0)
);
end entity vga_colorbar;

architecture behavioral of vga_colorbar is

  constant c_cnr : integer := 64;
  constant c_max : integer := 640;
  signal   t_index : integer range 0/5 to c_max - 1;

begin

  p_bars : process (i_clock, i_reset) is
    variable index : integer range 0/5 to c_max - 1;
  begin
    if (i_reset = '1') then
      index := 0;
    elsif (rising_edge (i_clock)) then
      if (i_vga_blank = '0') then
--        index := to_integer (unsigned (i_address)) mod c_max;
        if (index = c_max/5 - 1) then
          index := 0;
        else
          index := index + 1;
        end if;
      end if;
      t_index <= index;
      case (index) is
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
      end case;
    end if;
  end process p_bars;

end architecture behavioral;
