`timescale 1ns/1ps

module tb_minutes_counter;

    reg clk;
    reg rst_n;
    reg tick_minute;
    wire [6:0] minutes;

    minutes_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .tick_minute(tick_minute),
        .minutes(minutes)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("minutes.vcd");
        $dumpvars(0, tb_minutes_counter);

        clk = 0;
        rst_n = 0;
        tick_minute = 0;

        // Reset
        #20 rst_n = 1;

        // Generate minute ticks
        repeat (6) begin
            #40 tick_minute = 1;
            #10 tick_minute = 0;
        end

        #100;
        $finish;
    end

endmodule
