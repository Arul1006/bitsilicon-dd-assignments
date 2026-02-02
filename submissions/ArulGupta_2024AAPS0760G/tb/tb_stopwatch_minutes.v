`timescale 1ns/1ps

module tb_stopwatch_minutes;

    reg clk;
    reg rst_n;
    reg start;
    reg stop;

    wire [5:0] seconds;
    wire [6:0] minutes;

    // DUT: Full stopwatch system
    stopwatch_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .stop(stop),
        .seconds(seconds),
        .minutes(minutes)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        // Dump waveform
        $dumpfile("stopwatch_minutes.vcd");
        $dumpvars(0, tb_stopwatch_minutes);

        // Initial values
        clk   = 0;
        rst_n = 0;
        start = 0;
        stop  = 0;

        // ----------------------------
        // RESET → IDLE
        // ----------------------------
        #20 rst_n = 1;

        // ----------------------------
        // START stopwatch
        // ----------------------------
        #10 start = 1;
        #10 start = 0;

        // ----------------------------
        // Let it run long enough
        // to cross multiple minute rollovers
        // ----------------------------
        #1300;   // ~130 seconds (with 10ns clk)

        // ----------------------------
        // PAUSE in the middle
        // ----------------------------
        stop = 1;
        #10 stop = 0;

        // Stay paused (minutes must NOT change)
        #200;

        // ----------------------------
        // RESUME
        // ----------------------------
        start = 1;
        #10 start = 0;

        // Run again (more minute increments)
        #800;

        // ----------------------------
        // RESET everything
        // ----------------------------
        rst_n = 0;
        #20 rst_n = 1;

        // ----------------------------
        // Start again after reset
        // ----------------------------
        start = 1;
        #10 start = 0;

        #500;

        $finish;
    end

endmodule
