`default_nettype none
`timescale 1ns / 1ps

module sprite_cat_tt (
    input  wire clk_pix,
    input  wire rst_pix,
    input  wire [9:0] sx,
    input  wire [8:0] sy,
    output reg  [2:0] rgb,
    output reg  drawing
);

    reg [3:0] cat_pixel;
    wire [5:0] x_rel;
    wire [4:0] y_rel;
    wire hit;

    assign hit = (sx >= 272) && (sx < 304) && (sy >= 220) && (sy < 240);
    assign x_rel = sx - 272;
    assign y_rel = sy - 220;

    always @(*) begin
        cat_pixel = 4'd6; // default: transparent
        if (hit) begin
            case (y_rel)
                5'd0: begin
                    case (x_rel)
                        6'd6, 6'd15, 6'd23: cat_pixel = 4'd5;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd1: begin
                    case (x_rel)
                        6'd5,6'd7,6'd14,6'd16,6'd22,6'd24: cat_pixel = 4'd5;
                        6'd6,6'd15,6'd23: cat_pixel = 4'd1;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd2: begin
                    case (x_rel)
                        6'd5,6'd7,6'd8,6'd9,6'd10,6'd11,6'd12,6'd13,
                        6'd14,6'd16,6'd17,6'd18,6'd19,6'd20,6'd21,6'd22: cat_pixel = 4'd5;
                        6'd6,6'd15,6'd23: cat_pixel = 4'd0;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd3: begin
                    case (x_rel)
                        6'd5,6'd6,6'd7,6'd8,6'd9,6'd10,6'd11,6'd12,6'd13,
                        6'd14,6'd15,6'd16,6'd17,6'd18,6'd19,6'd20,6'd21: cat_pixel = 4'd5;
                        6'd22: cat_pixel = 4'd0;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd4: begin
                    case (x_rel)
                        6'd5,6'd6,6'd8,6'd9,6'd10,6'd11,6'd12,6'd13,6'd14,
                        6'd15,6'd16,6'd17,6'd18,6'd19,6'd20,6'd21: cat_pixel = 4'd5;
                        6'd7,6'd22: cat_pixel = 4'd0;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd5: begin
                    case (x_rel)
                        6'd5,6'd6,6'd7,6'd8,6'd10,6'd11,6'd12,6'd13,6'd14,
                        6'd15,6'd16,6'd17,6'd18,6'd19,6'd20: cat_pixel = 4'd5;
                        6'd9,6'd21: cat_pixel = 4'd0;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd6: begin
                    case (x_rel)
                        6'd5,6'd6,6'd7,6'd10,6'd11,6'd13,6'd14,6'd15,
                        6'd16,6'd17,6'd18,6'd19: cat_pixel = 4'd5;
                        6'd8,6'd12,6'd20: cat_pixel = 4'd0;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd7: begin
                    case (x_rel)
                        6'd5,6'd6,6'd7,6'd8,6'd9,6'd10,6'd11,6'd12,6'd13,6'd14,6'd15,
                        6'd16,6'd17,6'd18: cat_pixel = 4'd5;
                        6'd19: cat_pixel = 4'd0;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd8: begin
                    case (x_rel)
                        6'd6,6'd7,6'd8,6'd9,6'd10,6'd11,6'd12,6'd13,6'd14,
                        6'd15,6'd16,6'd17: cat_pixel = 4'd5;
                        6'd5,6'd18: cat_pixel = 4'd0;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                5'd9: begin
                    case (x_rel)
                        6'd7,6'd8,6'd9,6'd10,6'd11,6'd12,6'd13,6'd14,6'd15: cat_pixel = 4'd5;
                        6'd6,6'd16: cat_pixel = 4'd0;
                        default: cat_pixel = 4'd6;
                    endcase
                end
                default: cat_pixel = 4'd6;
            endcase
        end else begin
            cat_pixel = 4'd6;
        end
    end

    always @(*) begin
        case (cat_pixel)
            4'd0: rgb = 3'b100; // 红
            4'd1: rgb = 3'b110; // 黄
            4'd2: rgb = 3'b111; // 白
            4'd3: rgb = 3'b101; // 粉
            4'd4: rgb = 3'b001; // 紫
            4'd5: rgb = 3'b000; // 黑
            4'd6: rgb = 3'b000; // 透明=黑
            default: rgb = 3'b000;
        endcase
    end

endmodule

