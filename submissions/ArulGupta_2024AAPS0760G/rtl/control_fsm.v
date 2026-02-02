/*
module control_fsm (
    input  wire clk,
    input  wire rst_n,     // active-low reset
    input  wire start,     // start / resume
    input  wire stop,      // pause
    output reg  enable     // enables counters
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUNNING = 2'b01,
        PAUSED  = 2'b10
    } state_t;

    state_t current_state, next_state;

    // 1. State register (memory)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // 2. Next-state logic (decisions)
    always @(*) begin
        next_state = current_state;  // default: stay

        case (current_state)

            IDLE: begin
                if (start)
                    next_state = RUNNING;
            end

            RUNNING: begin
                if (stop)
                    next_state = PAUSED;
            end

            PAUSED: begin
                if (start)
                    next_state = RUNNING;
            end

            default: next_state = IDLE;

        endcase
    end

    // 3. Output logic (Moore FSM)
    always @(*) begin
        case (current_state)
            RUNNING: enable = 1'b1;
            default: enable = 1'b0;
        endcase
    end

endmodule
*/

module control_fsm (
    input  wire clk,
    input  wire rst_n,     // system reset (active low)
    input  wire reset,     // user reset (active high)
    input  wire start,
    input  wire stop,
    output reg  enable,
    output reg  [1:0] status
);

    // State encoding (matches spec)
    localparam IDLE    = 2'b00;
    localparam RUNNING = 2'b01;
    localparam PAUSED  = 2'b10;

    reg [1:0] current_state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (start)
                    next_state = RUNNING;
            end

            RUNNING: begin
                if (stop)
                    next_state = PAUSED;
            end

            PAUSED: begin
                if (start)
                    next_state = RUNNING;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        status = current_state;

        case (current_state)
            RUNNING: enable = 1'b1;
            default: enable = 1'b0;
        endcase
    end

endmodule

