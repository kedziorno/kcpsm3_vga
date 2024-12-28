----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12/28/2024
-- Design Name:
-- Module Name:    vga_ramb16_dp
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
library UNISIM;
use UNISIM.VComponents.all;

entity vga_ramb16_dp is
port (
i_reset       : in  std_logic;
-- CPU input
i_clock_cpu   : in  std_logic;
i_address_cpu : in  std_logic_vector (13 downto 0);
i_color_cpu   : in  std_logic_vector (5 downto 0);
i_write_cpu   : in  std_logic;
-- VGA output
i_clock_vga   : in  std_logic;
i_address_vga : in  std_logic_vector (13 downto 0);
o_color_vga   : out std_logic_vector (5 downto 0)
);
end entity vga_ramb16_dp;

architecture behavioral of vga_ramb16_dp is
-- direct connected to 6 blocks RAMB16 type
-- make 128 x 128 (16384) resolution with 6 bit color
begin

  g_RAMB16_S1_S1_inst : for i in 5 downto 0 generate
    RAMB16_S1_S1_inst : RAMB16_S1_S1 port map (
      -- CPU
      CLKA  => i_clock_cpu,     -- Port A Clock
      SSRA  => i_reset,         -- Port A Synchronous Set/Reset Input
      ENA   => '1',             -- Port A RAM Enable Input
      ADDRA => i_address_cpu,   -- Port A 14-bit Address Input
      DIA   => i_color_cpu (i), -- Port A 1-bit Data Input
      WEA   => i_write_cpu,     -- Port A Write Enable Input
      DOA   => '0',             -- Port A 1-bit Data Output
      -- VGA
      CLKB  => i_clock_vga,     -- Port B Clock
      SSRB  => i_reset,         -- Port B Synchronous Set/Reset Input
      ENB   => '1',             -- Port B RAM Enable Input
      ADDRB => i_address_vga,   -- Port B 14-bit Address Input
      DIB   => '0',             -- Port B 1-bit Data Input
      WEB   => '0',             -- Port B Write Enable Input
      DOB   => o_color_vga (i)  -- Port B 1-bit Data Output
    );
  end generate g_RAMB16_S1_S1_inst;

end architecture behavioral;
