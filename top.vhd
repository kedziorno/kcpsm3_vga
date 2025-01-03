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

  constant c_x_step     : integer := 4;
  constant c_y_step     : integer := 4;
  constant c_x          : integer := 640 / c_x_step; -- 160
  constant c_y          : integer := 480 / c_y_step; -- 120
  constant c_all_pixels : integer := c_x * c_y; -- 19200,307200

  component vga_timing is
  port (
  i_clock, i_reset : in  std_logic;
  o_hsync          : out std_logic;
  o_vsync          : out std_logic;
  o_blank          : out std_logic;
  o_h_blank        : out std_logic;
  o_v_blank        : out std_logic
  );
  end component vga_timing;

  component vga_rgb is
  port (
  i_clock, i_reset : in  std_logic;
  i_color          : in  std_logic_vector (5 downto 0);
  i_blank          : in  std_logic;
  o_r              : out std_logic_vector (1 downto 0);
  o_g              : out std_logic_vector (1 downto 0);
  o_b              : out std_logic_vector (1 downto 0)
  );
  end component vga_rgb;

  COMPONENT ipcore_vga_ramb16_dp
  PORT (
  clka  : IN  STD_LOGIC;
  wea   : IN  STD_LOGIC_VECTOR (0 DOWNTO 0);
  addra : IN  STD_LOGIC_VECTOR (14 DOWNTO 0);
  dina  : IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
  clkb  : IN  STD_LOGIC;
  addrb : IN  STD_LOGIC_VECTOR (14 DOWNTO 0);
  doutb : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
  );
  END COMPONENT ipcore_vga_ramb16_dp;

  component kcpsm3 -- PicoBlaze 8-bit CPU
  port (
  address       : out std_logic_vector (9 downto 0);
  instruction   : in  std_logic_vector (17 downto 0);
  port_id       : out std_logic_vector (7 downto 0);
  write_strobe  : out std_logic;
  out_port      : out std_logic_vector (7 downto 0);
  read_strobe   : out std_logic;
  in_port       : in  std_logic_vector (7 downto 0);
  interrupt     : in  std_logic;
  interrupt_ack : out std_logic;
  reset         : in  std_logic;
  clk           : in  std_logic
  );
  end component kcpsm3;

  component program -- kcpsm3_rom_memory_content
  port (
  address     : in  std_logic_vector (9 downto 0);
  instruction : out std_logic_vector (17 downto 0);
  clk         : in  std_logic
  );
  end component program;

  signal vga_clock                           : std_logic;
  signal vga_write                           : std_logic_vector (0 downto 0);
  signal vga_blank, vga_h_blank, vga_v_blank : std_logic;
  signal vga_color, vga_color1               : std_logic_vector (5 downto 0);
  signal vga_address,vga_all_pixels          : std_logic_vector (14 downto 0);
  signal i_all_pixels                        : integer range 0 to c_all_pixels - 1;

  signal i_x_step, i_x_step_next                           : integer range 0 to c_x_step - 1;
  signal i_y_step, i_y_step_next                           : integer range 0 to c_y_step - 1;
  signal i_x, i_x_next                                     : integer range 0 to c_x      - 1;
  signal i_y, i_y_next                                     : integer range 0 to c_y      - 1;
  signal row_index, row_index_next                         : integer range 0 to c_y_step - 1;
  signal vga_address_step, vga_address_step_next           : std_logic_vector (14 downto 0);
  signal vga_address_step_temp, vga_address_step_temp_next : std_logic_vector (14 downto 0); -- this address is load when <c_y_step and stored when =c_y_step

  signal kcpsm3_address       : std_logic_vector (9 downto 0);
  signal kcpsm3_instruction   : std_logic_vector (17 downto 0);
  signal kcpsm3_port_id       : std_logic_vector (7 downto 0);
  signal kcpsm3_out_port      : std_logic_vector (7 downto 0);
  signal kcpsm3_in_port       : std_logic_vector (7 downto 0);
  signal kcpsm3_write_strobe  : std_logic;
  signal kcpsm3_read_strobe   : std_logic;
  signal kcpsm3_interrupt     : std_logic := '0';
  signal kcpsm3_interrupt_ack : std_logic;

begin

  o_blank <= vga_blank;
  o_h_blank <= vga_h_blank;
  o_v_blank <= vga_v_blank;

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

  p_vga_address_generator_registers : process (vga_clock, i_reset) is
  begin
    if (i_reset = '1') then
      i_x_step              <= 0;
      i_y_step              <= 0;
      i_x                   <= 0;
      i_y                   <= 0;
      row_index             <= 0;
      vga_address_step      <= (others => '0');
      vga_address_step_temp <= (others => '0');
    elsif (rising_edge (vga_clock)) then
      i_x_step              <= i_x_step_next;
      i_y_step              <= i_y_step_next;
      i_x                   <= i_x_next;
      i_y                   <= i_y_next;
      vga_address_step      <= vga_address_step_next;
      vga_address_step_temp <= vga_address_step_temp_next;
      row_index             <= row_index_next;
    end if;
  end process p_vga_address_generator_registers;

  p_vga_address_generator_combinatorial : process (
    vga_blank, vga_v_blank,
    vga_address_step, vga_address_step_temp,
    i_x, i_y,
    i_x_step, i_y_step,
    row_index
  ) is
  begin
    i_x_next                   <= i_x;
    i_y_next                   <= i_y;
    i_x_step_next              <= i_x_step;
    i_y_step_next              <= i_y_step;
    vga_address_step_next      <= vga_address_step;
    vga_address_step_temp_next <= vga_address_step_temp;
    row_index_next             <= row_index;
    if (vga_blank = '0') then
      if (i_x_step = c_x_step - 1) then
        i_x_step_next <= 0;
        vga_address_step_next <=
          std_logic_vector (to_unsigned (to_integer (unsigned (vga_address_step)) + 1, 15));
        if (i_x = c_x - 1) then
          vga_address_step_next <=
            std_logic_vector (to_unsigned (to_integer (unsigned (vga_address_step_temp)), 15));
          i_x_next <= 0;
          if (i_y_step = c_y_step - 1) then
            i_y_step_next <= 0;
            row_index_next <= 0;
            vga_address_step_next <=
              std_logic_vector (to_unsigned (to_integer (unsigned (vga_address_step_temp)) + c_x, 15));
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
        vga_address_step_temp_next <=
          std_logic_vector (to_unsigned (to_integer (unsigned (vga_address_step_next)), 15));
      end if;
    end if;
    if (vga_v_blank = '1') then
      vga_address_step_next <= (others => '0');
    end if;
  end process p_vga_address_generator_combinatorial;

  --synthesis translate_off
  p_report_address_and_color : process (vga_write(0)) is
  begin
    if (rising_edge (vga_write(0))) then
      report
        "Color " & integer'image (to_integer (unsigned (vga_color))) & " " &
        "at address " & integer'image (to_integer (unsigned (vga_all_pixels)));
    end if;
  end process p_report_address_and_color;
  --synthesis translate_on

  p_io_registers_decoder : process (i_cpu_clock, i_reset) is
  begin
    if (i_reset = '1') then
      vga_all_pixels <= (others => '0');
      vga_color <= (others => '0');
      vga_write <= "0";
    elsif (rising_edge (i_cpu_clock)) then
      case (kcpsm3_port_id) is
        when x"16" =>
          if (kcpsm3_write_strobe = '1') then
            vga_all_pixels (7 downto 0) <= kcpsm3_out_port (7 downto 0);
            vga_write <= "0";
          end if;
        when x"17" =>
          if (kcpsm3_write_strobe = '1') then
            vga_all_pixels (14 downto 8) <= kcpsm3_out_port (6 downto 0);
            vga_write <= "0";
          end if;
        when x"20" =>
          if (kcpsm3_write_strobe = '1') then
            vga_color (5 downto 0) <= kcpsm3_out_port (5 downto 0);
            vga_write <= "1";
          end if;
        when others =>
          vga_write <= "0";
          vga_all_pixels <= (others => '0');
          vga_color <= (others => '0');
      end case;
    end if;
  end process p_io_registers_decoder;

  vga_address <= vga_address_step; -- input
  inst_ipcore_vga_ramb16_dp : ipcore_vga_ramb16_dp
  port map (
  clka  => i_cpu_clock,
  wea   => vga_write,
  addra => vga_all_pixels,
  dina  => vga_color,
  clkb  => vga_clock,
  addrb => vga_address,
  doutb => vga_color1
  );

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
  o_r     => o_r,
  o_g     => o_g,
  o_b     => o_b
  );

  inst_kcpsm3 : kcpsm3
  port map (
  address       => kcpsm3_address,
  instruction   => kcpsm3_instruction,
  port_id       => kcpsm3_port_id,
  write_strobe  => kcpsm3_write_strobe,
  out_port      => kcpsm3_out_port,
  read_strobe   => kcpsm3_read_strobe,
  in_port       => kcpsm3_in_port,
  interrupt     => kcpsm3_interrupt,
  interrupt_ack => kcpsm3_interrupt_ack,
  reset         => i_reset,
  clk           => i_cpu_clock
  );

  inst_program : program
  port map (
  address     => kcpsm3_address,
  instruction => kcpsm3_instruction,
  clk         => i_cpu_clock
  );

end architecture behavioral;
