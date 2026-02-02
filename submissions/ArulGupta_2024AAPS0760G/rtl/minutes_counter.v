/*module minutes_counter (
    input  wire clk,
    input  wire rst_n,          // active-low reset
    input  wire tick_minute,    // pulse from seconds counter
    output reg  [6:0] minutes   // 0–99 fits in 7 bits
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            minutes <= 7'd0;
        end
        else if (tick_minute) begin
            if (minutes == 7'd99)
                minutes <= 7'd0;     // rollover
            else
                minutes <= minutes + 1'b1;
        end
        // else: hold value
    end

endmodule
*/

module minutes_counter (
    input  wire clk,
    input  wire rst_n,
    input  wire reset,
    input  wire tick_minute,
    output reg  [7:0] minutes
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || reset) begin
            minutes <= 8'd0;
        end else if (tick_minute) begin
            if (minutes == 8'd99)
                minutes <= 8'd0;
            else
                minutes <= minutes + 1'b1;
        end
    end

endmodule


/*module minutes_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       sec_tick,
    output reg  [7:0] minutes
);

always @(posedge clk) begin
    if (!rst_n) begin
        minutes <= 8'd0;
    end else if (sec_tick) begin
        if (minutes == 8'd99)
            minutes <= 8'd0;
        else
            minutes <= minutes + 8'd1;
    end
end

endmodule
*/
