----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12/25/2024
-- Design Name:
-- Module Name:    vga
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

entity vga is
port (
i_clock : in std_logic;
i_reset : in std_logic;
o_hsync : out std_logic;
o_vsync : out std_logic;
o_blank : out std_logic
);
end entity vga;

-- http://www.tinyvga.com/vga-timing/640x480@60Hz
--
-- O-------------------------------------------------------O
-- * General timing                                        *
-- * VGA Signal 640 x 480 @ 60 Hz Industry standard timing *
-- O---------------------+----------------+----------------O
-- | Screen refresh rate |  60       Hz   |
-- |    Vertical refresh |  31.46875 kHz  |
-- |         Pixel freq. |  25.175   MHz  |
-- +---------------------*----------------+
--
-- O-------------------------------------------------------O
-- * Scanline part Pixels Time [us]                        *
-- * Horizontal timing (line)                              *
-- * Polarity of horizontal sync pulse is negative.        *
-- O--------------+-----+-----------------+----------------O
-- | Visible area | 640 | 25.422045680238 |
-- |  Front porch |  16 |  0.635551142006 |
-- |   Sync pulse |  96 |  3.813306852036 |
-- |   Back porch |  48 |  1.906653426018 |
-- |   Whole line | 800 | 31.777557100298 |
-- +--------------+-----+-----------------+
--
-- O-------------------------------------------------------O
-- * Frame part Lines Time [ms]                            *
-- * Vertical timing (frame)                               *
-- * Polarity of vertical sync pulse is negative.          *
-- O--------------+-----+-----------------+----------------O
-- | Visible area | 480 | 15.253227408143 |
-- |  Front porch |  10 |  0.317775571003 |
-- |   Sync pulse |   2 |  0.063555114201 |
-- |   Back porch |  33 |  1.048659384310 |
-- |  Whole frame | 525 | 16.683217477656 |
-- +--------------+-----+-----------------+

architecture industry_standard_640x480_timing of vga is

  -- 39.720, 39.722
  constant h_visible_area : integer := 640; -- 25.42080,  25.422080
  constant h_front_porch  : integer :=  16; --  0.635520,  0.635552
  constant h_sync_pulse   : integer :=  96; --  3.813120,  3.813312
  constant h_back_porch   : integer :=  48; --  1.906560,  1.906656
  constant whole_line     : integer := 800; -- 31.7776,   31.7776

  constant v_visible_area : integer := 480; -- 15.24612480,  15.246892480
  constant v_front_porch  : integer :=  10; --  0.292378920,  0.292393642
  constant v_sync_pulse   : integer :=   2; --  0.0635520,    0.06355520
  constant v_back_porch   : integer :=  33; --  1.080344280,  1.080398678
  constant whole_frame    : integer := 525; -- 16.68240,     16.683240

  signal h_counter : integer range 0 to whole_line  - 1;
  signal v_counter : integer range 0 to whole_frame - 1;

begin

  o_blank <=
    '0' when
      (h_counter <= h_visible_area - 1)
      and
      (v_counter <= v_visible_area - 1)
    else '1';

  p_hv_counters : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      h_counter <= 0;
      v_counter <= 0;
    elsif (rising_edge (i_clock)) then
      if (h_counter = whole_line - 1) then
        h_counter <= 0;
        if (v_counter = whole_frame - 1) then
          v_counter <= 0;
        else
          v_counter <= v_counter + 1;
        end if;
      else
        h_counter <= h_counter + 1;
      end if;
      if (
        h_counter >= (h_visible_area + h_front_porch                - 1)
        and
        h_counter <  (h_visible_area + h_front_porch + h_sync_pulse - 1)
      ) then
        o_hsync <= '0';
      else
        o_hsync <= '1';
      end if;
      if (
        v_counter >= (v_visible_area + v_front_porch                - 1)
        and
        v_counter <  (v_visible_area + v_front_porch + v_sync_pulse - 1)
      ) then
        o_vsync <= '0';
      else
        o_vsync <= '1';
      end if;
    end if;
  end process p_hv_counters;

end architecture industry_standard_640x480_timing;
