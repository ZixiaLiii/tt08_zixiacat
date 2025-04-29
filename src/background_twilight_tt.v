`default_nettype none
`timescale 1ns / 1ps

module background_twilight_tt (
    input  wire         clk_pix,    // pixel clock (25MHz)
    input  wire         rst_n,      // active low reset
    input  wire [9:0]   pixel_x,    // horizontal coordinate (0~639)
    input  wire [8:0]   pixel_y,    // vertical coordinate (0~479)
    input  wire [7:0]   fade_level, // fade level: 0 (night) to 255 (day)
    output reg  [11:0]  bg_colr     // output RGB444 background color
);

    // Color lookup tables
    reg [11:0] night_colors [0:15];
    reg [11:0] day_colors   [0:15];

    // Initialize night and day colors
    initial begin
        night_colors[ 0] = 12'h113;
        night_colors[ 1] = 12'h124;
        night_colors[ 2] = 12'h135;
        night_colors[ 3] = 12'h146;
        night_colors[ 4] = 12'h157;
        night_colors[ 5] = 12'h168;
        night_colors[ 6] = 12'h179;
        night_colors[ 7] = 12'h18A;
        night_colors[ 8] = 12'h19B;
        night_colors[ 9] = 12'h1AC;
        night_colors[10] = 12'h1BD;
        night_colors[11] = 12'h1CE;
        night_colors[12] = 12'h1DE;
        night_colors[13] = 12'h1ED;
        night_colors[14] = 12'h1FA;
        night_colors[15] = 12'h1FF;

        day_colors[ 0] = 12'h1AF;
        day_colors[ 1] = 12'h1BF;
        day_colors[ 2] = 12'h1CF;
        day_colors[ 3] = 12'h1DF;
        day_colors[ 4] = 12'h1EF;
        day_colors[ 5] = 12'h1F5;
        day_colors[ 6] = 12'h1FB;
        day_colors[ 7] = 12'h1FF;
        day_colors[ 8] = 12'h1F7;
        day_colors[ 9] = 12'h1DF;
        day_colors[10] = 12'h1CF;
        day_colors[11] = 12'h1BF;
        day_colors[12] = 12'h1AF;
        day_colors[13] = 12'h19F;
        day_colors[14] = 12'h18F;
        day_colors[15] = 12'h17F;
    end

    // Band selection: divide 480 lines into 16 bands (~30 lines each)
    wire [3:0] band;
    assign band = pixel_y[8:5];  // simple division by 32 (approx 16 bands)

    // Temporary registers for blended color
    reg [7:0] r_blend;
    reg [7:0] g_blend;
    reg [7:0] b_blend;

    // Blend logic
    always @(*) begin
        if (pixel_y >= 9'd320) begin
            // ground (green color)
            bg_colr = 12'h0C0;
        end else begin
            r_blend = ((night_colors[band][11:8] * (8'd255 - fade_level)) + (day_colors[band][11:8] * fade_level)) >> 8;
            g_blend = ((night_colors[band][7:4]  * (8'd255 - fade_level)) + (day_colors[band][7:4]  * fade_level)) >> 8;
            b_blend = ((night_colors[band][3:0]  * (8'd255 - fade_level)) + (day_colors[band][3:0]  * fade_level)) >> 8;
            bg_colr = {r_blend[3:0], g_blend[3:0], b_blend[3:0]};
        end
    end

endmodule


