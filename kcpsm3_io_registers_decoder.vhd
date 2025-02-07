----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    01/05/2025
-- Design Name:
-- Module Name:    cpu_io_registers_decoder
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created, VGA decoder
-- Revision 0.02 - PS/2 mouse decoder
--
-- Additional Comments:
-- - VGA:
--   - Coordinations is stored at absolute addresses (0 - 19199) :
--      - 0x16 - X (rows) , 0 - 159 / use 8bit.
--      - 0x17 - Y (cols) , 0 - 119 / use 7bit, expect first MSB.
--   - Colors have index 0 - 63 at address 0x20.
--   - After concatenation to YYYYYYYXXXXXXXX format (15 bit)
--       decoder make address (coordination), data (color) and write (boolean)
--       signals for access to dual-port memory (A)
--       where pixels with color is stored.
-- - Mouse:
--   (...)
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

use work.p_package1.all;

entity kcpsm3_io_registers_decoder is
port (
i_clock, i_reset      : in  std_logic;
i_kcpsm3_port_id      : in  std_logic_vector (7 downto 0);
i_kcpsm3_out_port     : in  std_logic_vector (7 downto 0);
o_kcpsm3_in_port      : out std_logic_vector (7 downto 0);
i_kcpsm3_write_strobe : in  std_logic;
i_kcpsm3_read_strobe  : in  std_logic;
o_pixel_coordination  : out std_logic_vector (c_memory_address_bits - 1 downto 0);
o_pixel_color         : out std_logic_vector (c_color_bits - 1 downto 0);
o_pixel_write         : out std_logic_vector (0 downto 0);
i_mouse_x             : in  std_logic_vector (7 downto 0);
i_mouse_y             : in  std_logic_vector (7 downto 0);
i_mouse_flags         : in  std_logic_vector (7 downto 0);
-- o_testX not used in synthesis
o_test8               : out std_logic_vector (7 downto 0);
o_test7               : out std_logic_vector (7 downto 0);
o_test6               : out std_logic_vector (7 downto 0);
o_test5               : out std_logic_vector (7 downto 0);
o_test4               : out std_logic_vector (7 downto 0);
o_test3               : out std_logic_vector (7 downto 0);
o_test2               : out std_logic_vector (7 downto 0);
o_test1               : out std_logic_vector (7 downto 0);
o_test0               : out std_logic_vector (7 downto 0)
);
end entity kcpsm3_io_registers_decoder;

architecture behavioral of kcpsm3_io_registers_decoder is

begin

  p_io_registers_decoder_mouse : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
    elsif (rising_edge (i_clock)) then
      case (i_kcpsm3_port_id) is
        when c_kcpsm3_port_id_mouse_x =>
          if (i_kcpsm3_read_strobe = '1') then
            o_kcpsm3_in_port <= i_mouse_x;
          end if;
        when c_kcpsm3_port_id_mouse_y =>
          if (i_kcpsm3_read_strobe = '1') then
            o_kcpsm3_in_port <= i_mouse_y;
          end if;
        when c_kcpsm3_port_id_mouse_flags =>
          if (i_kcpsm3_read_strobe = '1') then
            o_kcpsm3_in_port <= i_mouse_flags;
          end if;
        when others => null;
      end case;
    end if;
  end process p_io_registers_decoder_mouse;

  p_io_registers_decoder_vga : process (i_clock, i_reset) is
    variable x_coordination : integer range 0 to c_x - 1; -- 7 bit
    variable y_coordination : integer range 0 to c_y * c_x - 1; -- 6 bit
  begin
    if (i_reset = '1') then
      o_pixel_write        <= "0";
      o_pixel_coordination <= (others => '0');
      o_pixel_color        <= (others => '0');
      --synthesis translate_off
--      report "c_x : " & integer'image (c_x);
--      report "c_y : " & integer'image (c_y);
      --synthesis translate_on
    elsif (rising_edge (i_clock)) then
      case (i_kcpsm3_port_id) is
        when c_kcpsm3_port_id_pixel_row => -- x coordination pixel 7 bit (0 to 159)
          if (i_kcpsm3_write_strobe = '1') then
            o_pixel_write <= "0";
            x_coordination :=
              to_integer (unsigned (i_kcpsm3_out_port (7 downto 0)));
            --synthesis translate_off
--            report "x_coordination : " & integer'image (x_coordination);
            --synthesis translate_on
          end if;
        when c_kcpsm3_port_id_pixel_col => -- y coordination pixel 6 bit (0 to 119)
          if (i_kcpsm3_write_strobe = '1') then
            o_pixel_write <= "0";
            y_coordination :=
              to_integer (unsigned (i_kcpsm3_out_port (6 downto 0))) * c_x;
            --synthesis translate_off
--            report "y_coordination : " & integer'image (y_coordination);
            --synthesis translate_on
          end if;
        when c_kcpsm3_port_id_pixel_color => -- color pixel (0 to 63)
          if (i_kcpsm3_write_strobe = '1') then
            o_pixel_write <= "1";
            o_pixel_coordination <= std_logic_vector (to_unsigned (y_coordination + x_coordination, c_memory_address_bits));
            --synthesis translate_off
--            report "o_pixel_coordination : " & integer'image (y_coordination + x_coordination);
            --synthesis translate_on
            o_pixel_color <=
              i_kcpsm3_out_port (c_color_bits - 1 downto 0);
          end if;
        when others =>
          o_pixel_write        <= "0";
          o_pixel_coordination <= (others => '0');
          o_pixel_color        <= (others => '0');
      end case;
    end if;
  end process p_io_registers_decoder_vga;

--synthesis translate_off
  p_io_registers_decoder_debug : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      o_test0 <= (others => '0');
      o_test1 <= (others => '0');
      o_test2 <= (others => '0');
      o_test3 <= (others => '0');
      o_test4 <= (others => '0');
      o_test5 <= (others => '0');
      o_test6 <= (others => '0');
      o_test7 <= (others => '0');
      o_test8 <= (others => '0');
    elsif (rising_edge (i_clock)) then
      case (i_kcpsm3_port_id) is
        when x"01" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test1 <= i_kcpsm3_out_port;
          end if;
        when x"02" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test2 <= i_kcpsm3_out_port;
          end if;
        when x"03" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test3 <= i_kcpsm3_out_port;
          end if;
        when x"04" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test4 <= i_kcpsm3_out_port;
          end if;
        when x"05" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test5 <= i_kcpsm3_out_port;
          end if;
        when x"06" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test6 <= i_kcpsm3_out_port;
          end if;
        when x"07" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test7 <= i_kcpsm3_out_port;
          end if;
        when x"08" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test8 <= i_kcpsm3_out_port;
          end if;
        when others =>
          o_test0 <= (others => '0');
          o_test1 <= (others => '0');
          o_test2 <= (others => '0');
          o_test3 <= (others => '0');
          o_test4 <= (others => '0');
          o_test5 <= (others => '0');
          o_test6 <= (others => '0');
          o_test7 <= (others => '0');
          o_test8 <= (others => '0');
      end case;
    end if;
  end process p_io_registers_decoder_debug;
--synthesis translate_on

end architecture behavioral;
