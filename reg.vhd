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

entity reg is
generic ( N: integer := 32 );
port ( 
    D: in std_logic_vector(N-1 downto 0);
    CLK, RST: in std_logic;
    Q: out std_logic_vector(N-1 downto 0));
end reg;

architecture behav of reg is
begin
    reg_proc: process (CLK)
    begin
        if CLK'event and CLK = '1' then
            if RST = '1' then
                Q <= (others => '0');
            else
                Q <= D;
            end if;
        end if;
    end process reg_proc;
end behav;
