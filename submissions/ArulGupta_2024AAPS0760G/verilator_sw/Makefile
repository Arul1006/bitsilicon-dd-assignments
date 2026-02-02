# ================================
# Verilator Stopwatch Makefile
# ================================

# Top module name (must match Verilog top)
TOP = stopwatch_top

# Verilog RTL sources
RTL_DIR = ../rtl
RTL_SRCS = \
	$(RTL_DIR)/stopwatch_top.v \
	$(RTL_DIR)/control_fsm.v \
	$(RTL_DIR)/seconds_counter.v \
	$(RTL_DIR)/minutes_counter.v

# C++ test program
CPP_SRC = main.cpp

# Verilator
VERILATOR = verilator
VERILATOR_FLAGS = -Wall --cc --exe

# Build directory created by Verilator
OBJ_DIR = obj_dir

# Final executable name
EXEC = $(OBJ_DIR)/V$(TOP)

# ================================
# Default target
# ================================
all: build

# ================================
# Run Verilator + compile
# ================================
build:
	$(VERILATOR) $(VERILATOR_FLAGS) $(RTL_SRCS) $(CPP_SRC)
	$(MAKE) -C $(OBJ_DIR) -f V$(TOP).mk

# ================================
# Run the simulation
# ================================
run: build
	./$(EXEC)

# ================================
# Clean build artifacts
# ================================
clean:
	rm -rf $(OBJ_DIR)

.PHONY: all build run clean
