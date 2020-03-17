 # Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in part_1.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns part_1.v

# Load simulation using mux as the top level simulation module.
vsim part_1

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case: Default (111)
force {SW[7]} 0 0, 1 640 -repeat 1280
force {SW[8]} 0 0 ns, 1 320 ns -r 640 
force {SW[9]} 0 0, 1 160 -r 320
force {SW[0]} 0 0, 1 80 -repeat 160
force {SW[1]} 0 0, 1 40 -repeat 80
force {SW[2]} 0 0, 1 20 -repeat 40
force {SW[3]} 0 0, 1 10 -repeat 20
force {SW[4]} 0 0, 1 5 -repeat 10
force {SW[5]} 0 0, 1 2.5 -repeat 5
force {SW[6]} 0 0, 1 1.25 -repeat 2.5

# Run simulation for a few ns.
run 1280ns


