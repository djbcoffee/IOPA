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
-- File: DataDirectionRegister.vhd
--
-- Description:
-- Holds the value for each output driver enable of the OutputDataRegister.vhd
-- module.
---------------------------------------------------------------------------------
-- DJB 01/04/19 Created.
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity DataDirectionRegister is
	port
	(
		Clock, ClockEnable : in std_logic;
		HostDataBus : in std_logic_vector(7 downto 0);
		DataDirectionBus : out std_logic_vector(7 downto 0)
	);
end DataDirectionRegister;

architecture Behavioral of DataDirectionRegister is
begin
	DataDirectionRegisterOperation : process (Clock) is
		variable dataDirRegister : std_logic_vector(7 downto 0) := (others => '0');
	begin
		-- On every rising edge of the clock check if we are enabled for a write.
		if Clock'event and Clock = '1' then
			if ClockEnable = '1' then
				-- We are enabled for a write.  Write the data on the data bus into
				-- the register.
				dataDirRegister := HostDataBus;
			else
				dataDirRegister := dataDirRegister;
			end if;
		end if;
		
		-- Put the data in the data direction register onto the internal bus for
		-- other modules to use.
		DataDirectionBus <= dataDirRegister;
	end process DataDirectionRegisterOperation;
end Behavioral;
