`timescale 1ns / 1ps


module clock(clk,clk_d);
parameter div_value=1;
input clk;
output clk_d;
    reg clk_d;
    reg count;
    initial
        begin
        clk_d=0;
        count=0;
    end
    always @(posedge clk)
        begin
            if (count == div_value)
                count <= 0;
            else
                count<=count+1;
        end
        
        always @ (posedge clk)
            begin
                if (count == div_value)
                    clk_d<= ~ clk_d;
            end
endmodule

module h_counter(clk,count,trig);
input clk;
output [9:0] count;
output trig;
reg [9:0] count;
reg trig;
initial count = 0;
initial trig = 0;
always @ (posedge clk)
    begin
        if (count < 799)
             
            begin
                trig <= 0;
                count <= count + 1;
            end
        else
            begin
                count <= 0;
                trig = 1;
            end
    end
endmodule

module count_v(clk,enable_v,v_count);

input clk;
input enable_v;
output [9:0] v_count;
reg [9:0] v_count;
initial v_count = 0;
always @ (posedge clk)
    begin
        if (enable_v == 1)
        begin
            if (v_count < 524) 
                 
                begin
                    v_count <= v_count + 1;
                end
            else
                begin
                    v_count <= 0;
                end
        end
    end
endmodule



module vga_sync(
    input [9:0] h_count,
    input [9:0] v_count,
    output h_sync,
    output v_sync,
    output video_on,
    output [9:0] x_loc,
    output [9:0] y_loc
    );
    
    //horizontal
    localparam HD = 640;
    localparam HF = 16;
    localparam HB = 48;
    localparam HR = 96;
    
    //vertical
    localparam VD = 480;
    localparam VF = 10;
    localparam VB = 33;
    localparam VR = 2;
    
    assign h_sync = h_count<(HD+HF)||h_count>(HD+HF+HR);
    assign v_sync = v_count < (VD+VF) | v_count > (VD+VF+VR);
    assign video_on = h_count < HD;
    assign x_loc = h_count;
    assign y_loc = v_count; 
    
   endmodule


module digits(
input [9:0] num,
output [3:0] ones,
output [3:0] tens,
output [3:0] hundreds,
output [3:0] thousand
    );
    assign thousand = num/1000;
    assign hundreds = (num%1000)/100;
    assign tens = ((num%1000)%100)/10;
    assign ones = (((num%1000)%100)%10);
    
    
endmodule


module seg7_control(
    input clk_100MHz,
    input reset,
    input [3:0] ones,
    input [3:0] tens,
    input [3:0] hundreds,
    input [3:0] thousands,
    output reg [0:6] seg,       // segment pattern 0-9
    output reg [3:0] digit      // digit select signals
    );
    
    // Parameters for segment patterns
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2 
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9
    
    // To select each digit in turn
    reg [1:0] digit_select;     // 2 bit counter for selecting each of 4 digits
    reg [16:0] digit_timer;     // counter for digit refresh
    
    // Logic for controlling digit select and digit timer
    always @(posedge clk_100MHz or posedge reset) begin
        if(reset) begin
            digit_select <= 0;
            digit_timer <= 0; 
        end
        else                                        // 1ms x 4 displays = 4ms refresh period
            if(digit_timer == 99_999) begin         // The period of 100MHz clock is 10ns (1/100,000,000 seconds)
                digit_timer <= 0;                   // 10ns x 100,000 = 1ms
                digit_select <=  digit_select + 1;
            end
            else
                digit_timer <=  digit_timer + 1;
    end
    
    // Logic for driving the 4 bit anode output based on digit select
    always @(digit_select) begin
        case(digit_select) 
            2'b00 : digit = 4'b1110;   // Turn on ones digit
            2'b01 : digit = 4'b1101;   // Turn on tens digit
            2'b10 : digit = 4'b1011;   // Turn on hundreds digit
            2'b11 : digit = 4'b0111;   // Turn on thousands digit
        endcase
    end
    
    // Logic for driving segments based on which digit is selected and the value of each digit
    always @*
        case(digit_select)
            2'b00 : begin       // ONES DIGIT
                        case(ones)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
                    
            2'b01 : begin       // TENS DIGIT
                        case(tens)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
                    
            2'b10 : begin       // HUNDREDS DIGIT
                        case(hundreds)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
                    
            2'b11 : begin       // MINUTES ONES DIGIT
                        case(thousands)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
        endcase

endmodule
