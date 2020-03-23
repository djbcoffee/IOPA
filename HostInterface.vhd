---------------------------------------------------------------------------------
-- Copyright (C) 2019 Donald J. Bartley <djbcoffee@gmail.com>
--
-- This source file may be used and distributed without restriction provided that
-- this copyright statement is not removed from the file and that any derivative
-- work contains the original copyright notice and the associated disclaimer.
--
-- This source file is free software; you can redistribute it and/or modify it
-- under the terms of the GNU General Public License as published by the Free
-- Software Foundation; either version 2 of the License, or (at your option) any
-- later version.
--
-- This source file is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
-- details.
--
-- You should have received a copy of the GNU General Public License along with
-- this source file.  If not, see <http://www.gnu.org/licenses/> or write to the
-- Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
-- 02110-1301, USA.
---------------------------------------------------------------------------------
-- File: HostInterface.vhd
--
-- Description:
-- The interface to the host system.
---------------------------------------------------------------------------------
-- DJB 01/04/19 Created.
---------------------------------------------------------------------------------

library ieee;
library unisim;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use work.universal.all;

entity HostInterface is
	port 
	(
		CS, nCS, RnW : in std_logic;
		HostAddress : in std_logic_vector(2 downto 0);
		PortADataDirectionBus, PortAInputDataBus, PortAOutputDataBus, PortBDataDirectionBus, PortBInputDataBus, PortBOutputDataBus : in std_logic_vector(7 downto 0);
		WriteClock, PortADataDirectionRegClockEnable, PortAInputDataRegClock, PortAOutputDataRegClockEnable, PortBDataDirectionRegClockEnable, PortBInputDataRegClock, PortBOutputDataRegClockEnable : out std_logic;
		HostDataBus : out std_logic_vector(7 downto 0);
		HostDataPins : inout std_logic_vector(7 downto 0)
	);
end HostInterface;

architecture Behavioral of HostInterface is
	signal HostOutputEnable : std_logic;
	signal RippleZeroOut : std_logic;
	signal RippleOneOut : std_logic;
	signal RippleTwoOut : std_logic;
	
	signal HostOutputData : std_logic_vector(7 downto 0);
	
	-- We want to make sure that these signals are not optimized out.
	attribute keep : string;
	attribute keep of RippleZeroOut : signal is "TRUE";
	attribute keep of RippleOneOut : signal is "TRUE";
	attribute keep of RippleTwoOut : signal is "TRUE";
begin
	-- Uses primitives for the output and input buffers that are specific to the
	-- XC9500XL series CPLD.  The output buffer uses the active low enable.
	DataBusOutBufferBit0 : OBUFT
		generic map (SLEW => "FAST")
		port map (O => HostDataPins(0), I => HostOutputData(0), T => HostOutputEnable);
	DataBusOutBufferBit1 : OBUFT
		generic map (SLEW => "FAST")
		port map (O => HostDataPins(1), I => HostOutputData(1), T => HostOutputEnable);
	DataBusOutBufferBit2 : OBUFT
		generic map (SLEW => "FAST")
		port map (O => HostDataPins(2), I => HostOutputData(2), T => HostOutputEnable);
	DataBusOutBufferBit3 : OBUFT
		generic map (SLEW => "FAST")
		port map (O => HostDataPins(3), I => HostOutputData(3), T => HostOutputEnable);
	DataBusOutBufferBit4 : OBUFT
		generic map (SLEW => "FAST")
		port map (O => HostDataPins(4), I => HostOutputData(4), T => HostOutputEnable);
	DataBusOutBufferBit5 : OBUFT
		generic map (SLEW => "FAST")
		port map (O => HostDataPins(5), I => HostOutputData(5), T => HostOutputEnable);
	DataBusOutBufferBit6 : OBUFT
		generic map (SLEW => "FAST")
		port map (O => HostDataPins(6), I => HostOutputData(6), T => HostOutputEnable);
	DataBusOutBufferBit7 : OBUFT
		generic map (SLEW => "FAST")
		port map (O => HostDataPins(7), I => HostOutputData(7), T => HostOutputEnable);
		
	DataBusInBufferBit0 : IBUF
		port map (O => HostDataBus(0), I => HostDataPins(0));
	DataBusInBufferBit1 : IBUF
		port map (O => HostDataBus(1), I => HostDataPins(1));
	DataBusInBufferBit2 : IBUF
		port map (O => HostDataBus(2), I => HostDataPins(2));
	DataBusInBufferBit3 : IBUF
		port map (O => HostDataBus(3), I => HostDataPins(3));
	DataBusInBufferBit4 : IBUF
		port map (O => HostDataBus(4), I => HostDataPins(4));
	DataBusInBufferBit5 : IBUF
		port map (O => HostDataBus(5), I => HostDataPins(5));
	DataBusInBufferBit6 : IBUF
		port map (O => HostDataBus(6), I => HostDataPins(6));
	DataBusInBufferBit7 : IBUF
		port map (O => HostDataBus(7), I => HostDataPins(7));

	-- Uses primitive that is specific to the XC9500XL series CPLD.  This register
	-- will be the first register in the ripple clock circuit.  Even though a
	-- register is not needed, as there is no clock and data and this could be
	-- replaced with combinatorial logic, we want to use a register so that timing
	-- is maintained through-out the ripple circuit.  Specifically in regards to
	-- register async S/R recover before clock (Symbol TRAI).
	RippleRegister0 : FDCPE
		generic map (INIT => '0')
		port map (Q => RippleZeroOut, C => '0', CE => '0', CLR => RnW, D => '0', PRE => not RnW);

	HostSystemInterface : process (CS, nCS, RnW, HostAddress, PortADataDirectionBus, PortAInputDataBus, PortAOutputDataBus, PortBDataDirectionBus, PortBInputDataBus, PortBOutputDataBus, RippleZeroOut, RippleOneOut, RippleTwoOut) is
		variable rippleRegister : std_logic_vector(3 downto 1) := (others => '0');
	begin
		-- Do the ripple clock circuit.  This is a circuit consisting of four
		-- registers with the preceeding register feeding its output to the clock
		-- of the next register with all registers being cleared async through the
		-- RnW line.  This chip works asynchronously and doesn't have a clock.
		-- This circuit will reject small glitches on the RnW line so that an
		-- accidental write will not be performed.  RnW signal must be low long
		-- enough to get through all the propogation delays of the four registers.
		-- The data out of the last register in the chain becomes the write clock
		-- for all the registers.
		if RnW = '1' then
			rippleRegister(3 downto 1) := (others => '0');
		elsif RnW = '0' then
			if RippleZeroOut'event and RippleZeroOut = '1' then
				rippleRegister(1) := '1';
			end if;
			
			if RippleOneOut'event and RippleOneOut = '1' then
				rippleRegister(2) := '1';
			end if;
			
			if RippleTwoOut'event and RippleTwoOut = '1' then
				rippleRegister(3) := '1';
			end if;
		else
			rippleRegister := rippleRegister;
		end if;
		
		-- Setup what data is to be outputted based on the address.  The data won't
		-- actually be seen on the host data bus until the chip is selected for a
		-- read.
		if HostAddress = PORTA_DDR_ADDRESS then
			HostOutputData <= PortADataDirectionBus;
		elsif HostAddress = PORTA_IDR_ADDRESS then
			HostOutputData <= PortAInputDataBus;
		elsif HostAddress = PORTA_ODR_ADDRESS then
			HostOutputData <= PortAOutputDataBus;
		elsif HostAddress = PORTB_DDR_ADDRESS then
			HostOutputData <= PortBDataDirectionBus;
		elsif HostAddress = PORTB_IDR_ADDRESS then
			HostOutputData <= PortBInputDataBus;
		elsif HostAddress = PORTB_ODR_ADDRESS then
			HostOutputData <= PortBOutputDataBus;
		else
			HostOutputData <= (others => '0');
		end if;
		
		-- If the chip is selected for a read operation then turn on the output
		-- driver and output the requested data.
		if CS = '1' and nCS = '0' and RnW = '1'then
			HostOutputEnable <= '0';
		else
			HostOutputEnable <= '1';
		end if;
		
		-- Internal module signals:
		-- The data out from ripple register one.
		RippleOneOut <= rippleRegister(1);
		
		-- The data out from ripple register two.
		RippleTwoOut <= rippleRegister(2);
		
		-- External module signals:
		-- The data out from ripple register three which is the last register in
		-- the ripple clock circuit.  This signals becomes the clock for all
		-- register writes.
		WriteClock <= rippleRegister(3);

		-- The PortADataDirectionRegClockEnable signal is used in the
		-- DataDirectionRegisters.vhd module as a clock enable.  When the chip is
		-- selected with the PORTA_DDR_ADDRESS address and the R/nW signal
		-- transistions from low to high the data on the host data bus will be
		-- latched into the register.
		if CS = '1' and nCS = '0' and HostAddress = PORTA_DDR_ADDRESS then
			PortADataDirectionRegClockEnable <= '1';
		else
			PortADataDirectionRegClockEnable <= '0';
		end if;
		
		-- The PortAInputDataRegClock signal is a clock used in the
		-- InputDataRegister.vhd module.  Normally, generating a clock this way
		-- isn't best practice as it leads to a gated asynchronous clock but this
		-- entire chip operates asynchronously and doesn't have a dedicated clock.
		-- The input data register switching asynchronously to all other registers
		-- shouldn't cause any issues as the output of the input data regsiters
		-- doesn't logically connect to any of the other registers and is only
		-- outputted on the host data bus during a read.  The input data register
		-- will be clocked when the chip is selected for a read with the
		-- PORTA_IDR_ADDRESS address.
		if CS = '1' and nCS = '0' and HostAddress = PORTA_IDR_ADDRESS then
			PortAInputDataRegClock <= '1';
		else
			PortAInputDataRegClock <= '0';
		end if;
		
		-- The PortAOutputDataRegClockEnable signal is used in the
		-- OutputDataRegister.vhd module as a clock enable.  When the chip is
		-- selected with the PORTA_ODR_ADDRESS address and the R/nW signal
		-- transistions from low to high the data on the host data bus will be
		-- latched into the register.
		if CS = '1' and nCS = '0' and HostAddress = PORTA_ODR_ADDRESS then
			PortAOutputDataRegClockEnable <= '1';
		else
			PortAOutputDataRegClockEnable <= '0';
		end if;
		
		-- The PortBDataDirectionRegClockEnable signal is used in the
		-- DataDirectionRegisters.vhd module as a clock enable.  When the chip is
		-- selected with the PORTB_DDR_ADDRESS address and the R/nW signal
		-- transistions from low to high the data on the host data bus will be
		-- latched into the register.
		if CS = '1' and nCS = '0' and HostAddress = PORTB_DDR_ADDRESS then
			PortBDataDirectionRegClockEnable <= '1';
		else
			PortBDataDirectionRegClockEnable <= '0';
		end if;
		
		-- The PortBInputDataRegClock signal is a clock used in the
		-- InputDataRegister.vhd module.  Normally, generating a clock this way
		-- isn't best practice as it leads to a gated asynchronous clock but this
		-- entire chip operates asynchronously and doesn't have a dedicated clock.
		-- The input data register switching asynchronously to all other registers
		-- shouldn't cause any issues as the output of the input data regsiters
		-- doesn't logically connect to any of the other registers and is only
		-- outputted on the host data bus during a read.  The input data register
		-- will be clocked when the chip is selected for a read with the
		-- PORTB_IDR_ADDRESS address.
		if CS = '1' and nCS = '0' and HostAddress = PORTB_IDR_ADDRESS then
			PortBInputDataRegClock <= '1';
		else
			PortBInputDataRegClock <= '0';
		end if;
	
		-- The PortBOutputDataRegClockEnable signal is used in the
		-- OutputDataRegister.vhd module as a clock enable.  When the chip is
		-- selected with the PORTB_ODR_ADDRESS address and the R/nW signal
		-- transistions from low to high the data on the host data bus will be
		-- latched into the register.
		if CS = '1' and nCS = '0' and HostAddress = PORTB_ODR_ADDRESS then
			PortBOutputDataRegClockEnable <= '1';
		else
			PortBOutputDataRegClockEnable <= '0';
		end if;
	end process HostSystemInterface;
end architecture Behavioral;
