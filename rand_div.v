`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2023 06:16:38 PM
// Design Name: 
// Module Name: rand_div
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


module rand_div(
//input clk,
//input rst,
input [4:0] rand,
output [2:0] num
    );
//always @(posedge clk) begin
   
assign num = rand % 4;
//end
    
endmodule

