
vlib work

vlog -timescale 1ns/1ns controller.v

vsim controller

log {/*}
add wave {/*}
force {go} 0 0, 1 20 -r 40
force {resetN} 0 0, 1 20
force {clock} 0 0, 1 10 -r 20
force {draw} 0 0, 1 80, 0 100
run 150ns

