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
i_clock : IN  std_logic;
i_reset : IN  std_logic;
o_hsync : OUT  std_logic;
o_vsync : OUT  std_logic;
o_blank : OUT  std_logic;
o_r, o_g, o_b : out std_logic
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';

--Outputs
signal o_hsync : std_logic;
signal o_vsync : std_logic;
signal o_blank : std_logic;
signal o_r, o_g, o_b : std_logic;

-- Clock period definitions
--constant i_clock_period : time := 39.720 ns;
--constant i_clock_period : time := 39.722 ns;
constant i_clock_period : time := 40 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: top PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
o_hsync => o_hsync,
o_vsync => o_vsync,
o_blank => o_blank,
o_r => o_r,
o_g => o_g,
o_b => o_b
);

-- Clock process definitions
i_clock_process: process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
i_reset <= '1';
wait for i_clock_period;
i_reset <= '0';
wait for i_clock_period*10;
-- insert stimulus here
wait;
end process;

END;
