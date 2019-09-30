----------------------------------------------------------------------------------
-- Project: Arithmetic Unit Design for Approximate Integer Formats
--
-- Copyright (C) 2019 Matthew Wai-Chung Tang
-- This program is free software: you can redistribute it and/or modify it under
-- the terms of the GNU General Public License as published by the Free Software
-- Foundation, version 3.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along with
-- this program. If not, see <https://www.gnu.org/licenses/>
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- 5-to-1 MUX for choosing the right blocks 
-- selection bits are (priority) decoded already
entity muxd5 is
port ( 
    A: in std_logic_vector(19 downto 0); -- 5 x 4-bit blocks
    S: in std_logic_vector(4 downto 0);
    Y: out std_logic_vector(3 downto 0));
end muxd5;

architecture behav of muxd5 is
begin
	Y <= A(19 downto 16) when S(4) = '1' else
         A(15 downto 12) when S(3) = '1' else
         A(11 downto  8) when S(2) = '1' else
         A( 7 downto  4) when S(1) = '1' else
         A( 3 downto  0);
end behav;


