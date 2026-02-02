`timescale 1ns/1ps

module tb_stopwatch_fsm;

    reg clk;
    reg rst_n;
    reg start;
    reg stop;

    wire [5:0] seconds;
    wire [6:0] minutes;

    // DUT: Top-level stopwatch with FSM
    stopwatch_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .stop(stop),
        .seconds(seconds),
        .minutes(minutes)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Dump waveform
        $dumpfile("stopwatch_fsm.vcd");
        $dumpvars(0, tb_stopwatch_fsm);

        // Initial values
        clk   = 0;
        rst_n = 0;
        start = 0;
        stop  = 0;

        // --------------------------------
        // RESET → IDLE
        // --------------------------------
        #20 rst_n = 1;

        // --------------------------------
        // START → RUNNING
        // --------------------------------
        #10 start = 1;
        #10 start = 0;

        // Let it run
        #200;

        // --------------------------------
        // STOP → PAUSED
        // --------------------------------
        stop = 1;
        #10 stop = 0;

        // Stay paused
        #100;

        // --------------------------------
        // START → RESUME
        // --------------------------------
        start = 1;
        #10 start = 0;

        // Run again
        #150;

        // --------------------------------
        // RESET during run
        // --------------------------------
        rst_n = 0;
        #20 rst_n = 1;

        // Stay idle
        #50;

        // Start again after reset
        start = 1;
        #10 start = 0;

        #150;

        $finish;
    end

endmodule
