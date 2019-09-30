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
use IEEE.std_logic_unsigned.all;

-- standard adder for 4-bit blocks
entity adder4 is
port ( 
    A, B: in std_logic_vector(3 downto 0);
    Ci: in std_logic;
    S: out std_logic_vector(3 downto 0);
    Co: out std_logic);
end adder4;

architecture behav of adder4 is
    signal Si, X, Y: std_logic_vector(4 downto 0);
begin
    X <= '0' & A;
    Y <= '0' & B;
    Si <= X + Y + Ci;
    S <= Si(3 downto 0);
    Co <= Si(4);
end behav;
