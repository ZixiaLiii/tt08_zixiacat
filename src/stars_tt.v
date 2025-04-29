`default_nettype none
`timescale 1ns / 1ps

module stars_tt #(
    parameter XW = 10,       // 水平坐标位宽
    parameter YW = 9,        // 垂直坐标位宽
    parameter COLRW = 12     // RGB颜色宽度（默认 4:4:4）
)(
    input  wire              clk_pix,      // 像素时钟
    input  wire              rst_n,        // 低电平复位
    input  wire [XW-1:0]     pixel_x,      // 当前水平像素位置
    input  wire [YW-1:0]     pixel_y,      // 当前垂直像素位置
    input  wire [7:0]        fade_level,   // 淡入淡出程度（控制昼夜）
    input  wire [15:0]       frame_count,  // 帧计数器（用于星星闪烁节奏）
    output reg  [COLRW-1:0]  star_colr     // 星星颜色输出（白色或黑）
);

    // 夜晚判断：fade_level 小于 64 或大于 208
    wire is_night = (fade_level < 8'd64) || (fade_level > 8'd208);

    // 星星闪烁节奏：frame_count bit4 控制每 16 帧翻转一次
    wire blink = frame_count[4];

    // 恒定星星位置（12颗）
    wire [XW-1:0] star_x[0:11];
    wire [YW-1:0] star_y[0:11];

    assign star_x[ 0] = 10'd80;   assign star_y[ 0] = 9'd40;
    assign star_x[ 1] = 10'd140;  assign star_y[ 1] = 9'd60;
    assign star_x[ 2] = 10'd200;  assign star_y[ 2] = 9'd90;
    assign star_x[ 3] = 10'd260;  assign star_y[ 3] = 9'd30;
    assign star_x[ 4] = 10'd320;  assign star_y[ 4] = 9'd55;
    assign star_x[ 5] = 10'd380;  assign star_y[ 5] = 9'd75;
    assign star_x[ 6] = 10'd440;  assign star_y[ 6] = 9'd35;
    assign star_x[ 7] = 10'd500;  assign star_y[ 7] = 9'd65;
    assign star_x[ 8] = 10'd560;  assign star_y[ 8] = 9'd50;
    assign star_x[ 9] = 10'd600;  assign star_y[ 9] = 9'd85;
    assign star_x[10] = 10'd180;  assign star_y[10] = 9'd40;
    assign star_x[11] = 10'd420;  assign star_y[11] = 9'd70;

    // 主逻辑：夜晚时，绘制 2x2 白点作为星星
    integer i;
    always @(*) begin
        star_colr = 12'h000;  // 默认黑色
        if (is_night && blink) begin
            for (i = 0; i < 12; i = i + 1) begin
                if ((pixel_x >= star_x[i] && pixel_x <= star_x[i] + 1) &&
                    (pixel_y >= star_y[i] && pixel_y <= star_y[i] + 1)) begin
                    star_colr = 12'hFFF;  // 白色星星
                end
            end
        end
    end

endmodule

