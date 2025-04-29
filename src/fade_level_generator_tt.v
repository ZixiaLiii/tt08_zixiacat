`default_nettype none
`timescale 1ns / 1ps

// Tiny Tapeout-compatible fade level generator
module fade_level_generator_tt (
    input  wire clk,         // system clock
    input  wire rst_n,       // active-low reset
    output reg  [7:0] level, // current fade level (0-255)
    output wire direction    // 0 = night to day, 1 = day to night
);

    reg dir;               // 0 = increasing, 1 = decreasing
    reg [19:0] counter;    // delay counter

    assign direction = dir;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            level   <= 8'd0;
            dir     <= 1'b0;
            counter <= 20'd0;
        end else begin
            counter <= counter + 1'b1;

            if (counter == 20'd0) begin
                if (!dir) begin
                    if (level < 8'd255)
                        level <= level + 1'b1;
                    else
                        dir <= 1'b1;  // reverse at peak
                end else begin
                    if (level > 8'd0)
                        level <= level - 1'b1;
                    else
                        dir <= 1'b0;  // reverse at valley
                end
            end
        end
    end

endmodule

