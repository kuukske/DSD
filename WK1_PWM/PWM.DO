restart -f
force NRST 0 0, 1 5
force CLK 0 0, 1 10 ns -r 20 ns

force D_in 00000100 0 ns, 00010000 123 ns, 00000000 250 ns
force Init 0 0 ns, 1 7 ns, 0 90 ns
force Avail 0 0 ns, 1 13 ns, 0 75 ns, 1 127 ns, 0 175 ns

run 10000 ns