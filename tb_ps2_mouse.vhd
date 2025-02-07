--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02/08/2025
-- Design Name:   
-- Module Name:   /home/user/_WORKSPACE_/kedziorno/kcpsm3_vga/tb_ps2_mouse.vhd
-- Project Name:  kcpsm3_vga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ps2_mouse
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

ENTITY tb_ps2_mouse IS
END tb_ps2_mouse;

ARCHITECTURE behavior OF tb_ps2_mouse IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT ps2_mouse
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_PS2_Clk : IN  std_logic;
i_PS2_Data : IN  std_logic;
i_do_read : IN  std_logic;
o_scan_ready : OUT  std_logic;
o_trigger : OUT  std_logic;
o_parity_error : OUT  std_logic;
o_x_movement : OUT  std_logic_vector(7 downto 0);
o_y_movement : OUT  std_logic_vector(7 downto 0);
o_x_overflow : OUT  std_logic;
o_y_overflow : OUT  std_logic;
o_x_sign : OUT  std_logic;
o_y_sign : OUT  std_logic;
o_button_middle : OUT  std_logic;
o_button_right : OUT  std_logic;
o_button_left : OUT  std_logic
);
END COMPONENT;

constant c_PS2_Clk_phase : std_logic := '1';
-- Clock period definitions
constant i_clock_period : time := 10 ns;
constant i_PS2_Clk_period : time := 100 us;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_PS2_Clk : std_logic := c_PS2_Clk_phase;
signal i_PS2_Data : std_logic := '1';
signal i_do_read : std_logic := '1';

--Outputs
signal o_scan_ready : std_logic;
signal o_trigger : std_logic;
signal o_parity_error : std_logic;
signal o_x_movement : std_logic_vector(7 downto 0);
signal o_y_movement : std_logic_vector(7 downto 0);
signal o_x_overflow : std_logic;
signal o_y_overflow : std_logic;
signal o_x_sign : std_logic;
signal o_y_sign : std_logic;
signal o_button_middle : std_logic;
signal o_button_right : std_logic;
signal o_button_left : std_logic;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: ps2_mouse PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_PS2_Clk => i_PS2_Clk,
i_PS2_Data => i_PS2_Data,
i_do_read => i_do_read,
o_scan_ready => o_scan_ready,
o_trigger => o_trigger,
o_parity_error => o_parity_error,
o_x_movement => o_x_movement,
o_y_movement => o_y_movement,
o_x_overflow => o_x_overflow,
o_y_overflow => o_y_overflow,
o_x_sign => o_x_sign,
o_y_sign => o_y_sign,
o_button_middle => o_button_middle,
o_button_right => o_button_right,
o_button_left => o_button_left
);

-- Clock process definitions
i_clock_process : process
begin
i_clock <= not i_clock;
wait for i_clock_period/2;
end process;

--i_PS2_Clk_process : process
--begin
--i_PS2_Clk <= not i_PS2_Clk;
--wait for i_PS2_Clk_period/2;
--end process;

-- Stimulus process
stim_proc: process
procedure ps2_tick (one_bit : std_logic; X : boolean := false) is
variable temp_clk : std_logic;
begin
temp_clk := i_PS2_Clk;
if (X = false) then
i_PS2_Data <= one_bit;
i_PS2_Clk <= not i_PS2_Clk;
wait for i_PS2_Clk_period/2;
i_PS2_Data <= one_bit;
i_PS2_Clk <= i_PS2_Clk;
wait for i_PS2_Clk_period/2;
i_PS2_Data <= one_bit;
i_PS2_Clk <= not i_PS2_Clk;
wait for i_PS2_Clk_period/2;
i_PS2_Data <= one_bit;
i_PS2_Clk <= i_PS2_Clk;
wait for i_PS2_Clk_period/2;
else
i_PS2_Data <= 'X';
i_PS2_Clk <= 'X';
wait for i_PS2_Clk_period/2;
i_PS2_Data <= 'X';
i_PS2_Clk <= 'X';
wait for i_PS2_Clk_period/2;
i_PS2_Data <= 'X';
i_PS2_Clk <= 'X';
wait for i_PS2_Clk_period/2;
i_PS2_Data <= 'X';
i_PS2_Clk <= 'X';
wait for i_PS2_Clk_period/2;
end if;
i_PS2_Clk <= temp_clk;
wait for 1 fs;
end procedure ps2_tick;
procedure ps2_byte (byte : std_logic_vector (7 downto 0); parity : std_logic; X : boolean := false) is
begin
ps2_tick ('0', X); -- start
ps2_tick (byte (0), X);
ps2_tick (byte (1), X);
ps2_tick (byte (2), X);
ps2_tick (byte (3), X);
ps2_tick (byte (4), X);
ps2_tick (byte (5), X);
ps2_tick (byte (6), X);
ps2_tick (byte (7), X);
ps2_tick (parity, X);
ps2_tick ('1', X); -- stop
end procedure ps2_byte;
begin
-- hold reset state for 100 ns.
i_reset <= '1';
wait for 100 ns;
i_reset <= '0';
wait for i_clock_period*10;
-- insert stimulus here
-- idle 00
ps2_byte (x"00", '1');
-- frame f0
ps2_byte (x"f0", '1');
-- frame 81
ps2_byte (x"81", '1');
-- frame 85
ps2_byte (x"85", '1'); -- parity error
-- frame aa
ps2_byte (x"aa", '1');
-- idle frame
ps2_byte (x"ff", '1');
-- X frame 00
ps2_byte (x"00", '1', true);
-- X frame ff
ps2_byte (x"ff", '1', true);
report "tb done" severity failure;
wait;
end process;

END;
