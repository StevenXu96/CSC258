 # Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns ram32x4.v

# Load simulation using mux as the top level simulation module.
vsim -L altera_mf_ver ram32x4

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {clock} 0 0, 1 5 -r 10
force {address} 00000 0, 00001 10, 00011 20, 00010 30 -r 40
force {data} 0001 0, 0011 10, 0010 20, 0110 30 -r 40
force {wren} 1 0, 0 80 -r 160
run 320ns
