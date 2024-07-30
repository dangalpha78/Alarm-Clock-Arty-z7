`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2023 10:01:06 AM
// Design Name: 
// Module Name: clock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock(
input clk,
input reset, 
input [1:0] btn,
input setclk_reset,
input [1:0]sw,

output wire [0:6] seg0, 
output wire [4:1] select,
output wire [0:6] seg1,
output wire [4:1] select1,
output reg led,
output reg led4_b,
output reg led5_b
);

reg [30:0] count;
reg [30:0] set_count;
reg [5:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

reg [5:0] set_hours;
reg [5:0] set_minutes;


DisplaySegment trai(.clk(clk),.hour(hours),.min(minutes),.dig(seg0),.select(select));
DisplaySegment phai(.clk(clk),.hour(set_hours),.min(set_minutes),.dig(seg1),.select(select1));


/*********clock 1**************/
always@(posedge clk)
begin
    if (reset) begin
        seconds <=0 ;
        minutes <= 0;
        hours <= 0;
        count <= 0;
    end
    else begin
    if (count == 125000000)
    begin
    count <= 0;
    led <= ~led;
        if (seconds == 6'd59) begin
            seconds <= 0;
            if(minutes == 6'd59) begin
                minutes <= 0;
                if(hours == 6'd23) begin
                    hours <= 0;
                    
                end
                else hours <= hours + 1;
            end
            else minutes <= minutes + 1;
        end
        else seconds <= seconds + 1;
    end
    else count <= count + 1;
    
    if (sw == 2'b01) begin
        if (minutes == set_minutes && hours == set_hours)
            begin
            led4_b <= 1'b1;
            led5_b <= 1'b1;
            end
        else
            begin
            led4_b <= 1'b0;
            led5_b <= 1'b0;
            end 
    end
    else if(sw == 2'b10) begin
        hours <= set_hours;
        minutes<=set_minutes;
    end
    else begin
        led4_b <= 1'b0;
        led5_b <= 1'b0;
    end
    end
end
/***************het clock1*******************/
always @(posedge clk)
begin
    if(setclk_reset) begin
        set_minutes <= 0;
        set_hours <= 0;
    end
    else begin
        case(btn)
        2'b10:
        begin
            set_count <= set_count + 1;
            if (set_count == 62500000) begin
                if (set_hours == 6'd23) set_hours <= 6'd0; 
                else set_hours <= set_hours + 1;
                set_count <= 0;
            end
        end
        2'b01:
        begin
            set_count <= set_count + 1;
            if (set_count == 62500000)
            begin
                if (set_minutes == 6'd50) begin
                    set_minutes <= 0;
                    set_hours <= set_hours + 1;
                end
                else set_minutes <= set_minutes + 6'd10;
                set_count <= 0;
            end
        end
        default: set_count <= 0;
        endcase
    end
end
endmodule
