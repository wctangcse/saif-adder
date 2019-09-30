# saif-adder
Open Source Sentinel-based Approximate Integer Format Adder
supported by [Open Transprecision Computing (OPRECOMP)](http://oprecomp.eu/) Summer of Code.

# Usage / Tutorial
The Fibonacci number generators (FibonacciTest.vhd) shows the basic usage of the
adder for SAIF. You can switch between the standard version and the pipelined
version for comparison with the accurate ripple adder.

`
U_AIF: AIFAdder   port map (AAIF, BAIF, '0', SAIF, CoutAIF);
U_AIF: AIFAdderPL port map (AAIF, BAIF, '0', CLK, RST, SAIF, CoutAIF);
U_ACC: ACCAdder   port map (AACC, BACC, '0', SACC, CoutACC);
`

