----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    01/05/2025
-- Design Name:
-- Module Name:    vga_address_generator
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

use work.p_package1.all;

entity vga_address_generator is
port (
i_clock, i_reset : in  std_logic;
i_vga_blank      : in  std_logic;
i_vga_v_blank    : in  std_logic;
o_vga_address    : out std_logic_vector (c_memory_address_bits - 1 downto 0)
);
end entity vga_address_generator;

architecture behavioral of vga_address_generator is

  signal x_step_q                , x_step_next_i                : integer          range                    0 to     c_x_step - 1;
  signal y_step_q                , y_step_next_i                : integer          range                    0 to     c_y_step - 1;
  signal x_q                     , x_next_i                     : integer          range                    0 to     c_x      - 1;
  signal y_q                     , y_next_i                     : integer          range                    0 to     c_y      - 1;
  signal row_index_q             , row_index_next_i             : integer          range                    0 to     c_y_step - 1;
  signal vga_address_step_q      , vga_address_step_next_i      : std_logic_vector (c_memory_address_bits - 1 downto 0);
  signal vga_address_step_temp_q , vga_address_step_temp_next_i : std_logic_vector (c_memory_address_bits - 1 downto 0); -- this address is load when <c_y_step and stored when =c_y_step

begin

  o_vga_address <= vga_address_step_q;

  p_vga_address_generator_registers : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      x_step_q                <=                            0;
      y_step_q                <=                            0;
      x_q                     <=                            0;
      y_q                     <=                            0;
      row_index_q             <=                            0;
      vga_address_step_q      <=              (others => '0');
      vga_address_step_temp_q <=              (others => '0');
    elsif (rising_edge (i_clock)) then
      x_step_q                <=                x_step_next_i;
      y_step_q                <=                y_step_next_i;
      x_q                     <=                     x_next_i;
      y_q                     <=                     y_next_i;
      vga_address_step_q      <=      vga_address_step_next_i;
      vga_address_step_temp_q <= vga_address_step_temp_next_i;
      row_index_q             <=             row_index_next_i;
    end if;
  end process p_vga_address_generator_registers;

  -- o_vga_address - synthesis show warning about missing this signal in
  -- sensitivity list, ignore.
  p_vga_address_generator_combinatorial : process (
    i_vga_blank,        i_vga_v_blank,
    vga_address_step_q, vga_address_step_temp_q,
    x_q,                y_q,
    x_step_q,           y_step_q,
    row_index_q
  ) is
  begin
    x_next_i                     <=                     x_q;
    y_next_i                     <=                     y_q;
    x_step_next_i                <=                x_step_q;
    y_step_next_i                <=                y_step_q;
    vga_address_step_next_i      <=      vga_address_step_q;
    vga_address_step_temp_next_i <= vga_address_step_temp_q;
    row_index_next_i             <=             row_index_q;
    if (i_vga_blank = '0') then
      if (x_step_q = c_x_step - 1) then
        x_step_next_i           <= 0;
        vga_address_step_next_i <= std_logic_vector (
                                   to_unsigned      (
                                   to_integer       (
                                   unsigned (vga_address_step_q)
                                   ) + 1,
                                   c_memory_address_bits));
        if (x_q = c_x - 1) then
          x_next_i                <= 0;
          vga_address_step_next_i <= std_logic_vector (
                                     to_unsigned      (
                                     to_integer       (
                                     unsigned (vga_address_step_temp_q)),
                                     c_memory_address_bits));
          if (y_step_q = c_y_step - 1) then
            row_index_next_i        <= 0;
            y_step_next_i           <= 0;
            vga_address_step_next_i <= std_logic_vector (
                                       to_unsigned      (
                                       to_integer       (
                                       unsigned (vga_address_step_temp_q)
                                       ) + c_x,
                                       c_memory_address_bits));
            if (y_q = c_y - 1) then
              y_next_i <= 0;
            else
              y_next_i <= y_q + 1;
            end if;
          else
            y_step_next_i    <= y_step_q    + 1;
            row_index_next_i <= row_index_q + 1;
          end if;
        else
          x_next_i <= x_q + 1;
        end if;
      else
        x_step_next_i <= x_step_q + 1;
      end if;
    else
      if (row_index_q = 0) then
        vga_address_step_temp_next_i <= std_logic_vector (
                                        to_unsigned      (
                                        to_integer       (
                                        unsigned (vga_address_step_next_i)), 
                                        c_memory_address_bits));
      end if;
    end if;
    if (i_vga_v_blank = '1') then
      vga_address_step_next_i <= (others => '0');
    end if;
  end process p_vga_address_generator_combinatorial;

end architecture behavioral;
