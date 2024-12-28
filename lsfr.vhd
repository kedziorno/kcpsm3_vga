----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12/28/2024
-- Design Name:
-- Module Name:    lsfr
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

entity lsfr is
port (
i_clock, i_reset : in std_logic;
o_lsfr : out std_logic_vector (2 downto 0)
);
end entity lsfr;

architecture behavioral of lsfr is

  signal lsfr : std_logic_vector (2 downto 0);

begin

  o_lsfr <= lsfr;

  p_lsfr : process (i_clock, i_reset) is
    variable reg : std_logic;
  begin
    if (i_reset = '1') then
      lsfr <= "000";
      reg := '1';
    elsif (rising_edge (i_clock)) then
      lsfr <= lsfr (1 downto 0) & reg;
      reg := lsfr (2) xor lsfr (1);
    end if;
  end process p_lsfr;

end architecture behavioral;
