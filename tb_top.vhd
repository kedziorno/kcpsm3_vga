--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12/25/2024
-- Design Name:   
-- Module Name:   /home/user/_WORKSPACE_/kedziorno/kcpsm3_vga/tb_top.vhd
-- Project Name:  kcpsm3_vga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS

constant c_PS2_Clk_phase : std_logic := '0';

-- Clock period definitions
constant i_cpu_clock_period : time := 20 ns;

--constant i_ps2_mclk_period : time := 100 us; -- 10 kHz
constant i_ps2_mclk_period : time := 40 us; -- 16.7 kHz

--constant i_vga_clock_period : time := 39.720 ns;
--constant i_vga_clock_period : time := 39.722 ns;
--constant i_vga_clock_period : time := 39.965 ns;
constant i_vga_clock_period : time := 40 ns; -- 25 MHz

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT top
PORT(
  i_cpu_clock : IN  std_logic;
  i_vga_clock : IN  std_logic;
  i_reset     : IN  std_logic;
  o_hsync     : OUT std_logic;
  o_vsync     : OUT std_logic;
  o_blank     : OUT std_logic;
  o_h_blank   : OUT std_logic;
  o_v_blank   : OUT std_logic;
  o_r         : OUT std_logic_vector (1 downto 0);
  o_g         : OUT std_logic_vector (1 downto 0);
  o_b         : OUT std_logic_vector (1 downto 0);
  i_ps2_mdata : IN  std_logic;
  i_ps2_mclk  : IN  std_logic
);
END COMPONENT;

--Inputs
signal i_cpu_clock : std_logic := '1';
signal i_vga_clock : std_logic := '1';
signal i_reset     : std_logic := '0';
signal i_ps2_mdata : std_logic := '1';
signal i_ps2_mclk  : std_logic := c_PS2_Clk_phase;

signal ps2_data, ps2_clock : std_logic;

--Outputs
signal o_hsync   : std_logic;
signal o_vsync   : std_logic;
signal o_blank   : std_logic;
signal o_h_blank : std_logic;
signal o_v_blank : std_logic;
signal o_r       : std_logic_vector (1 downto 0);
signal o_g       : std_logic_vector (1 downto 0);
signal o_b       : std_logic_vector (1 downto 0);

signal blank : std_logic_vector (1 downto 0);

component vga_bmp_sink is
generic (
  FILENAME     : string
);
port (
  clk_i        : in std_logic;
  rst_i        : in std_logic;
  dat_i        : in std_logic_vector (23 downto 0);
  active_vid_i : in std_logic;
  h_sync_i     : in std_logic;
  v_sync_i     : in std_logic
);
end component vga_bmp_sink;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut : top PORT MAP (
  i_cpu_clock => i_cpu_clock,
  i_vga_clock => i_vga_clock,
  i_reset     => i_reset,
  o_hsync     => o_hsync,
  o_vsync     => o_vsync,
  o_blank     => o_blank,
  o_h_blank   => o_h_blank,
  o_v_blank   => o_v_blank,
  o_r         => o_r,
  o_g         => o_g,
  o_b         => o_b,
  i_ps2_mdata => ps2_data,
  i_ps2_mclk  => ps2_clock
);

blank (0) <= not (o_h_blank or o_v_blank);
blank (1) <= not (o_h_blank or o_v_blank);

inst_vga_bmp_sink : vga_bmp_sink
generic map (
  FILENAME     => "vga.bmp"
)
port map (
  clk_i        => i_vga_clock,
  rst_i        => i_reset,
  dat_i        =>
    o_r (1) & o_r (0) & blank & "0000" &
    o_g (1) & o_g (0) & blank & "0000" &
    o_b (1) & o_b (0) & blank & "0000",
  active_vid_i => not o_blank,
  h_sync_i     => o_hsync,
  v_sync_i     => o_vsync
);

-- Clock process definitions
p0_cpu_clock : process
  variable first_wait : time := 0 ns;
  variable first_wait_flag : boolean := false;
begin
  if (first_wait_flag = false) then
    wait for first_wait;
    first_wait_flag := true;
  end if;
  i_cpu_clock <= not i_cpu_clock;
  wait for i_cpu_clock_period/2;
end process p0_cpu_clock;

p1_vga_clock : process
  variable first_wait : time := 0 ns;
  variable first_wait_flag : boolean := false;
begin
  if (first_wait_flag = false) then
    wait for first_wait;
    first_wait_flag := true;
  end if;
  i_vga_clock <= not i_vga_clock;
  wait for i_vga_clock_period/2;
end process p1_vga_clock;

p2_test_ps2_parity : process
  procedure ps2_tick (
    one_bit : std_logic;
    X : boolean := false
  ) is
    variable temp_clk : std_logic;
  begin
    temp_clk := i_ps2_mclk;
    if (X = false) then
      i_ps2_mdata <= one_bit;
      i_ps2_mclk <= not i_ps2_mclk;
      wait for i_ps2_mclk_period/2;
      i_ps2_mdata <= one_bit;
      i_ps2_mclk <= i_ps2_mclk;
      wait for i_ps2_mclk_period/2;
      i_ps2_mdata <= one_bit;
      i_ps2_mclk <= not i_ps2_mclk;
      wait for i_ps2_mclk_period/2;
      i_ps2_mdata <= one_bit;
      i_ps2_mclk <= i_ps2_mclk;
      wait for i_ps2_mclk_period/2;
    else
      i_ps2_mdata <= 'X';
      i_ps2_mclk <= 'X';
      wait for i_ps2_mclk_period/2;
      i_ps2_mdata <= 'X';
      i_ps2_mclk <= 'X';
      wait for i_ps2_mclk_period/2;
      i_ps2_mdata <= 'X';
      i_ps2_mclk <= 'X';
      wait for i_ps2_mclk_period/2;
      i_ps2_mdata <= 'X';
      i_ps2_mclk <= 'X';
      wait for i_ps2_mclk_period/2;
    end if;
    i_ps2_mclk <= temp_clk;
    wait for 1 fs;
  end procedure ps2_tick;

  procedure ps2_byte (
    byte : std_logic_vector (7 downto 0);
    parity : std_logic;
    X : boolean := false
  ) is
  begin
    ps2_tick ('0', X); -- start
    ps2_tick (byte (0), X); -- LSB first
    ps2_tick (byte (1), X);
    ps2_tick (byte (2), X);
    ps2_tick (byte (3), X);
    ps2_tick (byte (4), X);
    ps2_tick (byte (5), X);
    ps2_tick (byte (6), X);
    ps2_tick (byte (7), X);
    ps2_tick (parity, X); -- parity (odd)
    ps2_tick ('1', X); -- stop
  end procedure ps2_byte;
begin
  -- hold reset state for 100 ns.
  wait for 100 ns;
  wait for 100 ns;
  -- insert stimulus here
  i_ps2_mdata <= '1'; i_ps2_mclk <= '1'; wait for 1 ms; -- idle PS/2 line
  -- idle 00
  ps2_byte (x"10", '1'); wait for 250 us;
  -- frame f0
  ps2_byte (x"12", '1'); wait for 250 us;
  -- frame 81
  ps2_byte (x"14", '1'); wait for 250 us;
  -- frame 85
  ps2_byte (x"26", '1'); wait for 250 us; -- parity error
  i_ps2_mdata <= '1'; i_ps2_mclk <= '1'; wait for 1 ms; -- idle PS/2 line
  -- frame aa
  ps2_byte (x"28", '1'); wait for 250 us;
  -- idle frame
  ps2_byte (x"2a", '1'); wait for 250 us;
  -- X frame 00
  ps2_byte (x"3c", '1'); wait for 250 us;
  -- X frame ff
  ps2_byte (x"3f", '1'); wait for 250 us;
  i_ps2_mdata <= '1'; i_ps2_mclk <= '1'; wait for 1 ms; -- idle PS/2 line
  ps2_byte (x"30", '1', true);
  wait;
end process p2_test_ps2_parity;

-- Stimulus process
p3_main : process
begin
  -- hold reset state for 100 ns.
  i_reset <= '1';
  wait for i_cpu_clock_period*10;
  i_reset <= '0';
  wait for i_cpu_clock_period*10;
  -- insert stimulus here
  --wait for 16.81 ms * 5;
  wait for 2000 ms;
  report "tb done" severity failure;
end process p3_main;

p4_send_ps2_data : process is
  --constant ps2_wait_packet : time := 6.15 ms;
  constant ps2_wait_packet : time := 17 ms;
  procedure ps2_packet (
    ps2_in : in std_logic_vector (4 * 8 - 1 downto 0) -- flags,x,y,z 8-bit
  ) is
    constant ps2_wait_byte : time := 220 us;
    variable ps2_xor : std_logic;
    function xorn (x : std_logic_vector (7 downto 0)) return std_logic is
      variable r : std_logic := '0';
    begin
      r := x(7) xor x(6) xor x(5) xor x(4) xor x(3) xor x(2) xor x(1) xor x(0);
      r := not r;
      return r;
    end function;
  begin
    -- flags
    ps2_clock <= '0'; ps2_data <= '0'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <= '0'; wait for i_ps2_mclk_period;
    for i in 24 to 31 loop
      ps2_clock <= '0'; ps2_data <= ps2_in (i); wait for i_ps2_mclk_period;
      ps2_clock <= '1'; ps2_data <= ps2_in (i); wait for i_ps2_mclk_period;
    end loop;
    ps2_xor := xorn (ps2_in (31 downto 24));
    ps2_clock <= '0'; ps2_data <= ps2_xor; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <= ps2_xor; wait for i_ps2_mclk_period;
    ps2_clock <= '0'; ps2_data <=     '1'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <=     '1'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <=     '1'; wait for ps2_wait_byte;
    -- x
    ps2_clock <= '0'; ps2_data <= '0'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <= '0'; wait for i_ps2_mclk_period;
    for i in 16 to 23 loop
      ps2_clock <= '0'; ps2_data <= ps2_in (i); wait for i_ps2_mclk_period;
      ps2_clock <= '1'; ps2_data <= ps2_in (i); wait for i_ps2_mclk_period;
    end loop;
    ps2_xor := xorn (ps2_in (23 downto 16));
    ps2_clock <= '0'; ps2_data <= ps2_xor; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <= ps2_xor; wait for i_ps2_mclk_period;
    ps2_clock <= '0'; ps2_data <=     '1'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <=     '1'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <=     '1'; wait for ps2_wait_byte;
    -- y
    ps2_clock <= '0'; ps2_data <= '0'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <= '0'; wait for i_ps2_mclk_period;
    for i in 8 to 15 loop
      ps2_clock <= '0'; ps2_data <= ps2_in (i); wait for i_ps2_mclk_period;
      ps2_clock <= '1'; ps2_data <= ps2_in (i); wait for i_ps2_mclk_period;
    end loop;
    ps2_xor := xorn (ps2_in (15 downto 8));
    ps2_clock <= '0'; ps2_data <= ps2_xor; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <= ps2_xor; wait for i_ps2_mclk_period;
    ps2_clock <= '0'; ps2_data <=     '1'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <=     '1'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <=     '1'; wait for ps2_wait_byte;
    -- z
    ps2_clock <= '0'; ps2_data <= '0'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <= '0'; wait for i_ps2_mclk_period;
    for i in 0 to 7 loop
      ps2_clock <= '0'; ps2_data <= ps2_in (i); wait for i_ps2_mclk_period;
      ps2_clock <= '1'; ps2_data <= ps2_in (i); wait for i_ps2_mclk_period;
    end loop;
    ps2_xor := xorn (ps2_in (7 downto 0));
    ps2_clock <= '0'; ps2_data <= ps2_xor; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <= ps2_xor; wait for i_ps2_mclk_period;
    ps2_clock <= '0'; ps2_data <=     '1'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <=     '1'; wait for i_ps2_mclk_period;
    ps2_clock <= '1'; ps2_data <=     '1'; wait for ps2_wait_byte;
  end procedure ps2_packet;
  procedure zero_packet (x : in boolean := false) is
  begin
    ps2_packet ("00001000"&"00000000"&"00000000"&"00000000");
    wait for ps2_wait_packet;
  end procedure;
  procedure middle_button (x : in boolean := false) is
  begin
    ps2_packet ("00001100"&"00000000"&"00000000"&"00000000");
    wait for ps2_wait_packet;
  end procedure;
  procedure left_button (x : in boolean := false) is
  begin
    ps2_packet ("00001001"&"00000000"&"00000000"&"00000000");
    wait for ps2_wait_packet;
  end procedure;
  procedure right_button (x : in boolean := false) is
  begin
    ps2_packet ("00001010"&"00000000"&"00000000"&"00000000");
    wait for ps2_wait_packet;
  end procedure;
  procedure x_axis_minus (x : in boolean := false) is
  begin
    ps2_packet ("00011000"&"11111111"&"00000000"&"00000000");
    wait for ps2_wait_packet;
  end procedure;
  procedure x_axis_plus (x : in boolean := false) is
  begin
    ps2_packet ("00001000"&"11111111"&"00000000"&"00000000");
    wait for ps2_wait_packet;
  end procedure;
  procedure y_axis_minus (x : in boolean := false) is
  begin
    ps2_packet ("00101000"&"00000000"&"11111111"&"00000000");
    wait for ps2_wait_packet;
  end procedure;
  procedure y_axis_plus (x : in boolean := false) is
  begin
    ps2_packet ("00001000"&"00000000"&"11111111"&"00000000");
    wait for ps2_wait_packet;
  end procedure;
begin
  ps2_clock <= '1'; ps2_data <= '1'; wait for 1 ms; -- idle PS/2 line
  middle_button;
  middle_button;
  middle_button;
  middle_button;
  left_button;
  x_axis_plus;
  x_axis_plus;
  x_axis_plus;
  x_axis_plus;
  x_axis_plus;
  right_button;
  middle_button;
  middle_button;
  middle_button;
  middle_button;
  left_button;
  y_axis_minus;
  y_axis_minus;
  y_axis_minus;
  y_axis_minus;
  y_axis_minus;
  y_axis_minus;
  right_button;
  middle_button;
  middle_button;
  middle_button;
  middle_button;
  left_button;
  x_axis_minus;
  x_axis_minus;
  x_axis_minus;
  x_axis_minus;
  x_axis_minus;
  x_axis_minus;
  right_button;
  middle_button;
  middle_button;
  middle_button;
  middle_button;
  left_button;
  y_axis_plus;
  y_axis_plus;
  y_axis_plus;
  y_axis_plus;
  y_axis_plus;
  y_axis_plus;
  right_button;
  zero_packet;
  wait;
end process p4_send_ps2_data;

END;
