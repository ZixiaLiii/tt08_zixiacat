`default_nettype none
`timescale 1ns / 1ps

module sunrise_tt (
    input wire        clk,
    input wire        rst_n,
    input wire [9:0]  pixel_x,
    input wire [8:0]  pixel_y,
    input wire [7:0]  fade_level,
    output reg [11:0] sun_rgb
);

    localparam [11:0] COLOR_SUN = 12'hFF0;  // 亮黄色
    localparam [9:0]  RADIUS = 24;

    reg [9:0] sun_x;
    reg [8:0] sun_y;

    wire signed [11:0] dx = pixel_x - sun_x;
    wire signed [11:0] dy = pixel_y - sun_y;
    wire [23:0] dist2 = dx * dx + dy * dy;

    always @(*) begin
        // 太阳移动轨迹逻辑
        if (fade_level <= 8'd63 || fade_level > 8'd255) begin
            sun_x = 10'd0;
            sun_y = 9'd500; // 屏幕外
        end else if (fade_level <= 8'd112) begin
            sun_x = 640 - ((fade_level - 8'd64) * 80 / (112 - 64));
            sun_y = 310 - ((fade_level - 8'd64) * 210 / (112 - 64));
        end else if (fade_level <= 8'd238) begin
            sun_x = 560 - ((fade_level - 8'd113) * 400 / (238 - 113));
            sun_y = 100;
        end else begin
            sun_x = 160 - ((fade_level - 8'd239) * 80 / (255 - 239));
            sun_y = 100 + ((fade_level - 8'd239) * 210 / (255 - 239));
        end
    end

    always @(*) begin
        if (sun_y < 9'd480 && dist2 <= (RADIUS * RADIUS))
            sun_rgb = COLOR_SUN;
        else
            sun_rgb = 12'h000;
    end

endmodule

