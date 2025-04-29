`default_nettype none
`timescale 1ns / 1ps

module hvsync_generator (
    input wire clk_pix,        // 25.175 MHz pixel clock
    input wire rst_n,          // active low reset

    output reg [9:0] pixel_x,  // horizontal pixel position (0-799)
    output reg [9:0] pixel_y,  // vertical line position (0-524)
    output reg hsync,          // horizontal sync
    output reg vsync,          // vertical sync
    output reg video_active    // high during visible area
);

    // VGA 640x480 @60Hz Timing (pixel clock 25.175MHz)
    localparam H_VISIBLE_AREA = 640;
    localparam H_FRONT_PORCH  = 16;
    localparam H_SYNC_PULSE   = 96;
    localparam H_BACK_PORCH   = 48;
    localparam H_TOTAL        = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH; // 800

    localparam V_VISIBLE_AREA = 480;
    localparam V_FRONT_PORCH  = 10;
    localparam V_SYNC_PULSE   = 2;
    localparam V_BACK_PORCH   = 33;
    localparam V_TOTAL        = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH; // 525

    always @(posedge clk_pix or negedge rst_n) begin
        if (!rst_n) begin
            pixel_x <= 0;
            pixel_y <= 0;
        end else begin
            if (pixel_x == H_TOTAL - 1) begin
                pixel_x <= 0;
                if (pixel_y == V_TOTAL - 1)
                    pixel_y <= 0;
                else
                    pixel_y <= pixel_y + 1;
            end else begin
                pixel_x <= pixel_x + 1;
            end
        end
    end

    // Generate HSYNC signal (active low)
    always @(posedge clk_pix) begin
        hsync <= ~((pixel_x >= H_VISIBLE_AREA + H_FRONT_PORCH) &&
                   (pixel_x <  H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE));
    end

    // Generate VSYNC signal (active low)
    always @(posedge clk_pix) begin
        vsync <= ~((pixel_y >= V_VISIBLE_AREA + V_FRONT_PORCH) &&
                   (pixel_y <  V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE));
    end

    // Video active area (1 = drawing pixels)
    always @(posedge clk_pix) begin
        video_active <= (pixel_x < H_VISIBLE_AREA) && (pixel_y < V_VISIBLE_AREA);
    end

endmodule

