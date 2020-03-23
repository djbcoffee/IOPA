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
-- File: OutputDataRegister.vhd
--
-- Description:
-- Holds data that is to be outputted and pins setup as outputs.
---------------------------------------------------------------------------------
-- DJB 01/04/19 Created.
---------------------------------------------------------------------------------

library ieee;
library unisim;
use ieee.std_logic_1164.all;
use unisim.vcomponents.all;

entity OutputDataRegister is
	port
	(
		Clock, ClockEnable : in std_logic;
		HostDataBus, OutputBufferEnableBus : in std_logic_vector(7 downto 0);
		DataPinsBus, OutputDataBus : out std_logic_vector(7 downto 0);
		DataPins : inout std_logic_vector(7 downto 0)
	);
end OutputDataRegister;

architecture Behavioral of OutputDataRegister is
	signal OutputDataBusInternal : std_logic_vector(7 downto 0);
begin
	-- Uses primitives for the output and input buffers that are specific to the
	-- XC9500XL series CPLD.  The output buffer uses the active high enable.
	DataOutBufferBit0 : OBUFE
		port map (O => DataPins(0), I => OutputDataBusInternal(0), E => OutputBufferEnableBus(0));
	DataOutBufferBit1 : OBUFE
		port map (O => DataPins(1), I => OutputDataBusInternal(1), E => OutputBufferEnableBus(1));
	DataOutBufferBit2 : OBUFE
		port map (O => DataPins(2), I => OutputDataBusInternal(2), E => OutputBufferEnableBus(2));
	DataOutBufferBit3 : OBUFE
		port map (O => DataPins(3), I => OutputDataBusInternal(3), E => OutputBufferEnableBus(3));
	DataOutBufferBit4 : OBUFE
		port map (O => DataPins(4), I => OutputDataBusInternal(4), E => OutputBufferEnableBus(4));
	DataOutBufferBit5 : OBUFE
		port map (O => DataPins(5), I => OutputDataBusInternal(5), E => OutputBufferEnableBus(5));
	DataOutBufferBit6 : OBUFE
		port map (O => DataPins(6), I => OutputDataBusInternal(6), E => OutputBufferEnableBus(6));
	DataOutBufferBit7 : OBUFE
		port map (O => DataPins(7), I => OutputDataBusInternal(7), E => OutputBufferEnableBus(7));
		
	DataInBufferBit0 : IBUF
		port map (O => DataPinsBus(0), I => DataPins(0));
	DataInBufferBit1 : IBUF
		port map (O => DataPinsBus(1), I => DataPins(1));
	DataInBufferBit2 : IBUF
		port map (O => DataPinsBus(2), I => DataPins(2));
	DataInBufferBit3 : IBUF
		port map (O => DataPinsBus(3), I => DataPins(3));
	DataInBufferBit4 : IBUF
		port map (O => DataPinsBus(4), I => DataPins(4));
	DataInBufferBit5 : IBUF
		port map (O => DataPinsBus(5), I => DataPins(5));
	DataInBufferBit6 : IBUF
		port map (O => DataPinsBus(6), I => DataPins(6));
	DataInBufferBit7 : IBUF
		port map (O => DataPinsBus(7), I => DataPins(7));

	OutputDataRegisterOperation : process (Clock) is
		variable outDataRegister : std_logic_vector(7 downto 0) := (others => '0');
	begin
		-- On every rising edge of the clock check if we are enabled for a write
		if Clock'event and Clock = '1' then
			if ClockEnable = '1' then
				-- We are enabled for a write.  Write the data on the data bus into
				-- the register.
				outDataRegister := HostDataBus;
			else
				outDataRegister := outDataRegister;
			end if;
		end if;
		
		-- Put the data in the output data register onto the inputs of the output
		-- buffer drivers and the internal bus for other modules to use.
		OutputDataBusInternal <= outDataRegister;
		OutputDataBus <= outDataRegister;
	end process OutputDataRegisterOperation;
end Behavioral;
