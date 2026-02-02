`timescale 1ns/1ps

module tb_seconds;

    reg clk;
    reg rst_n;
    reg enable;
    wire [5:0] seconds;
    wire tick_minute;

    // Instantiate the seconds counter (DUT)
    seconds_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .seconds(seconds),
        .tick_minute(tick_minute)
    );

    // Clock generation: 10 ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Dump waveform for GTKWave
        $dumpfile("seconds.vcd");
        $dumpvars(0, tb_seconds);

        // Initial values
        clk    = 0;
        rst_n  = 0;   // reset active
        enable = 0;

        // Hold reset for some time
        #20;
        rst_n = 1;    // release reset

        // Start counting
        #10;
        enable = 1;

        // Let it count for ~70 seconds (enough to see rollover)
        #700;

        // Pause counting
        enable = 0;

        // Wait a bit
        #50;

        // Resume counting
        enable = 1;
        #100;

        // End simulation
        $finish;
    end

endmodule
