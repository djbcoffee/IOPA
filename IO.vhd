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
-- File: IO.vhd
--
-- Description:
-- The internal structure of the input/output interface adapter in a Xilinx
-- XC9572XL-10VQG44 CPLD.
---------------------------------------------------------------------------------
-- DJB 01/04/19 Created.
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity IO is
	port
	(
		CS, nCS, RnW : in std_logic;
		HostAddress : in std_logic_vector(2 downto 0);
		HostDataPins, PortADataPins, PortBDataPins : inout std_logic_vector(7 downto 0)
	);
end IO;

architecture Struct of IO is
	signal WriteClock : std_logic;
	signal PortADataDirectionRegClockEnable : std_logic;
	signal PortAInputDataRegClock : std_logic;
	signal PortAOutputDataRegClockEnable : std_logic;
	signal PortBDataDirectionRegClockEnable : std_logic;
	signal PortBInputDataRegClock : std_logic;
	signal PortBOutputDataRegClockEnable : std_logic;
	
	signal HostDataBus : std_logic_vector(7 downto 0);
	signal PortADataDirectionBus : std_logic_vector(7 downto 0);
	signal PortAInputDataBus : std_logic_vector(7 downto 0);
	signal PortAOutputDataBus : std_logic_vector(7 downto 0);
	signal PortBDataDirectionBus : std_logic_vector(7 downto 0);
	signal PortBInputDataBus : std_logic_vector(7 downto 0);
	signal PortBOutputDataBus : std_logic_vector(7 downto 0);
begin
	PortA : entity work.PortA(Struct)
		port map (WriteClock, PortADataDirectionRegClockEnable, PortAInputDataRegClock, PortAOutputDataRegClockEnable, HostDataBus, PortAInputDataBus, PortAOutputDataBus, PortADataDirectionBus, PortADataPins);
	PortB : entity work.PortB(Struct)
		port map (WriteClock, PortBDataDirectionRegClockEnable, PortBInputDataRegClock, PortBOutputDataRegClockEnable, HostDataBus, PortBInputDataBus, PortBOutputDataBus, PortBDataDirectionBus, PortBDataPins);
	HostInterface : entity work.HostInterface(Behavioral)
		port map (CS, nCS, RnW, HostAddress, PortADataDirectionBus, PortAInputDataBus, PortAOutputDataBus, PortBDataDirectionBus, PortBInputDataBus, PortBOutputDataBus, WriteClock, PortADataDirectionRegClockEnable, PortAInputDataRegClock, PortAOutputDataRegClockEnable, PortBDataDirectionRegClockEnable, PortBInputDataRegClock, PortBOutputDataRegClockEnable, HostDataBus, HostDataPins);
end architecture Struct;
