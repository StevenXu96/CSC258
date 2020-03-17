 # Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns ripple_adder.v

# Load simulation using mux as the top level simulation module.
vsim ripple_adder

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case: all 0
force {A[0]} 0
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 0
force {B[1]} 0
force {B[2]} 0
force {B[3]} 0
force {cin[0]} 0
# Run simulation for a few ns.
run 10ns

# second test case: cin = 1
force {A[0]} 0
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 0
force {B[1]} 0
force {B[2]} 0
force {B[3]} 0
force {cin[0]} 1
# Run simulation for a few ns.
run 10ns

# third test case: all 1
force {A[0]} 1
force {A[1]} 1
force {A[2]} 1
force {A[3]} 1
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 1
force {cin[0]} 1
# Run simulation for a few ns.
run 10ns

# fourth test case: all A = 0, all B = 1
force {A[0]} 0
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 1
force {B[1]} 1
force {B[2]} 1
force {B[3]} 1
force {cin[0]} 0
# Run simulation for a few ns.
run 10ns

# fifth test case: all A have 1 1, all B have 1 0
force {A[0]} 1
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 0
force {B[1]} 1
force {B[2]} 1
force {B[3]} 1
force {cin[0]} 0
# Run simulation for a few ns.
run 10ns

# sixth test case: A have 2 1, B have 2 0
force {A[0]} 1
force {A[1]} 1
force {A[2]} 0
force {A[3]} 0
force {B[0]} 0
force {B[1]} 1
force {B[2]} 0
force {B[3]} 1
force {cin[0]} 0
# Run simulation for a few ns.
run 10ns

# seventh test case: A have 1 1, B have 1 1
force {A[0]} 1
force {A[1]} 0
force {A[2]} 0
force {A[3]} 0
force {B[0]} 0
force {B[1]} 1
force {B[2]} 0
force {B[3]} 0
force {cin[0]} 0
# Run simulation for a few ns.
run 10ns

# eighth test case: A have 3 1, B have 3 1
force {A[0]} 1
force {A[1]} 1
force {A[2]} 1
force {A[3]} 0
force {B[0]} 0
force {B[1]} 1
force {B[2]} 1
force {B[3]} 1
force {cin[0]} 0
# Run simulation for a few ns.
run 10ns
