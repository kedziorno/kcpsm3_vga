--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01/05/2025
-- Design Name:   
-- Module Name:   /home/user/_WORKSPACE_/kedziorno/kcpsm3_vga/tb_kcpsm3_io_registers_decoder.vhd
-- Project Name:  kcpsm3_vga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: kcpsm3_io_registers_decoder
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
USE ieee.numeric_std.ALL;

ENTITY tb_kcpsm3_io_registers_decoder IS
END tb_kcpsm3_io_registers_decoder;

ARCHITECTURE behavior OF tb_kcpsm3_io_registers_decoder IS

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT kcpsm3_io_registers_decoder
PORT(
i_clock : IN  std_logic;
i_reset : IN  std_logic;
i_kcpsm3_port_id : IN  std_logic_vector(7 downto 0);
i_kcpsm3_out_port : IN  std_logic_vector(7 downto 0);
i_kcpsm3_write_strobe : IN  std_logic;
o_pixel_coordination : OUT  std_logic_vector(14 downto 0);
o_pixel_color : OUT  std_logic_vector(5 downto 0);
o_pixel_write : OUT  std_logic_vector(0 downto 0)
);
END COMPONENT;

--Inputs
signal i_clock : std_logic := '0';
signal i_reset : std_logic := '0';
signal i_kcpsm3_port_id : std_logic_vector(7 downto 0) := (others => '0');
signal i_kcpsm3_out_port : std_logic_vector(7 downto 0) := (others => '0');
signal i_kcpsm3_write_strobe : std_logic := '0';

--Outputs
signal o_pixel_coordination : std_logic_vector(14 downto 0);
signal o_pixel_color : std_logic_vector(5 downto 0);
signal o_pixel_write : std_logic_vector(0 downto 0);

-- Clock period definitions
constant i_clock_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut : kcpsm3_io_registers_decoder PORT MAP (
i_clock => i_clock,
i_reset => i_reset,
i_kcpsm3_port_id => i_kcpsm3_port_id,
i_kcpsm3_out_port => i_kcpsm3_out_port,
i_kcpsm3_write_strobe => i_kcpsm3_write_strobe,
o_pixel_coordination => o_pixel_coordination,
o_pixel_color => o_pixel_color,
o_pixel_write => o_pixel_write
);

-- Clock process definitions
i_clock_process : process
begin
i_clock <= '0';
wait for i_clock_period/2;
i_clock <= '1';
wait for i_clock_period/2;
end process;

-- Stimulus process
stim_proc : process
begin
-- hold reset state for 100 ns.
i_reset <= '1';
wait for 100 ns;
i_reset <= '0';
wait for i_clock_period*3;

-- insert stimulus here

i_kcpsm3_port_id <= x"16";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (2, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"17";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (2, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"20";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (40, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

wait for i_clock_period*3;

i_kcpsm3_port_id <= x"16";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (5, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"17";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (5, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"20";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (40, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

wait for i_clock_period*3;

i_kcpsm3_port_id <= x"16";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (7, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"17";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (7, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"20";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (40, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

wait for i_clock_period*3;

i_kcpsm3_port_id <= x"16";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (160, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"17";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (120, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"20";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (40, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

wait for i_clock_period*3;

i_kcpsm3_port_id <= x"16";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (120, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"17";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (160, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"20";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (40, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

wait for i_clock_period*3;

---
i_kcpsm3_port_id <= x"16";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (159, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"17";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (119, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"20";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (40, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

wait for i_clock_period*3;
---

i_kcpsm3_port_id <= x"16";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (119, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"17";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (159, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

i_kcpsm3_port_id <= x"20";
i_kcpsm3_out_port <= std_logic_vector (to_unsigned (40, 8));
i_kcpsm3_write_strobe <= '1';
wait for i_clock_period;
i_kcpsm3_write_strobe <= '0';
wait for i_clock_period;

wait for i_clock_period*3;

report "tb done" severity failure;
wait;
end process stim_proc;

END;
