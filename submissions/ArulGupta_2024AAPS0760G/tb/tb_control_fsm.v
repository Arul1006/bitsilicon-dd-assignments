`timescale 1ns/1ps

module tb_control_fsm;

    reg clk;
    reg rst_n;
    reg start;
    reg stop;
    wire enable;

    control_fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .stop(stop),
        .enable(enable)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("fsm.vcd");
        $dumpvars(0, tb_control_fsm);

        // Initial values
        clk   = 0;
        rst_n = 0;
        start = 0;
        stop  = 0;

        // Reset
        #20 rst_n = 1;

        // Start stopwatch
        #10 start = 1;
        #10 start = 0;

        // Let it run
        #50;

        // Pause
        stop = 1;
        #10 stop = 0;

        // Stay paused
        #50;

        // Resume
        start = 1;
        #10 start = 0;

        // Run again
        #50;

        // Reset during run
        rst_n = 0;
        #20 rst_n = 1;

        #50;
        $finish;
    end

endmodule
