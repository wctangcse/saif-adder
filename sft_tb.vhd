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

entity sft_tb is
end sft_tb;

architecture behav of sft_tb is
    component sft is
    port ( 
        DBlk: in std_logic_vector(23 downto 0); -- 6 x 4-bit blocks
        st7, st6: in std_logic; -- two MSB from 2 x 2-bit sentinel blocks
        Y: out std_logic_vector(31 downto 0)); -- expanded, padded approximated value
    end component;
    signal DBlk: std_logic_vector(23 downto 0);
    signal st7, st6: std_logic;
    signal Y: std_logic_vector(31 downto 0);
begin
    UUT: sft port map (DBlk, st7, st6, Y);
    sim_proc: process
    begin
        DBlk <= "0010"&"0001"&"1110"&"0110"&"0011"&"0100";
        st7 <= '0';
        st6 <= '0';
        wait for 100 ns;
        st7 <= '0';
        st6 <= '1';
        wait for 100 ns;
        st7 <= '1';
        st6 <= '1';
        wait for 100 ns;
        st7 <= '0';
        st6 <= '0';
        wait for 100 ns;
        wait;
    end process;
end behav;
