/*
module seconds_counter (
    input  wire clk,        // Clock input
    input  wire rst_n,        // Active-low reset
    input  wire enable,      // Enable counting
    output reg  [5:0] seconds,   // 6-bit seconds counter (0–59)
    output wire tick_minute      // Pulse when seconds roll over
);

    // Sequential logic: seconds counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: clear seconds to 0
            seconds <= 6'd0;
        end else if (enable) begin
            // Count only when enabled
            if (seconds == 6'd59)
                seconds <= 6'd0;        // Rollover
            else
                seconds <= seconds + 1'b1;  // Increment
        end
        // else: hold value when not enabled
    end

    // Combinational logic: generate tick for minutes counter
    assign tick_minute = (enable && seconds == 6'd59);

endmodule
*/

/*
// rollover problem
module seconds_counter (
    input  wire clk,
    input  wire rst_n,
    input  wire reset,
    input  wire enable,
    output reg  [5:0] seconds,
    output reg  tick_minute
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || reset) begin
            seconds     <= 6'd0;
            tick_minute <= 1'b0;
        end else if (enable) begin
            if (seconds == 6'd59) begin
                seconds     <= 6'd0;
                tick_minute <= 1'b1;
            end else begin
                seconds     <= seconds + 1'b1;
                tick_minute <= 1'b0;
            end
        end else begin
            tick_minute <= 1'b0;
        end
    end

endmodule
*/

/*module seconds_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    output reg  [5:0] seconds,
    output reg        sec_tick
);

always @(posedge clk) begin
    if (!rst_n) begin
        seconds  <= 6'd0;
        sec_tick <= 1'b0;
    end else begin
        sec_tick <= 1'b0;

        if (enable) begin
            if (seconds == 6'd59) begin
                seconds  <= 6'd0;
                sec_tick <= 1'b1;   // SAME cycle tick
            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end
end

endmodule
*/

module seconds_counter (
    input  wire clk,
    input  wire rst_n,
    input  wire reset,
    input  wire enable,
    output reg  [5:0] seconds,
    output wire tick_minute      // CHANGED: reg -> wire
);

    // 1. Sequential Logic: Counts seconds
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || reset) begin
            seconds <= 6'd0;
            // Note: tick_minute is no longer handled here
        end else if (enable) begin
            if (seconds == 6'd59)
                seconds <= 6'd0;
            else
                seconds <= seconds + 1'b1;
        end
    end

    // 2. Combinational Logic: Immediate Tick
    // This creates the pulse effectively "during" the 59th second, 
    // so the next module catches it on the very next clock edge.
    assign tick_minute = (seconds == 6'd59 && enable);

endmodule
