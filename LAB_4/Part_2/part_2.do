 # Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns part_2.v

# Load simulation using mux as the top level simulation module.
vsim part_2

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

#Test case #5
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
force {SW[9]} 0 0, 1 40 -r 80
force {KEY[0]} 0 0, 1 20 -r 40
run 50ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
force {SW[9]} 0 0, 1 40 -r 80
force {KEY[0]} 0 0, 1 20 -r 40
run 100ns
