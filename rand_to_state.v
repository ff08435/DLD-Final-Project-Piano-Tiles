`timescale 1ns / 1ps

module rand_to_state(
input clk,
input [2:0] ran,
output reg [3:0] state,
output reg state_change,
output reg [25:0] check
    );
reg [25:0] count = 25000000;

initial state_change= 0;
always @(posedge clk)begin
state_change = 0;
check <= count;
if (count==25000000) begin
    count = 0;
    state_change = 1;
    if (ran == 3'b000)
        begin
        state <= 4'b1000;
        end 
    else if (ran == 3'b001)
        begin
        state <= 4'b0100;
        end
    else if (ran == 3'b010)
        begin
        state <= 4'b0010;
        end
    else if (ran == 3'b011)
        begin
        state <= 4'b0001;
        end
        
        
  //COMMENT    
        
//    else if (ran == 3'b100)
//        begin
//        state <= 4'b0001;
//        end
//    else state <= 4'b1111;
//TILL

    end
 count = count + 1;
 
 end
endmodule
