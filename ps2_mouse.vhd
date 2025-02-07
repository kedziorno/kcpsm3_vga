-------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    02/07/2025
-- Design Name:
-- Module Name:    ps2_mouse - Behavioral
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
-- Based on :
--   - https://en.wikipedia.org/wiki/PS/2_port
--   - PONG from Xilinx Example
--   - code for partity calculate from https://github.com/jaint2/VhDL-Projects-/blob/e2f78c86886d4ddcdeddc64efcebca296b0b0403/Projects/Mouse%20VGA/ps2interface.vhd
--
-- Serial data at 10.0-16.7 kHz
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--/////////////////////////////////////////////////////////////////////////////
--// Copyright (c) 1995-2005 Xilinx, Inc.
--// All Right Reserved.
--/////////////////////////////////////////////////////////////////////////////
--//   ____  ____ 
--//  /   /\/   / 
--// /___/  \  /    Vendor: Xilinx 
--// \   \   \/     Version : 8.1i
--//  \   \         Application : ISE
--//  /   /         Filename : ps2_cntrl.v
--// /___/   /\     Timestamp : 9/20/2005 11:12:50
--// \   \  /  \ 
--//  \___\/\___\ 
--//
--//
--//Design Name: PONG
--//
--// This module receives the Clock and serial data input from the PS2 port
--//

entity ps2_mouse is
port (
i_clock : in std_logic;
i_reset : in std_logic;
i_PS2_Clk : in std_logic;
i_PS2_Data : in std_logic;
i_do_read : in std_logic;
o_scan_ready : out std_logic;
o_trigger : out std_logic;
o_parity_error : out std_logic;
o_x_movement : out std_logic_vector (7 downto 0);
o_y_movement : out std_logic_vector (7 downto 0);
o_x_overflow : out std_logic;
o_y_overflow : out std_logic;
o_x_sign : out std_logic;
o_y_sign : out std_logic;
o_button_middle : out std_logic;
o_button_right : out std_logic;
o_button_left : out std_logic
);
end ps2_mouse;

architecture behavioral of ps2_mouse is

signal s_reg : std_logic_vector (8 downto 0);
signal clk_low_filter : unsigned (2 downto 0);
signal clk_high_filter : unsigned (2 downto 0);
signal filter_clk : std_logic;
signal trigger : std_logic;

signal clear_reg : unsigned (1 downto 0);
signal bit_count : unsigned (3 downto 0);

type states is (idle, shifting);
signal scan_state : states;

signal rx_parity, rx_parity_received : std_logic;

signal byte_count_sr : std_logic_vector (2 downto 0);

-- (odd) parity bit ROM
-- Used instead of logic because this way speed is far greater
-- 256x1bit rom
-- If the odd parity bit for a 8 bits number, x, is needed
-- the bit at address x is the parity bit.
type ROM is array (0 to 255) of std_logic;
constant parityrom : ROM := (
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1',
'1','0','0','1','0','1','1','0',
'1','0','0','1','0','1','1','0',
'0','1','1','0','1','0','0','1'
);

-- forces the extraction of distributed ram for
-- the parityrom memory.
-- please remove if block ram is preffered.
attribute rom_extract : string;
attribute rom_extract of parityrom : constant is "yes";
attribute rom_style : string;
attribute rom_style of parityrom : constant is "distributed";

constant c_three : unsigned (2 downto 0) := "011";
constant c_eight : unsigned (3 downto 0) := "1000";
constant c_nine : unsigned (3 downto 0) := "1001";

begin

o_trigger <= trigger;

o_parity_error <= rx_parity xor rx_parity_received;

p_byte_output : process (filter_clk, i_reset) is
begin
  if (i_reset = '1') then
    o_y_overflow <= '0';
    o_x_overflow <= '0';
    o_y_sign <= '0';
    o_x_sign <= '0';
    o_button_middle <= '0';
    o_button_right <= '0';
    o_button_left <= '0';
    o_x_movement <= (others => '0');
    o_y_movement <= (others => '0');
  elsif (rising_edge (filter_clk)) then
    case (byte_count_sr) is
      when "001" =>
        o_y_overflow <= s_reg (7);
        o_x_overflow <= s_reg (6);
        o_y_sign <= s_reg (5);
        o_x_sign <= s_reg (4);
        o_button_middle <= s_reg (2);
        o_button_right <= s_reg (1);
        o_button_left <= s_reg (0);
      when "010" =>
        o_x_movement <= s_reg (7 downto 0);
      when others =>
        o_y_movement <= s_reg (7 downto 0);
    end case;
  end if;
end process p_byte_output;

-- Filtering PS2_Clk --- Clk runs at ~ 50 Mhz --- PS2_clk runs at ~ 20-30 KHz
p_filter_clk : process (i_clock, i_reset) is
begin
  if (i_reset = '1') then
    clk_low_filter <= (others => '0');
    clk_high_filter <= (others => '0');
    filter_clk <= '0';
  elsif (rising_edge (i_clock)) then
    if (i_PS2_Clk = '1') then
      clk_low_filter <= (others => '0');
      clk_high_filter <= clk_high_filter + 1;
      if (clk_high_filter = c_three) then
        filter_clk <= '1'; -- If PS2_Clk remains high for 7 CLK cycles, filter_clk transitions high
      end if;
    elsif (i_PS2_Clk = '0') then
      clk_high_filter <= (others => '0');
      clk_low_filter <= clk_low_filter + 1;
      if (clk_low_filter = c_three) then
        filter_clk <= '0'; -- If PS2_Clk remains low for 7 CLK cycles, filter_clk transitions low
      end if;
    end if;
  end if;
end process p_filter_clk;

p_scan_code : process (i_clock, i_reset) is
begin
  if (i_reset = '1') then
    clear_reg <= (others => '0');
    o_scan_ready <= '0';
    rx_parity <= '0';
    rx_parity_received <= '0';
  elsif (rising_edge (i_clock)) then
    if (trigger = '1' and i_do_read = '1' and filter_clk = '1') then
      rx_parity <= parityrom (to_integer (unsigned (s_reg (7 downto 0))));
      rx_parity_received <= s_reg (8);
      clear_reg <= (others => '0');
      o_scan_ready <= '1'; -- New scan code has been received
    else
      clear_reg <= clear_reg + 1; -- wait two clock cycles before clearing scan_ready
      if (clear_reg >= 2) then
        clear_reg <= (others => '0');
        o_scan_ready <= '0';
      end if;
    end if;
  end if;
end process p_scan_code;

p_scan_code_logic : process (filter_clk, i_reset) is
begin
  if (i_reset = '1') then
    bit_count <= (others => '0');
    scan_state <= idle;
    s_reg <= (others => '0');
    trigger <= '0';
    byte_count_sr <= "001";
  elsif (rising_edge (filter_clk)) then
    case (scan_state) is
      when idle => -- Waiting to receive data input from PS2 port
        s_reg <= (others => '0');
        bit_count <= (others => '0');
        trigger <= '0';
        if (i_PS2_Data = '0') then -- start bit received
          scan_state <= shifting; -- goto shifting state
        end if;
      when shifting => -- receiving data
        bit_count <= bit_count + 1; -- number of bits received incremented
        s_reg <= i_PS2_Data & s_reg (8 downto 1); -- PS2_Data bit shifeted into s_reg
        trigger <= '0';
        if (bit_count = c_eight) then -- complete key code recieved
          trigger <= '1';
        end if;
        if (bit_count >= c_nine) then -- stop bit recieved
          trigger <= '0';
          scan_state <= idle; -- goto idle state
          byte_count_sr <= byte_count_sr (1 downto 0) & byte_count_sr (2);
        end if;
    end case;
  end if;
end process p_scan_code_logic;

end architecture behavioral;
