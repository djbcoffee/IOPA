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
-- File: PortA.vhd
--
-- Description:
-- Describes the architecture structure of port B.
---------------------------------------------------------------------------------
-- DJB 01/04/19 Created.
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity PortB is
	port
	(
		Clock, DataDirectionRegClockEnable, InputDataRegClock, OutputDataRegClockEnable : in std_logic;
		HostDataBus : in std_logic_vector(7 downto 0);
		InputDataBus, OutputDataBus : out std_logic_vector(7 downto 0);
		DataDirectionBus, DataPins : inout std_logic_vector(7 downto 0)
	);
end PortB;

architecture Struct of PortB is
	signal DataPinsBus : std_logic_vector(7 downto 0);
begin
	PortBDataDirectionRegister : entity work.DataDirectionRegister(Behavioral)
		port map (Clock, DataDirectionRegClockEnable, HostDataBus, DataDirectionBus);
	PortBInputDataRegister : entity work.InputDataRegister(Behavioral)
		port map (InputDataRegClock, DataPinsBus, InputDataBus);
	PortBOutputDataRegister : entity work.OutputDataRegister(Behavioral)
		port map (Clock, OutputDataRegClockEnable, HostDataBus, DataDirectionBus, DataPinsBus, OutputDataBus, DataPins);
end architecture Struct;
