`timescale 1ns/1ps

module tb_seconds_random_enable;

    reg clk;
    reg rst_n;
    reg enable;
    wire [5:0] seconds;
    wire tick_minute;

    // DUT
    seconds_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .seconds(seconds),
        .tick_minute(tick_minute)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    integer i;

    initial begin
        // Dump waveform
        $dumpfile("seconds_random_enable.vcd");
        $dumpvars(0, tb_seconds_random_enable);

        // Initial values
        clk    = 0;
        rst_n  = 0;
        enable = 0;

        // Initial reset
        #20;
        rst_n = 1;
        enable = 1;

        // Random enable toggling
        for (i = 0; i < 12; i = i + 1) begin
            // Let it run for random time
            #(20 + {$random} % 120);

            // Pause
            enable = 0;
            #(20 + {$random} % 80);

            // Resume
            enable = 1;
        end

        // Final run
        #200;

        $finish;
    end

endmodule
