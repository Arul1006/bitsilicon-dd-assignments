`timescale 1ns/1ps

module tb_stopwatch_top;

    reg clk;
    reg rst_n;
    reg enable;

    wire [5:0] seconds;
    wire [6:0] minutes;

    stopwatch_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .seconds(seconds),
        .minutes(minutes)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("stopwatch.vcd");
        $dumpvars(0, tb_stopwatch_top);

        clk = 0;
        rst_n = 0;
        enable = 0;

        // Reset
        #20 rst_n = 1;

        // Start stopwatch
        #10 enable = 1;

        // Run for some time
        #800;

        // Pause
        enable = 0;
        #100;

        // Resume
        enable = 1;
        #400;

        // Reset during run
        rst_n = 0;
        #30 rst_n = 1;

        #300;
        $finish;
    end

endmodule
