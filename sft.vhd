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

-- Block shifters for AIF
entity sft is
port ( 
    DBlk: in std_logic_vector(23 downto 0); -- 6 x 4-bit blocks
    st7, st6: in std_logic; -- two MSB from 2 x 2-bit sentinel blocks
    Y: out std_logic_vector(31 downto 0)); -- expanded, padded approximated value
end sft;

architecture behav of sft is
    type AIF_Integer is array (7 downto 0) of std_logic_vector(3 downto 0); 
    signal A, W, Yi: AIF_Integer;
    signal Z: std_logic_vector(3 downto 0); -- zero block "0000"

    component mux2 is
    port ( 
        A, B: in std_logic_vector(3 downto 0);
        S: in std_logic;
        Y: out std_logic_vector(3 downto 0));
    end component;
begin
    Z <= (others => '0');
    A(0) <= DBlk(3 downto 0);
    A(1) <= DBlk(7 downto 4);
    A(2) <= DBlk(11 downto 8);
    A(3) <= DBlk(15 downto 12);
    A(4) <= DBlk(19 downto 16);
    A(5) <= DBlk(23 downto 20);
    
    -- LEVEL 1 SHIFTER
    U0: mux2 port map (A(0),    Z, st6, W(0));
    U1: mux2 port map (A(1), A(0), st6, W(1));
    U2: mux2 port map (A(2), A(1), st6, W(2));
    U3: mux2 port map (A(3), A(2), st6, W(3));
    U4: mux2 port map (A(4), A(3), st6, W(4));
    U5: mux2 port map (A(5), A(4), st6, W(5));
    U6: mux2 port map (   Z, A(5), st6, W(6));
    W(7) <= Z;
    
    -- LEVEL 2 SHIFTER
    P0: mux2 port map (W(0),    Z, st7, Yi(0));
    P1: mux2 port map (W(1), W(0), st7, Yi(1));
    P2: mux2 port map (W(2), W(1), st7, Yi(2));
    P3: mux2 port map (W(3), W(2), st7, Yi(3));
    P4: mux2 port map (W(4), W(3), st7, Yi(4));
    P5: mux2 port map (W(5), W(4), st7, Yi(5));
    P6: mux2 port map (W(6), W(5), st7, Yi(6));
    P7: mux2 port map (W(7), W(6), st7, Yi(7));


    Y(31 downto 28) <= Yi(7);
    Y(27 downto 24) <= Yi(6);
    Y(23 downto 20) <= Yi(5);
    Y(19 downto 16) <= Yi(4);
    Y(15 downto 12) <= Yi(3);
    Y(11 downto  8) <= Yi(2);
    Y( 7 downto  4) <= Yi(1);
    Y( 3 downto  0) <= Yi(0);
end behav;


