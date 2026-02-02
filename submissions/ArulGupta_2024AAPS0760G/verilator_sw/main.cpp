#include <verilated.h>
#include "Vstopwatch_top.h"
#include <iostream>
#include <iomanip>

// Global simulation time
vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

// Advance one clock cycle (1 Hardware Second)
void tick(Vstopwatch_top* dut) {
    dut->clk = 0;
    dut->eval();
    main_time++;

    dut->clk = 1;
    dut->eval();
    main_time++;
}

// Helper: Print current status
void print_status(Vstopwatch_top* dut) {
    std::cout << "Time: " 
              << std::setw(2) << std::setfill('0') << int(dut->minutes)
              << ":" << std::setw(2) << int(dut->seconds)
              << "   State: ";

    switch (dut->status) {
        case 0: std::cout << "IDLE"; break;
        case 1: std::cout << "RUNNING"; break;
        case 2: std::cout << "PAUSED"; break;
        default: std::cout << "UNKNOWN";
    }
    std::cout << "\n";
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vstopwatch_top* dut = new Vstopwatch_top("TOP");

    // ==========================================
    // 0. INITIAL POWER UP
    // ==========================================
    dut->clk   = 0;
    dut->rst_n = 0; 
    dut->reset = 0; 
    dut->start = 0;
    dut->stop  = 0;

    // Apply system reset
    for (int i = 0; i < 5; i++) tick(dut);
    dut->rst_n = 1; 
    
    // ==========================================
    // 1. COUNT TO 01:05
    // ==========================================
    std::cout << "[Test] Starting Timer (Target: 01:05)...\n";
    dut->start = 1;
    tick(dut);      // Capture start
    dut->start = 0; // Release start

    // Loop 65 times (60s + 5s = 65s)
    for (int i = 0; i < 65; i++) {
        tick(dut);
        // Optional: Only print every 10s to keep log short, 
        // OR print everything. Here I print everything as requested.
        print_status(dut);
    }

    // ==========================================
    // 2. PAUSE FOR 5 CYCLES
    // ==========================================
    std::cout << "\n[Test] Pausing for 5 cycles...\n";
    dut->stop = 1;
    tick(dut);      // Capture stop
    dut->stop = 0;

    for (int i = 0; i < 5; i++) {
        tick(dut);
        print_status(dut);
    }

    // ==========================================
    // 3. RESUME TO 01:10
    // ==========================================
    std::cout << "\n[Test] Resuming to 01:10...\n";
    dut->start = 1;
    tick(dut);
    dut->start = 0;

    for (int i = 0; i < 5; i++) {
        tick(dut);
        print_status(dut);
    }

    // ==========================================
    // 4. RESET
    // ==========================================
    std::cout << "\n[Test] Resetting...\n";
    dut->reset = 1;
    tick(dut);
    dut->reset = 0;
    
    print_status(dut); // Should be 00:00 IDLE

    delete dut;
    return 0;
}
