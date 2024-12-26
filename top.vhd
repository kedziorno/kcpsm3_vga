----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12/25/2024 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
i_clock : in std_logic;
i_reset : in std_logic;
o_hsync : out std_logic;
o_vsync : out std_logic;
o_blank : out std_logic;
o_r, o_g, o_b : out std_logic
);
end top;

architecture behavioral of top is

component vga_timing is
port (
i_clock : in std_logic;
i_reset : in std_logic;
o_hsync : out std_logic;
o_vsync : out std_logic;
o_blank : out std_logic
);
end component vga_timing;

component vga_rgb is
port (
i_color : in std_logic_vector (2 downto 0);
i_blank : in std_logic;
o_r, o_g, o_b : out std_logic
);
end component vga_rgb;

type t_color_array is array (7 downto 0) of std_logic_vector (2 downto 0);
constant c_color : t_color_array := (
  "111", "110", "101", "100", "011", "010", "001", "000"
);

signal vga_blank : std_logic;
signal vga_color : std_logic_vector (2 downto 0);

signal lsfr : std_logic_vector (2 downto 0);

begin

--p_lsfr : process (i_clock, i_reset) is
--  variable reg : std_logic;
--begin
--  if (i_reset = '1') then
--    lsfr <= "001";
--    reg := '0';
--  elsif (rising_edge (i_clock)) then
--    reg := lsfr (2) xor lsfr (1);
--    lsfr <= lsfr (1 downto 0) & reg;
--  end if;
--end process p_lsfr;

p_bars : process (i_clock, i_reset) is
  constant c_cnr : integer := 8;
  constant c_max : integer := 640;
  variable index : integer range 0 to c_max - 1;
begin
  if (i_reset = '1') then
    index := 0;
  elsif (rising_edge (i_clock)) then
    if (vga_blank = '0') then
      if (index = c_max - 1) then
        index := 0;
      else
        index := index + 1;
      end if;
    end if;
    case (index) is
      when 000 to 079 => vga_color <= c_color (0);
      when 080 to 159 => vga_color <= c_color (1);
      when 160 to 239 => vga_color <= c_color (2);
      when 240 to 319 => vga_color <= c_color (3);
      when 320 to 399 => vga_color <= c_color (4);
      when 400 to 479 => vga_color <= c_color (5);
      when 480 to 559 => vga_color <= c_color (6);
      when 560 to 639 => vga_color <= c_color (7);
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
