# saif-adder
Open Source [Sentinel-based Approximate Integer Format Adder](https://ieeexplore.ieee.org/document/7858354) (SAIF)
supported by [Open Transprecision Computing (OPRECOMP)](http://oprecomp.eu/) Summer of Code.

# Usage / Tutorial
The Fibonacci number generators (`FibonacciTest.vhd`) and its testbench
(`FibnoacciTest_tb.vhd`) shows the basic usage of the adder for SAIF. You can
switch between the standard version and the pipelined
version for comparison with the accurate ripple adder.

```VHDL
U_AIF: AIFAdder   port map (AAIF, BAIF, '0', SAIF, CoutAIF);
--OR
U_AIF: AIFAdderPL port map (AAIF, BAIF, '0', CLK, RST, SAIF, CoutAIF);
--WITH
U_ACC: ACCAdder   port map (AACC, BACC, '0', SACC, CoutACC);
```

# License
All VHDL source codes and testbenches are released under GPU GPL v3.
