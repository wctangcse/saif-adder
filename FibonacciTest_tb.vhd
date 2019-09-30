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

entity FibonacciTest_tb is
end FibonacciTest_tb;

architecture behav of FibonacciTest_tb is
    component FibonacciTest is
    port (
        CLK: in std_logic;
        RST: in std_logic;
        X, Y: out std_logic_vector(31 downto 0);
        Done: out std_logic);
    end component;
    signal CLK, RST, Done: std_logic;
    signal X, Y: std_logic_vector(31 downto 0);
begin
    UUT: FibonacciTest port map (CLK, RST, X, Y, Done);
    clock_proc: process
    begin
        CLK <= '0';
        wait for 50 ns;
        CLK <= '1';
        wait for 50 ns;
    end process;

    sim_proc: process
    begin
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait;
    end process;
end behav;
