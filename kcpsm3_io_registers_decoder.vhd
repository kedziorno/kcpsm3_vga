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

use work.p_package1.all;

entity kcpsm3_io_registers_decoder is
port (
i_clock, i_reset      : in  std_logic;
i_kcpsm3_port_id      : in  std_logic_vector (7 downto 0);
i_kcpsm3_out_port     : in  std_logic_vector (7 downto 0);
i_kcpsm3_write_strobe : in  std_logic;
o_pixel_coordination  : out std_logic_vector (c_memory_address_bits - 1 downto 0);
o_pixel_color         : out std_logic_vector (c_color_bits - 1 downto 0);
o_pixel_write         : out std_logic_vector (0 downto 0)
);
end entity kcpsm3_io_registers_decoder;

architecture behavioral of kcpsm3_io_registers_decoder is

begin

  p_io_registers_decoder : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      o_pixel_write        <= "0";
      o_pixel_coordination <= (others => '0');
      o_pixel_color        <= (others => '0');
    elsif (rising_edge (i_clock)) then
      case (i_kcpsm3_port_id) is
        when c_kcpsm3_pixel_address_low =>
          if (i_kcpsm3_write_strobe = '1') then
            o_pixel_write <= "0";
            o_pixel_coordination (7 downto 0) <=
              i_kcpsm3_out_port (7 downto 0);
          end if;
        when c_kcpsm3_pixel_address_high =>
          if (i_kcpsm3_write_strobe = '1') then
            o_pixel_write <= "0";
            o_pixel_coordination (c_memory_address_bits - 1 downto 8) <=
              i_kcpsm3_out_port (6 downto 0);
          end if;
        when c_kcpsm3_pixel_address_color =>
          if (i_kcpsm3_write_strobe = '1') then
            o_pixel_write <= "1";
            o_pixel_color <=
              i_kcpsm3_out_port (c_color_bits - 1 downto 0);
          end if;
        when others =>
          o_pixel_write        <= "0";
          o_pixel_coordination <= (others => '0');
          o_pixel_color        <= (others => '0');
      end case;
    end if;
  end process p_io_registers_decoder;

end architecture behavioral;
