
vlib work

vlog -timescale 1ns/1ns part2.v

vsim combo

log {/*}
add wave {/*}
force {go} 0 0, 1 40, 0 60
force {resetN} 0 0, 1 20
force {clock} 0 0, 1 10 -r 20
force {draw} 0 0, 1 80, 0 0 100
force {location_in} 0000001 0, 1100111 40, 1101000 80
force {colour_in} 111
run 600ns


