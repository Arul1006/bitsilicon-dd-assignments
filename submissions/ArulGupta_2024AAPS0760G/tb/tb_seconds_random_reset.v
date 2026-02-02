`timescale 1ns/1ps

module tb_seconds_random_reset;

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
        // Waveform dump
        $dumpfile("seconds_random_reset.vcd");
        $dumpvars(0, tb_seconds_random_reset);

        // Initial conditions
        clk    = 0;
        rst_n  = 0;
        enable = 0;

        // Initial reset
        #20 rst_n = 1;
        enable = 1;

        // Run simulation with random resets
        for (i = 0; i < 10; i = i + 1) begin
            // Let it count for a random time
            #(20 + {$random} % 100);

            // Assert reset randomly
            rst_n = 0;
            #10;            // reset active for a bit
            rst_n = 1;
        end

        // Let it run normally after chaos
        #200;

        $finish;
    end

endmodule
