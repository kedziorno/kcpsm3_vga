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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS

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
o_b         : OUT std_logic_vector (1 downto 0)
);
END COMPONENT;

--Inputs
signal i_cpu_clock : std_logic := '1';
signal i_vga_clock : std_logic := '1';
signal i_reset : std_logic := '0';

--Outputs
signal o_hsync : std_logic;
signal o_vsync : std_logic;
signal o_blank : std_logic;
signal o_h_blank : std_logic;
signal o_v_blank : std_logic;
signal o_r : std_logic_vector (1 downto 0);
signal o_g : std_logic_vector (1 downto 0);
signal o_b : std_logic_vector (1 downto 0);

-- Clock period definitions
constant i_cpu_clock_period : time := 10 ns;
--constant i_vga_clock_period : time := 39.720 ns;
--constant i_vga_clock_period : time := 39.722 ns;
--constant i_vga_clock_period : time := 39.965 ns;
constant i_vga_clock_period : time := 40 ns;

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
o_b         => o_b
);

-- Clock process definitions
i_cpu_clock_process : process
  variable first_wait : time := 0 ns;
  variable first_wait_flag : boolean := false;
begin
if (first_wait_flag = false) then
  wait for first_wait;
  first_wait_flag := true;
end if;
i_cpu_clock <= not i_cpu_clock;
wait for i_cpu_clock_period/2;
end process i_cpu_clock_process;

i_vga_clock_process : process
  variable first_wait : time := 0 ns;
  variable first_wait_flag : boolean := false;
begin
if (first_wait_flag = false) then
  wait for first_wait;
  first_wait_flag := true;
end if;
i_vga_clock <= not i_vga_clock;
wait for i_vga_clock_period/2;
end process i_vga_clock_process;

-- Stimulus process
stim_proc : process
begin
-- hold reset state for 100 ns.
i_reset <= '1';
wait for i_cpu_clock_period*10;
i_reset <= '0';
wait for i_cpu_clock_period*10;
-- insert stimulus here
wait for 16.81 ms * 3;
report "tb done" severity failure;
end process;

blank (0) <= not (o_h_blank or o_v_blank);
blank (1) <= not (o_h_blank or o_v_blank);

inst_vga_bmp_sink : vga_bmp_sink
generic map (
FILENAME     => "vga.bmp"
)
port map (
clk_i        => i_vga_clock,
rst_i        => i_reset,
dat_i        => o_r (1) & o_r (0) & blank & "0000" & o_g (1) & o_g (0) & blank & "0000" & o_b (1) & o_b (0) & blank & "0000",
active_vid_i => not o_blank,
h_sync_i     => o_hsync,
v_sync_i     => o_vsync
);

END;
