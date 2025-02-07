library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package p_package1 is

  constant c_x_step                     : integer := 4;
  constant c_y_step                     : integer := 4;
  constant c_x                          : integer := 640 / c_x_step; -- 160
  constant c_y                          : integer := 480 / c_y_step; -- 120
  constant c_all_pixels                 : integer := c_x * c_y; -- 19200,307200
  constant c_memory_address_bits        : integer := 15;
  constant c_color_bits                 : integer := 6;
  constant c_vga_clock_divider_25mhz    : integer := 2;
  constant c_kcpsm3_port_id_pixel_row   : std_logic_vector (7 downto 0) := x"16";
  constant c_kcpsm3_port_id_pixel_col   : std_logic_vector (7 downto 0) := x"17";
  constant c_kcpsm3_port_id_pixel_color : std_logic_vector (7 downto 0) := x"20";
  constant c_kcpsm3_port_id_mouse_x     : std_logic_vector (7 downto 0) := x"21";
  constant c_kcpsm3_port_id_mouse_y     : std_logic_vector (7 downto 0) := x"22";
  constant c_kcpsm3_port_id_mouse_flags : std_logic_vector (7 downto 0) := x"23";

  type t_color_array is array (63 downto 0) of std_logic_vector (5 downto 0);
  constant c_color : t_color_array := (
    std_logic_vector (to_unsigned (63, 6)), -- white
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
    std_logic_vector (to_unsigned (48, 6)), -- red
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
    std_logic_vector (to_unsigned (34, 6)), -- violet
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
    std_logic_vector (to_unsigned (12, 6)), -- green
    std_logic_vector (to_unsigned (11, 6)),
    std_logic_vector (to_unsigned (10, 6)),
    std_logic_vector (to_unsigned (09, 6)),
    std_logic_vector (to_unsigned (08, 6)),
    std_logic_vector (to_unsigned (07, 6)),
    std_logic_vector (to_unsigned (06, 6)),
    std_logic_vector (to_unsigned (05, 6)),
    std_logic_vector (to_unsigned (04, 6)),
    std_logic_vector (to_unsigned (03, 6)), -- blue
    std_logic_vector (to_unsigned (02, 6)),
    std_logic_vector (to_unsigned (01, 6)),
    std_logic_vector (to_unsigned (00, 6)) -- black
  );

end package p_package1;

package body p_package1 is
end package body p_package1;
