`default_nettype none
`timescale 1ns / 1ps

module simple_audio_tt (
    input  wire clk,          // global clock (25 MHz)
    input  wire rst_n,        // active low reset
    output wire aud_pwm       // PWM audio output
);

    // === Internal Signals ===
    reg [31:0] freq_div;
    reg [7:0] melody_index;
    reg [5:0] note_code;
    reg silent;

    reg [31:0] cnt;
    reg [31:0] beat_cnt;
    reg pwm_r;

    assign aud_pwm = pwm_r;

    // === 音符频率表 ===
    always @(*) begin
        if (silent) begin
            freq_div = 32'd0;
        end else begin
            case (note_code)
                6'd1: freq_div = 191113;   // C4
                6'd2: freq_div = 170262;   // D4
                6'd3: freq_div = 151686;   // E4
                6'd4: freq_div = 143173;   // F4
                6'd5: freq_div = 127551;   // G4
                6'd6: freq_div = 113636;   // A4
                6'd7: freq_div = 101239;   // B4
                6'd8: freq_div =  95556;   // C5
                default: freq_div = 32'd0;
            endcase
        end
    end

    // === 欢乐颂旋律 ===
    always @(*) begin
        case (melody_index)
            8'd0 : begin note_code = 6'd3; silent = 0; end
            8'd1 : begin note_code = 6'd3; silent = 0; end
            8'd2 : begin note_code = 6'd4; silent = 0; end
            8'd3 : begin note_code = 6'd5; silent = 0; end
            8'd4 : begin note_code = 6'd5; silent = 0; end
            8'd5 : begin note_code = 6'd4; silent = 0; end
            8'd6 : begin note_code = 6'd3; silent = 0; end
            8'd7 : begin note_code = 6'd2; silent = 0; end
            8'd8 : begin note_code = 6'd1; silent = 0; end
            8'd9 : begin note_code = 6'd1; silent = 0; end
            8'd10: begin note_code = 6'd2; silent = 0; end
            8'd11: begin note_code = 6'd3; silent = 0; end
            8'd12: begin note_code = 6'd3; silent = 0; end
            8'd13: begin note_code = 6'd2; silent = 0; end
            8'd14: begin note_code = 6'd2; silent = 0; end
            8'd15: begin note_code = 6'd0; silent = 1; end
            // 后面省略，和你之前一样
            default: begin note_code = 6'd0; silent = 1; end
        endcase
    end

    // === PWM生成器 ===
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 32'd0;
            pwm_r <= 1'b0;
        end else begin
            if (freq_div == 32'd0) begin
                pwm_r <= 1'b0;
                cnt <= 32'd0;
            end else begin
                if (cnt >= freq_div) begin
                    cnt <= 32'd0;
                    pwm_r <= ~pwm_r;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

    // === 节奏控制器 ===
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            beat_cnt <= 32'd0;
            melody_index <= 8'd0;
        end else begin
            if (beat_cnt >= 24_000_000) begin // 约0.4秒，按25MHz时钟
                beat_cnt <= 32'd0;
                if (melody_index == 8'd63)
                    melody_index <= 8'd0;
                else
                    melody_index <= melody_index + 1'b1;
            end else begin
                beat_cnt <= beat_cnt + 1'b1;
            end
        end
    end

endmodule

