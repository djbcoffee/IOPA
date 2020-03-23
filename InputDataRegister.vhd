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
-- File: InputDataRegister.vhd
--
-- Description:
-- Holds the current values of the data pins.  Designed as a transparent latch
-- the data pin values will be latched only during a read.  Uses the primative
-- LDCP of the XC9500XL series CPLD.
---------------------------------------------------------------------------------
-- DJB 01/04/19 Created.
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity InputDataRegister is
	port
	(
		Clock : in std_logic;
		DataPinsBus : in std_logic_vector(7 downto 0);
		InputDataBus : out std_logic_vector(7 downto 0)
	);
end InputDataRegister;

architecture Behavioral of InputDataRegister is
begin
	InputDataRegisterOperation : process (Clock) is
		variable inDataRegister : std_logic_vector(7 downto 0) := (others => '0');
	begin
		-- On every rising edge of the clock latch the data on the peripheral pins.
		if Clock'event and Clock = '1' then
			inDataRegister := DataPinsBus;
		end if;

		-- Put the data in the input data register onto the internal bus for other
		-- modules to use.
		InputDataBus <= inDataRegister;
	end process InputDataRegisterOperation;
end Behavioral;
