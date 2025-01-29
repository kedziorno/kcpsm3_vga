----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    01/05/2025
-- Design Name:
-- Module Name:    cpu_io_registers_decoder
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
--   - Coordinations is stored at absolute addresses (0 - 19199) :
--      - 0x16 - X (rows) , 0 - 159 / use 8bit.
--      - 0x17 - Y (cols) , 0 - 119 / use 7bit, expect first MSB.
--   - Colors have index 0 - 63 at address 0x20.
--   - After concatenation to YYYYYYYXXXXXXXX format (15 bit)
--       decoder make address (coordination), data (color) and write (boolean)
--       signals for access to dual-port memory (A)
--       where pixels with color is stored.
-- Attempt to used timers and interrupts with helper code based from BGEBP1
--   http://dk.bg-elektronik.dk/fpga/
-- ======================================================
--    SPECIAL FUNCTION REGISTER:
-- ======================================================
--  Symbol: Name: Address:
--  IEN0  Interrupt enable register 0 HEX 0C
--  IEN1  Interrupt enable register 1 HEX 0D
--  ISC0  Interrupt service control register  HEX 0E
--  TCON  Timer service control register  HEX 0F
--  TC0   Timer Count 0 HEX 10
--  TCL1  Timer Count Low 1 HEX 11
--  TCH1  Timer Count High 1 HEX 12
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

use work.p_package1.all;

entity kcpsm3_io_registers_decoder is
port (
i_clock, i_reset       : in  std_logic;
i_kcpsm3_port_id       : in  std_logic_vector (7 downto 0);
i_kcpsm3_out_port      : in  std_logic_vector (7 downto 0);
o_kcpsm3_in_port       : out std_logic_vector (7 downto 0);
i_kcpsm3_write_strobe  : in  std_logic;
i_kcpsm3_read_strobe   : in  std_logic;
o_kcpsm3_interrupt     : out std_logic;
i_kcpsm3_interrupt_ack : in  std_logic;
o_pixel_coordination   : out std_logic_vector (c_memory_address_bits - 1 downto 0);
o_pixel_color          : out std_logic_vector (c_color_bits - 1 downto 0);
o_pixel_write          : out std_logic_vector (0 downto 0);
TR0_timer              : inout std_logic := '0';
TF0_timer              : in std_logic := '0';
TC0_timer              : out unsigned (7 downto 0) := (others => '0');
TR1_timer              : inout std_logic := '0';
TF1_timer              : in std_logic := '0';
TC1_timer              : out unsigned (15 downto 0) := (others => '0');	
-- o_testX not used in synthesis
o_test8                : out std_logic_vector (7 downto 0);
o_test7                : out std_logic_vector (7 downto 0);
o_test6                : out std_logic_vector (7 downto 0);
o_test5                : out std_logic_vector (7 downto 0);
o_test4                : out std_logic_vector (7 downto 0);
o_test3                : out std_logic_vector (7 downto 0);
o_test2                : out std_logic_vector (7 downto 0);
o_test1                : out std_logic_vector (7 downto 0);
o_test0                : out std_logic_vector (7 downto 0)
);
end entity kcpsm3_io_registers_decoder;

architecture behavioral of kcpsm3_io_registers_decoder is

signal Data_in_io, Data_out_io, ID_io : std_logic_vector (7 downto 0) := (others => '0');
signal WE_io, RE_io : std_logic := '0';
signal Interrupt_io, Interrupt_ack_io : std_logic  := '0';

-- IEN0 - Interrupt Enables 0 Variables
signal EA_int : std_logic := '0';
signal ET1_int : std_logic := '0';
signal ET0_int : std_logic := '0';
signal EX2_int : std_logic := '0';
signal EX1_int : std_logic := '0';
signal EX0_int : std_logic := '0';
Signal ES0_int : std_logic := '0';
signal IC0_int : std_logic := '0';
signal IS0_int : std_logic := '0';
signal IT2_int : std_logic := '0';
signal IT1_int : std_logic := '0';
signal IT0_int : std_logic := '0';
signal IX2_int : std_logic := '0';
signal IX1_int : std_logic := '0';
signal IX0_int : std_logic := '0';
-- Interrupt Variables
signal X0_int : std_logic := '1';
signal X1_int : std_logic := '1';
signal X2_int : std_logic := '1';

begin

  Data_in_io <= i_kcpsm3_out_port;
  o_kcpsm3_in_port <= Data_out_io;
  WE_io <= i_kcpsm3_write_strobe;
  RE_io <= i_kcpsm3_read_strobe;
  Interrupt_ack_io <= i_kcpsm3_interrupt_ack;
  o_kcpsm3_interrupt <= Interrupt_io;
  ID_io <= i_kcpsm3_port_id;

-------------------------------------------------------------------------------
--  This program function support the Timer option via the SFR TCON there 
--  start/stop timer to run and the reading flag function for timer interrupt. 
--  The supports also the reload value for Timer 0 and Timer 2.
-------------------------------------------------------------------------------
--  TIMER SERVICE CONTROL - SFR TCON, HEX 0F
--  -------------------------------------------------
--  |  X  |  X  | TF2 | TR2 | TF1 | TR1 | TF0 | TR0 |
--  -------------------------------------------------
-------------------------------------------------------------------------------
--  INTERRUPT SYSTEM:
--  This program handle the Interrupt System there use the three register
--  named IEN0 - Interrupt Enable 0, IEN1 - Interrupt Enable 2 and ISC0 -
--  Interrupt Service Control. Activate with help of the SFR, the IEN0
--  and IEN1 enables the interrupt and the ISC0 show the status for the
--  interrupts.
-------------------------------------------------------------------------------
--  INTERRUPT ENABLES - SFR IEN0, HEX 0C
--  -------------------------------------------------
--  | EA  | WDT | ET2 | ET1 | ET0 | EX2 | EX1 | EX0 |
--  -------------------------------------------------
--  INTERRUPT ENABLES - SFR IEN1, HEX 0D 
--  -------------------------------------------------
--  |  X  |  X  |  X  |  X  |  X  |  X  | EC0 | ES0 |
--  -------------------------------------------------
--  INTERRUPT SERVICE CONTROL - SFR ISC0, HEX 0E
--  -------------------------------------------------
--  | IC0 | IS0 | IT2 | IT1 | IT0 | IX2 | IX1 | IX0 |
--  -------------------------------------------------

  p_io_registers_decoder_timer_interrupts : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
    elsif (rising_edge (i_clock)) then
      if (WE_io = '1' and ID_io = c_ien0) then
        EA_int <= Data_in_io (7); -- Activate or deactivate all Interrupts EA
        --WDT_int <= Data_in_io (6); -- Activate or deactivate WDT
        --ET2_int <= Data_in_io (5); -- Activate or deactivate Interrupts Timer 2
        ET1_int <= Data_in_io (4); -- Activate or deactivate Interrupts Timer 1
        ET0_int <= Data_in_io (3); -- Activate or deactivate Interrupts Timer 0
        EX2_int <= Data_in_io (2); -- Activate or deactivate External Interrupt 2
        EX1_int <= Data_in_io (1); -- Activate or deactivate External Interrupt 1
        EX0_int <= Data_in_io (0); -- Activate or deactivate External Interrupt 0
      elsif (WE_io = '1' and ID_io = c_ien1) then
        --EC0_int <= Data_in_io (1); -- Activate or deactivate CAN-BUS Interrupt
        ES0_int <= Data_in_io (0); -- Activate or deactivate Serial Interrupt
      elsif (WE_io = '1' and ID_io = c_isc) then
        IC0_int <= Data_in_io (7); -- Clear Interrupt FLAG for CAN-BUS
        IS0_int <= Data_in_io (6); -- Clear Interrupt FLAG for Serial
        IT2_int <= Data_in_io (5); -- Clear Interrupt FLAG for Timer 2
        IT1_int <= Data_in_io (4); -- Clear Interrupt FLAG for Timer 1
        IT0_int <= Data_in_io (3); -- Clear Interrupt FLAG for Timer 0
        IX2_int <= Data_in_io (2); -- Clear Interrupt FLAG for External 2
        IX1_int <= Data_in_io (1); -- Clear Interrupt FLAG for External 1
        IX0_int <= Data_in_io (0); -- Clear Interrupt FLAG for External 0
      elsif (RE_io = '1' and ID_io = c_isc) then
        Data_out_io <= (IC0_int & IS0_int & IT2_int & IT1_int & IT0_int & IX2_int & IX1_int & IX0_int);
      -- External Interrupt Service Routine
      elsif (EX0_int = '1' and IX0_int = '0' and X0_int = '1' and EA_int = '1') then
        IX0_int <= '1'; -- Set Interrupt FLAG
        Interrupt_io <= '1'; -- Send Interrupt to PicoBlaze
      elsif (EX1_int = '1' and IX1_int = '0' and X1_int = '1' and EA_int = '1') then
        IX1_int <= '1'; -- Set Interrupt FLAG
        Interrupt_io <= '1'; -- Send Interrupt to PicoBlaze
      elsif (EX2_int = '1' and IX2_int = '0' and X2_int = '1' and EA_int = '1') then
        IX2_int <= '1'; -- Set Interrupt FLAG
        Interrupt_io <= '1'; -- Send Interrupt to PicoBlaze
      elsif (WE_io  = '1' and ID_io = c_tcon) then -- Write to TCON register
        -- for Start/Stop
        TR0_timer <= Data_in_io (0); -- Start timer 0 with set a '1'
        TR1_timer <= Data_in_io (2); -- Start timer 1 with set a '1'
      elsif (RE_io  = '1' and ID_io = c_tcon) then -- Read status flag and which timer
        -- there are on!
        Data_out_io <= ("0000" & TF1_timer & TR1_timer & TF0_timer & TR0_timer);
      -- Timer Count 0 - TC0, HEX 10
      elsif (WE_io = '1' and ID_io = c_tc0) then -- Reload new value to timer 0
        TC0_timer <= unsigned (Data_in_io);
      -- Timer Count 1 - TCL1, HEX 11 and TCH1 HEX 12
      elsif (WE_io = '1' and ID_io = c_tcl1) then -- Reload new value to Timer 2
        TC1_timer (7 DOWNTO 0) <= unsigned (Data_in_io); -- Set the low byte
      elsif (WE_io  = '1' and ID_io = c_tch1) then
        TC1_timer (15 DOWNTO 8) <= unsigned (Data_in_io); -- Set the high byte
      -- Timer Interrupt Service Routine
      elsif (ET0_int = '1' and TF0_timer = '1' and IT0_int = '0' and EA_int = '1') then
        IT0_int <= '1'; -- Set Timer 0 Interrupt FLAG
        Interrupt_io <= '1'; -- Send Interrupt to PicoBlaze
      elsif (ET1_int = '1' and TF1_timer = '1' and IT1_int = '0' and EA_int = '1') then
        IT1_int <= '1'; -- Set Timer 1 Interrupt FLAG
        Interrupt_io <= '1'; -- Send Interrupt to PicoBlaze
      -- Relase Interrupt
      elsif (Interrupt_ack_io = '1') then -- When Interrupt ACK is active
        Interrupt_io <= '0'; -- Set global Interrupt to zero
      end if;
    end if;
  end process p_io_registers_decoder_timer_interrupts;

--  p_io_registers_decoder_vga : process (i_clock, i_reset) is
--    variable x_coordination : integer range 0 to c_x - 1; -- 7 bit
--    variable y_coordination : integer range 0 to c_y * c_x - 1; -- 6 bit
--  begin
--    if (i_reset = '1') then
--      o_pixel_write        <= "0";
--      o_pixel_coordination <= (others => '0');
--      o_pixel_color        <= (others => '0');
--      --synthesis translate_off
----      report "c_x : " & integer'image (c_x);
----      report "c_y : " & integer'image (c_y);
--      --synthesis translate_on
--    elsif (rising_edge (i_clock)) then
--      case (i_kcpsm3_port_id) is
--        when c_kcpsm3_pixel_address_low => -- x coordination pixel 7 bit (0 to 159)
--          if (i_kcpsm3_write_strobe = '1') then
--            o_pixel_write <= "0";
--            x_coordination :=
--              to_integer (unsigned (i_kcpsm3_out_port (7 downto 0)));
--            --synthesis translate_off
----            report "x_coordination : " & integer'image (x_coordination);
--            --synthesis translate_on
--          end if;
--        when c_kcpsm3_pixel_address_high => -- y coordination pixel 6 bit (0 to 119)
--          if (i_kcpsm3_write_strobe = '1') then
--            o_pixel_write <= "0";
--            y_coordination :=
--              to_integer (unsigned (i_kcpsm3_out_port (6 downto 0))) * c_x;
--            --synthesis translate_off
----            report "y_coordination : " & integer'image (y_coordination);
--            --synthesis translate_on
--          end if;
--        when c_kcpsm3_pixel_address_color => -- color pixel (0 to 63)
--          if (i_kcpsm3_write_strobe = '1') then
--            o_pixel_write <= "1";
--            o_pixel_coordination <= std_logic_vector (to_unsigned (y_coordination + x_coordination, c_memory_address_bits));
--            --synthesis translate_off
----            report "o_pixel_coordination : " & integer'image (y_coordination + x_coordination);
--            --synthesis translate_on
--            o_pixel_color <=
--              i_kcpsm3_out_port (c_color_bits - 1 downto 0);
--          end if;
--        when others =>
--          o_pixel_write        <= "0";
--          o_pixel_coordination <= (others => '0');
--          o_pixel_color        <= (others => '0');
--      end case;
--    end if;
--  end process p_io_registers_decoder_vga;

--synthesis translate_off
  p_io_registers_decoder_debug : process (i_clock, i_reset) is
  begin
    if (i_reset = '1') then
      o_test0 <= (others => '0');
      o_test1 <= (others => '0');
      o_test2 <= (others => '0');
      o_test3 <= (others => '0');
      o_test4 <= (others => '0');
      o_test5 <= (others => '0');
      o_test6 <= (others => '0');
      o_test7 <= (others => '0');
      o_test8 <= (others => '0');
    elsif (rising_edge (i_clock)) then
      case (i_kcpsm3_port_id) is
        when x"01" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test1 <= i_kcpsm3_out_port;
          end if;
        when x"02" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test2 <= i_kcpsm3_out_port;
          end if;
        when x"03" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test3 <= i_kcpsm3_out_port;
          end if;
        when x"04" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test4 <= i_kcpsm3_out_port;
          end if;
        when x"05" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test5 <= i_kcpsm3_out_port;
          end if;
        when x"06" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test6 <= i_kcpsm3_out_port;
          end if;
        when x"07" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test7 <= i_kcpsm3_out_port;
          end if;
        when x"08" =>
          if (i_kcpsm3_write_strobe = '1') then
            o_test8 <= i_kcpsm3_out_port;
          end if;
        when others =>
          o_test0 <= (others => '0');
          o_test1 <= (others => '0');
          o_test2 <= (others => '0');
          o_test3 <= (others => '0');
          o_test4 <= (others => '0');
          o_test5 <= (others => '0');
          o_test6 <= (others => '0');
          o_test7 <= (others => '0');
          o_test8 <= (others => '0');
      end case;
    end if;
  end process p_io_registers_decoder_debug;
--synthesis translate_on

end architecture behavioral;
