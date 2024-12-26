----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12/25/2024 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
port (
i_clock : in std_logic;
i_reset : in std_logic;
o_hsync : out std_logic;
o_vsync : out std_logic;
o_blank : out std_logic
);
end top;

architecture behavioral of top is

component vga is
port (
i_clock : in std_logic;
i_reset : in std_logic;
o_hsync : out std_logic;
o_vsync : out std_logic;
o_blank : out std_logic
);
end component vga;

begin

inst_vga : vga
port map (
i_clock => i_clock,
i_reset => i_reset,
o_hsync => o_hsync,
o_vsync => o_vsync,
o_blank => o_blank
);

end architecture behavioral;
