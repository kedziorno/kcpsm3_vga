----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:45:26 12/25/2025 
-- Design Name: 
-- Module Name:    p0 - Behavioral 
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

entity p0 is
port (
signal i_cpu_clock : in std_logic;
signal i_reset : in std_logic;
signal ps2_mouse_trigger : in std_logic;
signal pixel_write_reset, pixel_write_running : in std_logic_vector (0 downto 0);
signal pixel_coordination_reset, pixel_coordination_running : in std_logic_vector (c_memory_address_bits - 1 downto 0);
signal pixel_color_reset, pixel_color_running : in std_logic_vector (c_color_bits - 1 downto 0);
signal pixel_write : out std_logic_vector (0 downto 0);
signal pixel_coordination : out std_logic_vector (c_memory_address_bits - 1 downto 0);
signal pixel_color : out std_logic_vector (c_color_bits - 1 downto 0);
signal ps2_mouse_trigger_4x : out std_logic;
signal ps2_mouse_do_read : out std_logic;
signal kcpsm3_interrupt_ack : in std_logic;
signal kcpsm3_interrupt : out std_logic
);
end entity p0;

architecture Behavioral of p0 is

  type p0_states is (r0, r1, a, b, c);
  signal p0_state : p0_states;
  signal ps2_mouse_trigger_prev : std_logic;
  signal pixel_write_reset_i : std_logic_vector (0 downto 0);
  signal pixel_coordination_reset_i : std_logic_vector (c_memory_address_bits - 1 downto 0);
  signal pixel_color_reset_i : std_logic_vector (c_color_bits - 1 downto 0);
  signal ps2_mouse_trigger_4x_sr : std_logic_vector (3 downto 0);

begin

  pixel_write <= pixel_write_reset_i when (p0_state = r0 or p0_state = r1) else pixel_write_running;
  pixel_coordination <= pixel_coordination_reset_i when (p0_state = r0 or p0_state = r1) else pixel_coordination_running;
  pixel_color <= pixel_color_reset_i when (p0_state = r0 or p0_state = r1) else pixel_color_running;

  p0 : process (i_cpu_clock, i_reset) is
    variable memory_address_index : integer range 0 to c_all_pixels - 1;
  begin
    if (i_reset = '1') then
      p0_state <= r0;
      memory_address_index := 0;
      pixel_write_reset_i <= "0";
      pixel_coordination_reset_i <= (others => '0');
      pixel_color_reset_i <= (others => '0');
      ps2_mouse_trigger_4x <= '0';
      ps2_mouse_trigger_4x_sr <= "0001";
      ps2_mouse_trigger_prev <= '0';
    elsif (rising_edge (i_cpu_clock)) then
      ps2_mouse_trigger_prev <= ps2_mouse_trigger;
      case (p0_state) is
        when r0 => -- reset VGA memory content
          p0_state <= r1;
          pixel_write_reset_i <= "1";
          pixel_coordination_reset_i <= std_logic_vector (to_unsigned (memory_address_index, c_memory_address_bits));
          pixel_color_reset_i <= (others => '0');
        when r1 =>
          pixel_write_reset_i <= "0";
          pixel_coordination_reset_i <= (others => '0');
          pixel_color_reset_i <= (others => '0');
          if (memory_address_index = c_all_pixels - 1) then
            memory_address_index := 0;
            p0_state <= a;
          else
            memory_address_index := memory_address_index + 1;
            p0_state <= r0;
          end if;
        when a =>
          if (ps2_mouse_trigger_prev = '1' and ps2_mouse_trigger = '0') then
--            if (ps2_mouse_trigger_4x_sr = "1000") then -- XXX trigger after each ps2 byte draw box ok
--              ps2_mouse_trigger_4x_sr <= "0001";
--              ps2_mouse_trigger_4x <= '1';
              p0_state <= b;
--            else
--              ps2_mouse_trigger_4x_sr <= ps2_mouse_trigger_4x_sr (2 downto 0) & ps2_mouse_trigger_4x_sr (3);
--            end if;
          end if;
        when b =>
          p0_state <= c;
          ps2_mouse_trigger_4x <= '0';
          kcpsm3_interrupt <= '1';
          ps2_mouse_do_read <= kcpsm3_interrupt_ack;
        when c =>
          if (kcpsm3_interrupt_ack = '1') then
            p0_state <= a;
            kcpsm3_interrupt <= '0';
          end if;
      end case;
    end if;
  end process p0;

end architecture Behavioral;
