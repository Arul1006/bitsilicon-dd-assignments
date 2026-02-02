/*
module stopwatch_top (
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    output wire [5:0] seconds,
    output wire [6:0] minutes
);

    wire tick_minute;

    // Seconds counter
    seconds_counter sec_inst (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .seconds(seconds),
        .tick_minute(tick_minute)
    );

    // Minutes counter
    minutes_counter min_inst (
        .clk(clk),
        .rst_n(rst_n),
        .tick_minute(tick_minute),
        .minutes(minutes)
    );

endmodule
*/

/*
module stopwatch_top (
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    input  wire stop,
    output wire [5:0] seconds,
    output wire [6:0] minutes
);

    // Internal wires
    wire enable;
    wire tick_minute;

    // ----------------------------
    // Control FSM
    // ----------------------------
    control_fsm u_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .stop(stop),
        .enable(enable)
    );

    // ----------------------------
    // Seconds counter (0–59)
    // ----------------------------
    seconds_counter u_seconds (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .seconds(seconds),
        .tick_minute(tick_minute)
    );

    // ----------------------------
    // Minutes counter
    // ----------------------------
    minutes_counter u_minutes (
        .clk(clk),
        .rst_n(rst_n),
        .tick_minute(tick_minute),
        .minutes(minutes)
    );

endmodule
*/

module stopwatch_top (
    input  wire clk,
    input  wire rst_n,     // system reset
    input  wire start,
    input  wire stop,
    input  wire reset,     // user reset
    output wire [7:0] minutes,
    output wire [5:0] seconds,
    output wire [1:0] status
);

    wire enable;
    wire tick_minute;

    // Control FSM
    control_fsm u_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .reset(reset),
        .start(start),
        .stop(stop),
        .enable(enable),
        .status(status)
    );

    // Seconds counter
    seconds_counter u_seconds (
        .clk(clk),
        .rst_n(rst_n),
        .reset(reset),
        .enable(enable),
        .seconds(seconds),
        .tick_minute(tick_minute)
    );

    // Minutes counter
    minutes_counter u_minutes (
        .clk(clk),
        .rst_n(rst_n),
        .reset(reset),
        .tick_minute(tick_minute),
        .minutes(minutes)
    );

endmodule


/*
module stopwatch_top (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire       stop,
    input  wire       reset,
    output wire [7:0] minutes,
    output wire [5:0] seconds,
    output wire [1:0] status
);

wire enable;
wire sec_tick;

// Control FSM
control_fsm u_fsm (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .stop(stop),
    .reset(reset),
    .enable(enable),
    .status(status)
);

// Seconds counter
seconds_counter u_sec (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .seconds(seconds),
    .sec_tick(sec_tick)
);

// Minutes counter (IMPORTANT FIX)
minutes_counter u_min (
    .clk(clk),
    .rst_n(rst_n),
    .sec_tick(sec_tick),
    .minutes(minutes)
);

endmodule
*/
