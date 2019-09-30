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

----------------------------------------------------------------------------------
-- Pipeline:    Nil
----------------------------------------------------------------------------------
entity AIFAdder is
port ( 
    A, B: in std_logic_vector(31 downto 0); -- 8 x 4-bit blocks
    Ci: in std_logic; 
    S: out std_logic_vector(31 downto 0); -- sum in AIF
    Co: out std_logic);
end AIFAdder;

architecture struct of AIFAdder is
    signal X, Y: std_logic_vector(31 downto 0); -- shifted, aligned data blocks
    signal P, Q: std_logic_vector(15 downto 0); -- chosen blocks to enter adders
    signal C: std_logic_vector(3 downto 0); -- carries from adder
    signal Si: std_logic_vector(15 downto 0);
    signal DBlkOut: std_logic_vector(23 downto 0);
    signal stS0, stS1, stMask: std_logic_vector(7 downto 0);

    component sft is
    port ( 
        DBlk: in std_logic_vector(23 downto 0); -- 6 x 4-bit blocks
        st7, st6: in std_logic; -- two MSB from 2 x 2-bit sentinel blocks
        Y: out std_logic_vector(31 downto 0)); -- expanded, padded approximated value
    end component;

    component adder4 is
    port ( 
        A, B: in std_logic_vector(3 downto 0);
        Ci: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Co: out std_logic);
    end component;

    component muxd5 is
    port ( 
        A: in std_logic_vector(19 downto 0); -- 5 x 4-bit blocks
        S: in std_logic_vector(4 downto 0);
        Y: out std_logic_vector(3 downto 0));
    end component;

    component sumAlign is
    port ( 
        sumIn: in std_logic_vector(15 downto 0); -- 4 x 4-bit blocks
        st5, st4: in std_logic;
        Co: in std_logic; -- carry out from the adder
        sumOut: out std_logic_vector(23 downto 0)); -- aligned: 6 x 4-bit blocks
    end component;
begin
    -- new sentinel 2 x 4-bit blocks = 8 bits
    stS0 <= A(31 downto 24) or B(31 downto 24);

    -- 1st layer: shifter / expander
    LY1_A: sft port map (A(23 downto 0), A(31), A(30), X);
    LY1_B: sft port map (B(23 downto 0), B(31), B(30), Y);

    -- 2nd layer: block selection MUXes (pc = 4)
    LY2_M3_X: muxd5 port map (X(31 downto 12), stS0(7 downto 3), P(15 downto 12));
    LY2_M3_Y: muxd5 port map (Y(31 downto 12), stS0(7 downto 3), Q(15 downto 12));
    LY2_M2_X: muxd5 port map (X(27 downto  8), stS0(7 downto 3), P(11 downto  8));
    LY2_M2_Y: muxd5 port map (Y(27 downto  8), stS0(7 downto 3), Q(11 downto  8));
    LY2_M1_X: muxd5 port map (X(23 downto  4), stS0(7 downto 3), P( 7 downto  4));
    LY2_M1_Y: muxd5 port map (Y(23 downto  4), stS0(7 downto 3), Q( 7 downto  4));
    LY2_M0_X: muxd5 port map (X(19 downto  0), stS0(7 downto 3), P( 3 downto  0));
    LY2_M0_Y: muxd5 port map (Y(19 downto  0), stS0(7 downto 3), Q( 3 downto  0));

    -- 3nd layer: adders
    LY3_A3: adder4 port map (P(15 downto 12), Q(15 downto 12), C(2), Si(15 downto 12), C(3));
    LY3_A2: adder4 port map (P(11 downto  8), Q(11 downto  8), C(1), Si(11 downto  8), C(2));
    LY3_A1: adder4 port map (P( 7 downto  4), Q( 7 downto  4), C(0), Si( 7 downto  4), C(1));
    LY3_A0: adder4 port map (P( 3 downto  0), Q( 3 downto  0), Ci, Si( 3 downto  0), C(0));

    -- 4th layer: final touch
    LY4_AG: sumAlign port map(Si, stS0(5), stS0(4), C(3), DBlkOut);
    
    stS1 <= stS0 or stMask;
    stMask(4 downto 0) <= C & '1';
    stMask(5) <= C(3) and stS0(4);
    stMask(6) <= C(3) and stS0(5);
    stMask(7) <= C(3) and stS0(6);

    -- connect to primary outputs
    Co <= C(3);
    S <= stS1 & DBlkOut;
end struct;
