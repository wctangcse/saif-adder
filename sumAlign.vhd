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

entity sumAlign is
port ( 
    sumIn: in std_logic_vector(15 downto 0); -- 4 x 4-bit blocks
    st5, st4: in std_logic;
    Co: in std_logic; -- carry out from the adder
    sumOut: out std_logic_vector(23 downto 0)); -- aligned: 6 x 4-bit blocks 
end sumAlign;

architecture behav of sumAlign is
    type DataBlocks is array (5 downto 0) of std_logic_vector(3 downto 0); 
    signal A, Yi, Yj, Yk: DataBlocks;
    signal Zero: std_logic_vector(3 downto 0); -- one block "0001"
    signal tmp1: std_logic;

    component mux2 is
    port ( 
        A, B: in std_logic_vector(3 downto 0);
        S: in std_logic;
        Y: out std_logic_vector(3 downto 0));
    end component;
begin
    Zero <= (others => '0');
    A(5) <= Zero;
    A(4) <= "000" & Co;
    A(3) <= sumIn(15 downto 12);
    A(2) <= sumIn(11 downto 8);
    A(1) <= sumIn(7 downto 4);
    A(0) <= sumIn(3 downto 0);

    tmp1 <= st5 and (not Co);
    
    -- LEVEL 1 SHIFTER
    LY1_5: mux2 port map (A(5), A(4), st4, Yi(5));
    LY1_4: mux2 port map (A(4), A(3), st4, Yi(4));
    LY1_3: mux2 port map (A(3), A(2), st4, Yi(3));
    LY1_2: mux2 port map (A(2), A(1), st4, Yi(2));
    LY1_1: mux2 port map (A(1), A(0), st4, Yi(1));
    LY1_0: mux2 port map (A(0), Zero, st4, Yi(0));
    
    -- LEVEL 2 SHIFTER
    LY2_5: mux2 port map (Yi(5), Yi(4), tmp1, Yj(5));
    LY2_4: mux2 port map (Yi(4), Yi(3), tmp1, Yj(4));
    LY2_3: mux2 port map (Yi(3), Yi(2), tmp1, Yj(3));
    LY2_2: mux2 port map (Yi(2), Yi(1), tmp1, Yj(2));
    LY2_1: mux2 port map (Yi(1), Yi(0), tmp1, Yj(1)); -- Yi(0) Zero?
    LY2_0: mux2 port map (Yi(0),  Zero, tmp1, Yj(0));

    sumOut(23 downto 20) <= Yj(5);
    sumOut(19 downto 16) <= Yj(4);
    sumOut(15 downto 12) <= Yj(3);
    sumOut(11 downto  8) <= Yj(2);
    sumOut( 7 downto  4) <= Yj(1);
    sumOut( 3 downto  0) <= Yj(0);
end behav;


