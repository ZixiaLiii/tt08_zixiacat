`default_nettype none
`timescale 1ns / 1ps

module tt_um_ZixiaLiii (
    input  wire        clk,       // global clock (25 MHz)
    input  wire        rst_n,     // active low reset
    input  wire [7:0]  ui_in,     // unused
    output wire [7:0]  uo_out,    // outputs (VGA+Audio)
    input  wire [7:0]  uio_in,    // unused
    output wire [7:0]  uio_out,   // unused
    output wire [7:0]  uio_oe     // unused
);

    // === Wire declarations ===
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire video_active;
    wire hsync;
    wire vsync;

    wire [3:0] vga_r;
    wire [3:0] vga_g;
    wire [3:0] vga_b;

    wire aud_pwm;

    // === Horizontal and Vertical Sync Generator ===
    hvsync_generator hvsync_inst (
        .clk_pix(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .hsync(hsync),
        .vsync(vsync),
        .video_active(video_active)
    );

    // === Fade Level Generator ===
    wire [7:0] fade_level;
    fade_level_generator_tt fade_inst (
        .clk(clk),
        .rst_n(rst_n),
        .fade_level(fade_level)
    );

    // === Background Generator (Twilight Sky) ===
    wire [11:0] bg_rgb;
    background_twilight_tt bg_inst (
        .clk_pix(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y[8:0]),
        .fade_level(fade_level),
        .bg_colr(bg_rgb)
    );

    // === Stars Generator ===
    wire [11:0] star_rgb;
    stars_tt stars_inst (
        .clk_pix(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .frame_count({8'd0, fade_level}),
        .fade_level(fade_level),
        .star_rgb(star_rgb)
    );

    // === Sunrise Generator ===
    wire [11:0] sun_rgb;
    sunrise_tt sunrise_inst (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y[8:0]),
        .fade_level(fade_level),
        .sun_rgb(sun_rgb)
    );

    // === Sprite (Pixel Cat) ===
    wire [11:0] spr_rgb;
    wire drawing;

    sprite_cat_tt sprite_inst (
        .clk_pix(clk),
        .rst_n(rst_n),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .drawing(drawing),
        .spr_colr(spr_rgb)
    );

    // === Audio Generator ===
    simple_audio_tt audio_inst (
        .clk(clk),
        .rst_n(rst_n),
        .aud_pwm(aud_pwm)
    );

    // === Final RGB Composition ===
    wire [11:0] final_rgb;

    assign final_rgb = (drawing && video_active) ? spr_rgb :
                       (sun_rgb != 12'd0 && video_active) ? sun_rgb :
                       (star_rgb != 12'd0 && video_active) ? star_rgb :
                       (video_active) ? bg_rgb : 12'd0;

    assign vga_r = final_rgb[11:8];
    assign vga_g = final_rgb[7:4];
    assign vga_b = final_rgb[3:0];

    // === Mapping to uo_out ===
    assign uo_out = {
        aud_pwm,        // [7] - Audio PWM
        vga_r[3],       // [6] - VGA Red MSB
        vga_g[3],       // [5] - VGA Green MSB
        vga_b[3],       // [4] - VGA Blue MSB
        vsync,          // [3] - VGA VSYNC
        hsync,          // [2] - VGA HSYNC
        2'b00           // [1:0] - unused
    };

    assign uio_out = 8'h00;
    assign uio_oe  = 8'h00;

endmodule


