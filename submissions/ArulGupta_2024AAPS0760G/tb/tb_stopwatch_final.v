`timescale 1ns/1ps

module tb_stopwatch_final;

    reg clk;
    reg rst_n;
    reg start;
    reg stop;
    reg reset;

    wire [7:0] minutes;
    wire [5:0] seconds;
    wire [1:0] status;

    // DUT: Spec-compliant stopwatch
    stopwatch_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .stop(stop),
        .reset(reset),
        .minutes(minutes),
        .seconds(seconds),
        .status(status)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("stopwatch_final.vcd");
        $dumpvars(0, tb_stopwatch_final);

        // Initial values
        clk   = 0;
        rst_n = 0;
        reset = 0;
        start = 0;
        stop  = 0;

        // --------------------------------
        // SYSTEM RESET (power-on)
        // --------------------------------
        #20 rst_n = 1;

        // --------------------------------
        // START → RUNNING
        // --------------------------------
        #10 start = 1;
        #10 start = 0;

        // Run long enough to see minute increment
        #700;

        // --------------------------------
        // STOP → PAUSED
        // --------------------------------
        stop = 1;
        #10 stop = 0;

        // Stay paused (time must not change)
        #200;

        // --------------------------------
        // RESUME → RUNNING
        // --------------------------------
        start = 1;
        #10 start = 0;

        #400;

        // --------------------------------
        // USER RESET (functional reset)
        // --------------------------------
        reset = 1;
        #10 reset = 0;

        // Confirm IDLE + 00:00
        #100;

        // --------------------------------
        // START again after reset
        // --------------------------------
        start = 1;
        #10 start = 0;

        #400;

        $finish;
    end

endmodule
