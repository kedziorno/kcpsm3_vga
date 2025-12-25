----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:17:53 12/25/2025 
-- Design Name: 
-- Module Name:    p1 - Behavioral 
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

entity p1 is
port (
signal ps2_mouse_x_movement : in std_logic_vector (7 downto 0);
signal ps2_mouse_y_movement : in std_logic_vector (7 downto 0);
signal ps2_mouse_z_movement : in std_logic_vector (7 downto 0);
signal ps2_mouse_x_movement_reg : out std_logic_vector (7 downto 0);
signal ps2_mouse_y_movement_reg : out std_logic_vector (7 downto 0);
signal ps2_mouse_z_movement_reg : out std_logic_vector (7 downto 0);
signal ps2_mouse_parity_error : in std_logic;
signal ps2_mouse_x_overflow : in std_logic;
signal ps2_mouse_y_overflow : in std_logic;
signal ps2_mouse_x_sign : in std_logic;
signal ps2_mouse_y_sign : in std_logic;
signal ps2_mouse_button_right : in std_logic;
signal ps2_mouse_button_middle : in std_logic;
signal ps2_mouse_button_left : in std_logic;
signal ps2_mouse_flags_reg : out std_logic_vector (7 downto 0)
);
end entity p1;

architecture Behavioral of p1 is

begin

--  p1 : process (i_cpu_clock) is
--  begin
--    if (rising_edge (i_cpu_clock)) then
--      if (kcpsm3_interrupt_ack = '1') then
        ps2_mouse_x_movement_reg <= ps2_mouse_x_movement;
        ps2_mouse_y_movement_reg <= ps2_mouse_y_movement;
        ps2_mouse_z_movement_reg <= ps2_mouse_z_movement;
        ps2_mouse_flags_reg <=
          ps2_mouse_parity_error &
          ps2_mouse_x_overflow &
          ps2_mouse_y_overflow &
          ps2_mouse_x_sign &
          ps2_mouse_y_sign &
          ps2_mouse_button_right &
          ps2_mouse_button_middle &
          ps2_mouse_button_left;
--      end if;
--    end if;
--  end process p1;

end architecture Behavioral;
