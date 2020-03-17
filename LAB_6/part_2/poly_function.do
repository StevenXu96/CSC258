# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns poly_function.v

# Load simulation using fpga_top as the top level simulation module.
vsim fpga_top

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# 5*2*2 + 1*2 + 2 = 11000
force {KEY[0]} 0 0, 1 4
force {KEY[1]} 1 6, 0 8, 1 10, 0 12, 1 20, 0 22, 1 30, 0 32, 1 34
force {SW[7:0]} 00000010 0, 00000001 11, 00000101 21, 00000010 31
force {CLOCK_50} 0 0, 1 1 -r 2
run 70ns
