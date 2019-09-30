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

entity AIFAdder_tb is
end AIFAdder_tb;

architecture behav of AIFAdder_tb is
    component AIFAdder is
    port ( 
        A, B: in std_logic_vector(31 downto 0); -- 8 x 4-bit blocks
        Ci: in std_logic; 
        S: out std_logic_vector(31 downto 0); -- sum in AIF
        Co: out std_logic);
    end component;
    signal A, B, S: std_logic_vector(31 downto 0);
    signal Ci, Co: std_logic;
begin
    UUT: AIFAdder port map (A, B, Ci, S, Co);
    sim_proc: process
    begin
        Ci <= '0';
        A <= x"03000029";
        B <= x"0F004823";
        wait for 100 ns;
        A <= x"3F60A68C";
        B <= x"0F0084B6";
        wait for 100 ns;
        A <= x"7FBD864B";
        B <= x"0F006784";
        wait for 100 ns;
        A <= x"3F1D31B5";
        B <= x"FFFEB825";
        wait for 100 ns;
        A <= x"7F95F575";
        B <= x"FF4BEEC9";
        wait for 100 ns;
        A <= x"0F002CD6";
        B <= x"7FBD864B";
        wait for 100 ns;
        A <= x"FFAEFD2A";
        B <= x"1F05F90F";
        wait for 100 ns;
        A <= x"FF220191";
        B <= x"FF8AC43E";
        wait for 100 ns;
        A <= x"1F0F3309";
        B <= x"030000EB";
        wait for 100 ns;
        wait;
    end process;
end behav;
