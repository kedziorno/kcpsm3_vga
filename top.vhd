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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.numeric_std.all; -- XXX ONLY FOR DISABLE WARNIGS (I am not worthy and I am unworthy to modify this saint file ;-P). Please copy and modify own file.

entity top is
port (
i_cpu_clock : in  std_logic;
i_vga_clock : in  std_logic;
i_reset     : in  std_logic;
o_hsync     : out std_logic;
o_vsync     : out std_logic;
o_blank     : out std_logic;
o_h_blank   : out std_logic;
o_v_blank   : out std_logic;
o_r         : out std_logic_vector (1 downto 0);
o_g         : out std_logic_vector (1 downto 0);
o_b         : out std_logic_vector (1 downto 0)
);
end entity top;

architecture behavioral of top is

component vga_timing is
port (
i_clock   : in  std_logic;
i_reset   : in  std_logic;
o_hsync   : out std_logic;
o_vsync   : out std_logic;
o_blank   : out std_logic;
o_h_blank : out std_logic;
o_v_blank : out std_logic
);
end component vga_timing;

component vga_rgb is
port (
i_clock, i_reset : in std_logic;
i_color  : in  std_logic_vector (5 downto 0);
i_blank  : in  std_logic;
o_r      : out std_logic_vector (1 downto 0);
o_g      : out std_logic_vector (1 downto 0);
o_b      : out std_logic_vector (1 downto 0)
);
end component vga_rgb;

COMPONENT ipcore_vga_ramb16_dp
PORT (
clka  : IN  STD_LOGIC;
wea   : IN  STD_LOGIC_VECTOR (0 DOWNTO 0);
addra : IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
dina  : IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
clkb  : IN  STD_LOGIC;
addrb : IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
doutb : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
);
END COMPONENT ipcore_vga_ramb16_dp;

signal vga_clock : std_logic;
signal vga_blank : std_logic;
signal vga_h_blank : std_logic;
signal vga_v_blank : std_logic;
signal vga_color : std_logic_vector (5 downto 0);
signal vga_color1 : std_logic_vector (5 downto 0);

signal vga_address : std_logic_vector (13 downto 0);

signal vga_all_pixels : std_logic_vector (13 downto 0);

constant c_x_step : integer := 8;
constant c_y_step : integer := 8;
constant c_x : integer := 640 / c_x_step; -- 128
constant c_y : integer := 480 / c_y_step; -- 120

signal i_x_step, i_x_step_next : integer range 0 to c_x_step - 1;
signal i_y_step, i_y_step_next : integer range 0 to c_y_step - 1;
signal i_x, i_x_next : integer range 0 to c_x - 1;
signal i_y, i_y_next : integer range 0 to c_y - 1;
signal vga_address_step, vga_address_step_next : std_logic_vector (13 downto 0);

component vga_colorbar is
generic (
constant g_step_x : integer := c_x_step;
constant g_step_y : integer := c_y_step
);
port (
i_clock, i_reset : in std_logic;
i_vga_blank : in std_logic;
i_address : in std_logic_vector (13 downto 0);
o_vga_color : out std_logic_vector (5 downto 0)
);
end component vga_colorbar;
for all : vga_colorbar use entity work.vga_colorbar (mosaic);

signal vga_address_step_temp : std_logic_vector (13 downto 0);
signal vga_address_step_temp_next : std_logic_vector (13 downto 0);

signal row_index, row_index_next : integer range 0 to c_y_step - 1;

--constant c_all_pixels : integer := c_x * c_y;
constant c_all_pixels : integer := 307200;
signal i_all_pixels : integer range 0 to c_all_pixels - 1;

begin

p_vga_clock_divider : process (i_cpu_clock, i_reset) is
  constant c_vga25 : integer := 2;
  variable i_vga25 : integer range 0 to c_vga25 - 1;
begin
  if (i_reset = '1') then
    vga_clock <= '0';
    i_vga25 := 0;
  elsif (rising_edge (i_cpu_clock)) then
    if (i_vga25 = c_vga25 - 1) then
      i_vga25 := 0;
      vga_clock <= not vga_clock;
    else
      i_vga25 := i_vga25 + 1;
    end if;
  end if;
end process p_vga_clock_divider;

o_blank <= vga_blank;

o_h_blank <= vga_h_blank;
o_v_blank <= vga_v_blank;

inst_vga_timing : vga_timing
port map (
i_clock   => vga_clock,
i_reset   => i_reset,
o_hsync   => o_hsync,
o_vsync   => o_vsync,
o_blank   => vga_blank,
o_h_blank => vga_h_blank,
o_v_blank => vga_v_blank
);

inst_vga_rgb : vga_rgb
port map (
i_clock => vga_clock,
i_reset => i_reset,
i_color => vga_color1,
i_blank => vga_blank,
o_r => o_r,
o_g => o_g,
o_b => o_b
);

vga_all_pixels <= std_logic_vector (to_unsigned (i_all_pixels, 14));
p_address_input : process (vga_clock, i_reset) is
begin
  if (i_reset = '1') then
    i_all_pixels <= 0;
  elsif (rising_edge (vga_clock)) then
    if (vga_blank = '0') then
      if (i_all_pixels = c_all_pixels - 1) then
        i_all_pixels <= 0;
      else
        i_all_pixels <= i_all_pixels + 1;
      end if;
    end if;
  end if;
end process p_address_input;

p0 : process (vga_clock, i_reset) is
begin
  if (i_reset = '1') then
    i_x_step <= 0;
    i_y_step <= 0;
    i_x <= 0;
    i_y <= 0;
    vga_address_step <= (others => '0');
    row_index <= 0;
  elsif (rising_edge (vga_clock)) then
    i_x_step <= i_x_step_next;
    i_y_step <= i_y_step_next;
    i_x <= i_x_next;
    i_y <= i_y_next;
    vga_address_step <= vga_address_step_next;
    vga_address_step_temp <= vga_address_step_temp_next;
    row_index <= row_index_next;
  end if;
end process p0;

p_address_gen : process (vga_blank, vga_v_blank, i_x, i_y, i_x_step, i_y_step, vga_address_step, vga_address_step_temp, row_index) is
begin
  i_x_next <= i_x;
  i_y_next <= i_y;
  i_x_step_next <= i_x_step;
  i_y_step_next <= i_y_step;
  vga_address_step_next <= vga_address_step;
  vga_address_step_temp_next <= vga_address_step_temp;
  row_index_next <= row_index;
  if (vga_blank = '0') then
    if (i_x_step = c_x_step - 1) then
      i_x_step_next <= 0;
      vga_address_step_next <= std_logic_vector (to_unsigned (to_integer (unsigned (vga_address_step)) + 1, 14));
      if (i_x = c_x - 1) then
        vga_address_step_next <= std_logic_vector (to_unsigned (to_integer (unsigned (vga_address_step_temp)), 14));
        i_x_next <= 0;
        if (i_y_step = c_y_step - 1) then
          i_y_step_next <= 0;
          row_index_next <= 0;
          vga_address_step_next <= std_logic_vector (to_unsigned (to_integer (unsigned (vga_address_step_temp)) + c_x, 14));
          if (i_y = c_y - 1) then
            i_y_next <= 0;
          else
            i_y_next <= i_y + 1;
          end if;
        else
          i_y_step_next <= i_y_step + 1;
          row_index_next <= row_index + 1;
        end if;
      else
        i_x_next <= i_x + 1;
      end if;
    else
      i_x_step_next <= i_x_step + 1;
    end if;
  else
    if (row_index = 0) then
      vga_address_step_temp_next <= std_logic_vector (to_unsigned (to_integer (unsigned (vga_address_step_next)), 14));
    end if;
  end if;
  if (vga_v_blank = '1') then
    vga_address_step_next <= (others => '0');
  end if;
end process p_address_gen;

vga_address <= vga_address_step;
inst_ipcore_vga_ramb16_dp : ipcore_vga_ramb16_dp
port map (
clka  => i_cpu_clock,
wea   => "1",
addra => vga_all_pixels,
dina  => vga_color,
clkb  => vga_clock,
addrb => vga_address,
doutb => vga_color1
);

inst_vga_colorbar : vga_colorbar
port map (
i_clock     => vga_clock,
i_reset     => i_reset,
i_vga_blank => vga_blank,
i_address   => vga_address,
o_vga_color => vga_color
);

end architecture behavioral;
