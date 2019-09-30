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

----------------------------------------------------------------------------------
-- Design: Fibonacci Demonstration for AIF Adder
----------------------------------------------------------------------------------
entity FibonacciTest is
port ( 
    CLK: in std_logic;
    RST: in std_logic;
    X, Y: out std_logic_vector(31 downto 0);
    Done: out std_logic);
end FibonacciTest;

architecture fsm_behav of FibonacciTest is
    signal AAIF, BAIF, SAIF: std_logic_vector(31 downto 0); -- shifted, aligned data blocks
    signal AACC, BACC, SACC: std_logic_vector(31 downto 0); 
    signal CoutAIF, CoutACC: std_logic;
    Signal Done_i: std_logic;
    signal count: std_logic_vector(7 downto 0);

    component AIFAdder is
    port ( 
        A, B: in std_logic_vector(31 downto 0); -- 8 x 4-bit blocks
        Ci: in std_logic; 
        S: out std_logic_vector(31 downto 0); -- sum in AIF
        Co: out std_logic);
    end component;
    component AIFAdderPL is
    port ( 
        A, B: in std_logic_vector(31 downto 0); -- 8 x 4-bit blocks
        Ci: in std_logic;
        CLK, RST: in std_logic; 
        S: out std_logic_vector(31 downto 0); -- sum in AIF
        Co: out std_logic);
    end component;
    component ACCAdder is
    port ( 
        A, B: in std_logic_vector(31 downto 0); -- 8 x 4-bit blocks
        Ci: in std_logic; 
        S: out std_logic_vector(31 downto 0); -- sum in AIF
        Co: out std_logic);
    end component;
begin
    -- choose between non-pipelined and pipelined version
    U_AIF: AIFAdder port map (AAIF, BAIF, '0', SAIF, CoutAIF);
    --U_AIF: AIFAdderPL port map (AAIF, BAIF, '0', CLK, RST, SAIF, CoutAIF);

    U_ACC: ACCAdder port map (AACC, BACC, '0', SACC, CoutACC);

    reg_proc: process (CLK)
    begin
        if CLK'event and CLK = '1' then
            if RST = '1' then
                AAIF <= x"00000000";
                BAIF <= x"01000001";
                AACC <= x"00000000";
                BACC <= x"00000001";
            elsif Done_i = '0' and count(1 downto 0) = "11" then
                AAIF <= BAIF;
                BAIF <= SAIF;
                AACC <= BACC;
                BACC <= SACC;
            end if;
        end if;
    end process reg_proc;

    count_proc: process (CLK)
    begin
        if CLK'event and CLK = '1' then
            if RST = '1' then
                count <= (others => '0');
            elsif Done_i = '0' then
                count <= count + 1;
            end if;
        end if;
    end process count_proc;

    Done_i <= '1' when count = 170 else '0';
    X <= SAIF;
    Y <= SACC;
    Done <= Done_i;
end fsm_behav;
