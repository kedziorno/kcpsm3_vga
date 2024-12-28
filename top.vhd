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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
port (
i_clock  : in  std_logic;
i_reset  : in  std_logic;
o_hsync  : out std_logic;
o_vsync  : out std_logic;
o_blank  : out std_logic;
o_r      : out std_logic_vector (1 downto 0);
o_g      : out std_logic_vector (1 downto 0);
o_b      : out std_logic_vector (1 downto 0)
);
end top;

architecture behavioral of top is

component vga_timing is
port (
i_clock : in  std_logic;
i_reset : in  std_logic;
o_hsync : out std_logic;
o_vsync : out std_logic;
o_blank : out std_logic
);
end component vga_timing;

component vga_rgb is
port (
i_color  : in  std_logic_vector (5 downto 0);
i_blank  : in  std_logic;
o_r      : out std_logic_vector (1 downto 0);
o_g      : out std_logic_vector (1 downto 0);
o_b      : out std_logic_vector (1 downto 0)
);
end component vga_rgb;

COMPONENT ipcore_vga_ramb16_dp
PORT (
clka  : IN  STD_LOGIC;
wea   : IN  STD_LOGIC_VECTOR (0 DOWNTO 0);
addra : IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
dina  : IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
clkb  : IN  STD_LOGIC;
addrb : IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
doutb : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
);
END COMPONENT ipcore_vga_ramb16_dp;

signal vga_blank : std_logic;
signal vga_color : std_logic_vector (5 downto 0);

begin

o_blank <= vga_blank;

inst_vga_timing : vga_timing
port map (
i_clock => i_clock,
i_reset => i_reset,
o_hsync => o_hsync,
o_vsync => o_vsync,
o_blank => vga_blank
);

inst_vga_rgb : vga_rgb
port map (
i_color => vga_color,
i_blank => vga_blank,
o_r => o_r,
o_g => o_g,
o_b => o_b
);

inst_ipcore_vga_ramb16_dp : ipcore_vga_ramb16_dp
port map (
clka  => clka,
wea   => wea,
addra => addra,
dina  => dina,
clkb  => clkb,
addrb => addrb,
doutb => doutb
);

end architecture behavioral;
