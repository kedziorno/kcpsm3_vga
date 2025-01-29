----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    01/29/2025
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library std;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.p_package1.all;

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

--  component vga_clock_25mhz is
--  port (
--  i_clock, i_reset : in  std_logic;
--  o_vga_clock      : out std_logic
--  );
--  end component vga_clock_25mhz;

--  component vga_timing is
--  port (
--  i_clock, i_reset : in  std_logic;
--  o_hsync          : out std_logic;
--  o_vsync          : out std_logic;
--  o_blank          : out std_logic;
--  o_h_blank        : out std_logic;
--  o_v_blank        : out std_logic
--  );
--  end component vga_timing;

--  component vga_address_generator is
--  port (
--  i_clock, i_reset : in  std_logic;
--  i_vga_blank      : in  std_logic;
--  i_vga_v_blank    : in  std_logic;
--  o_vga_address    : out std_logic_vector (c_memory_address_bits - 1 downto 0)
--  );
--  end component vga_address_generator;

--  component vga_rgb is
--  port (
--  i_clock, i_reset : in  std_logic;
--  i_color          : in  std_logic_vector (5 downto 0);
--  i_blank          : in  std_logic;
--  o_r              : out std_logic_vector (1 downto 0);
--  o_g              : out std_logic_vector (1 downto 0);
--  o_b              : out std_logic_vector (1 downto 0)
--  );
--  end component vga_rgb;

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

  component program
  port (
  address     : in  std_logic_vector (9 downto 0);
  instruction : out std_logic_vector (17 downto 0);
  clk         : in  std_logic
  );
  end component program;

  component kcpsm3_io_registers_decoder is
  port (
  i_clock, i_reset       : in  std_logic;
  i_kcpsm3_port_id       : in  std_logic_vector (7 downto 0);
  i_kcpsm3_out_port      : in  std_logic_vector (7 downto 0);
  o_kcpsm3_in_port       : out  std_logic_vector (7 downto 0);
  i_kcpsm3_write_strobe  : in  std_logic;
  i_kcpsm3_read_strobe   : in  std_logic;
  o_kcpsm3_interrupt     : out std_logic;
  i_kcpsm3_interrupt_ack : in  std_logic;
  o_pixel_coordination   : out std_logic_vector (c_memory_address_bits - 1 downto 0);
  o_pixel_color          : out std_logic_vector (c_color_bits - 1 downto 0);
  o_pixel_write          : out std_logic_vector (0 downto 0);
  TR0_timer              : inout std_logic := '0';
  TF0_timer              : in std_logic := '0';
  TC0_timer              : out unsigned (7 downto 0) := (others => '0');
  TR1_timer              : inout std_logic := '0';
  TF1_timer              : in std_logic := '0';
  TC1_timer              : out unsigned (15 downto 0) := (others => '0');
  -- o_testX not used in synthesis
  o_test8                : out std_logic_vector (7 downto 0);
  o_test7                : out std_logic_vector (7 downto 0);
  o_test6                : out std_logic_vector (7 downto 0);
  o_test5                : out std_logic_vector (7 downto 0);
  o_test4                : out std_logic_vector (7 downto 0);
  o_test3                : out std_logic_vector (7 downto 0);
  o_test2                : out std_logic_vector (7 downto 0);
  o_test1                : out std_logic_vector (7 downto 0);
  o_test0                : out std_logic_vector (7 downto 0)
  );
  end component kcpsm3_io_registers_decoder;

  signal vga_clock                           : std_logic;
  signal vga_blank, vga_h_blank, vga_v_blank : std_logic;
  signal pixel_coordination, vga_address     : std_logic_vector (c_memory_address_bits - 1 downto 0);
  signal pixel_color, vga_color              : std_logic_vector (c_color_bits - 1 downto 0);
  signal pixel_write                         : std_logic_vector (0 downto 0);

  signal kcpsm3_address       : std_logic_vector (9 downto 0);
  signal kcpsm3_instruction   : std_logic_vector (17 downto 0);
  signal kcpsm3_port_id       : std_logic_vector (7 downto 0);
  signal kcpsm3_out_port      : std_logic_vector (7 downto 0);
  signal kcpsm3_in_port       : std_logic_vector (7 downto 0);
  signal kcpsm3_write_strobe  : std_logic;
  signal kcpsm3_read_strobe   : std_logic;
  signal kcpsm3_interrupt     : std_logic := '0';
  signal kcpsm3_interrupt_ack : std_logic;

--synthesis translate_ff
  signal o_test0 : std_logic_vector (7 downto 0);
  signal o_test4, o_test3, o_test2, o_test1 : std_logic_vector (7 downto 0);
  signal o_test8, o_test7, o_test6, o_test5 : std_logic_vector (7 downto 0);

  signal test_concatenate_21 : std_logic_vector (15 downto 0);
  signal test_concatenate_43 : std_logic_vector (15 downto 0);
  signal test_concatenate_65 : std_logic_vector (15 downto 0);
  signal test_concatenate_87 : std_logic_vector (15 downto 0);
  signal test_concatenate_4321 : std_logic_vector (31 downto 0);
  signal test_concatenate_8765 : std_logic_vector (31 downto 0);
--synthesis translate_on

--synthesis translate_off
  signal s_counter : std_logic_vector (31 downto 0);
--synthesis translate_on

--------------------------------------------------------------------------
-- Timer0 control
--------------------------------------------------------------------------
signal Timer0 : unsigned (7 downto 0) := X"00";
signal TR0 : std_logic := '0';
signal TF0 : std_logic := '0';
signal TC0 : unsigned (7 downto 0) := (others => '0'); 
--------------------------------------------------------------------------
-- Timer1 control
--------------------------------------------------------------------------
signal Timer1 : unsigned (15 downto 0) := X"0000";
signal TR1 : std_logic := '0';
signal TF1 : std_logic := '0';
signal TC1 : unsigned (15 downto 0) := (others => '0'); 

begin

--  o_blank   <= vga_blank;
--  o_h_blank <= vga_h_blank;
--  o_v_blank <= vga_v_blank;

  --synthesis translate_off
--  p_report_address_and_color : process (pixel_write(0)) is
--  begin
--    if (rising_edge (pixel_write(0))) then
--      report
--        "Color " & integer'image (to_integer (unsigned (pixel_color))) & " " &
--        "at address " & integer'image (to_integer (unsigned (pixel_coordination)));
--    end if;
--  end process p_report_address_and_color;
  --synthesis translate_on

--synthesis translate_off
--  p_report1 : process (i_cpu_clock) is
--    variable i : integer := 0;
--  begin
--    if (rising_edge (i_cpu_clock)) then
--      if (to_integer (unsigned (kcpsm3_address)) = 103) then
--        report integer'image (i) & " tick address " & integer'image (to_integer (unsigned (kcpsm3_address)));
--        i := i + 1;
--      end if;
--    end if;
--  end process p_report1;
  p_report2 : process (kcpsm3_write_strobe) is
    constant c_index : integer := 3;
    variable v_counter : std_logic_vector (c_index * 8 - 1 downto 0) := (others => '0');
    variable index : integer range 0 to c_index - 1 := 0;
  begin
    if (falling_edge (kcpsm3_write_strobe)) then
      if (to_integer (unsigned (kcpsm3_port_id)) = 1) then
        v_counter := kcpsm3_out_port & v_counter (c_index * 8 - 1 downto 8); -- LO first
        if (index = c_index - 1) then
          s_counter <= v_counter;
          index := 0;
        else
          --s_counter <= (others => '0');
          index := index + 1;
        end if;
      end if;
    end if;
  end process p_report2;
--synthesis translate_on

--  inst_vga_clock_25mhz : vga_clock_25mhz
--  port map (
--  i_clock     => i_cpu_clock,
--  i_reset     => i_reset,
--  o_vga_clock => vga_clock
--  );

--  inst_vga_timing : vga_timing
--  port map (
--  i_clock   => vga_clock,
--  i_reset   => i_reset,
--  o_hsync   => o_hsync,
--  o_vsync   => o_vsync,
--  o_blank   => vga_blank,
--  o_h_blank => vga_h_blank,
--  o_v_blank => vga_v_blank
--  );

--  inst_vga_address_generator : vga_address_generator
--  port map (
--  i_clock       => vga_clock,
--  i_reset       => i_reset,
--  i_vga_blank   => vga_blank,
--  i_vga_v_blank => vga_v_blank,
--  o_vga_address => vga_address
--  );

--  inst_vga_rgb : vga_rgb
--  port map (
--  i_clock => vga_clock,
--  i_reset => i_reset,
--  i_color => vga_color,
--  i_blank => vga_blank,
--  o_r     => o_r,
--  o_g     => o_g,
--  o_b     => o_b
--  );

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

  inst_kcpsm3_rom_memory_content : program
  port map (
  address     => kcpsm3_address,
  instruction => kcpsm3_instruction,
  clk         => i_cpu_clock
  );

  inst_kcpsm3_io_registers_decoder : kcpsm3_io_registers_decoder
  port map (
  i_clock                => i_cpu_clock,
  i_reset                => i_reset,
  i_kcpsm3_port_id       => kcpsm3_port_id,
  i_kcpsm3_out_port      => kcpsm3_out_port,
  o_kcpsm3_in_port       => kcpsm3_in_port,
  i_kcpsm3_write_strobe  => kcpsm3_write_strobe,
  i_kcpsm3_read_strobe   => kcpsm3_read_strobe,
  o_kcpsm3_interrupt     => kcpsm3_interrupt,
  i_kcpsm3_interrupt_ack => kcpsm3_interrupt_ack,
  o_pixel_coordination   => pixel_coordination,
  o_pixel_color          => pixel_color,
  o_pixel_write          => pixel_write,
  TR0_timer              => TR0,
  TF0_timer              => TF0,
  TC0_timer              => TC0,
  TR1_timer              => TR1,
  TF1_timer              => TF1,
  TC1_timer              => TC1,
  o_test8                => o_test8,
  o_test7                => o_test7,
  o_test6                => o_test6,
  o_test5                => o_test5,
  o_test4                => o_test4,
  o_test3                => o_test3,
  o_test2                => o_test2,
  o_test1                => o_test1,
  o_test0                => o_test0
  );

-------------------------------------------------------------------------------
--  TIMER COUNTS SYSTEM:
--  This system controls the timer and set the timer flag when the timer is 
--  run out. 
-------------------------------------------------------------------------------

  Timer0_control : process (i_cpu_clock)
  begin 
    if (rising_edge (i_cpu_clock) and TR0 = '1') then -- Wait for a clock event and
      if (Timer0 = TC0) then -- TR0 is set active to run
        Timer0 <= X"00"; -- Compare the Timer 0 with the TC0 value
        TF0 <= '1'; -- If this is true will the timer count be set
      else -- to zero and enable the Timer flag with a one.
        Timer0 <= Timer0 + 1; -- If this not are true the counter will
        TF0 <= '0'; -- add one and the Timer flag will be
      end if; -- disable.
    end if;
  end process Timer0_control;

  Timer1_control : process (i_cpu_clock)
  begin
    if (rising_edge (i_cpu_clock) and TR1 = '1') then -- Wait for a clock event and
      if (Timer1 = TC1) then -- TR1 is set active to run
        Timer1 <= X"0000"; -- Compare the Timer 1 with the TC1 value
        TF1 <= '1'; -- If this is true will the timer count be set
      else -- to zero and enable the Timer flag with a one.
        Timer1 <= Timer1 + 1; -- If this not are true the counter will
        TF1 <= '0'; -- add one and the Timer flag will be
      end if; -- disable.
    end if;
  end process Timer1_control;

end architecture behavioral;
