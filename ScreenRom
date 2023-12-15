`timescale 1ns / 1ps

module ScreenRom(
input wire [16:0] i_addr, // (16:0) or 2^17 or 131072, need 471 x 250 = 117750
input wire i_clk2,
output reg [7:0] o_data // (7:0) 8 bit pixel value from Bee.mem
);
(*ROM_STYLE="block"*) reg [16:0] memory_array [0:117750]; // 8 bit values for 307200 pixels of Bee (640 x 480)
initial begin
$readmemh("screen.mem", memory_array);
end
always @ (posedge i_clk2)
o_data <= memory_array[i_addr];
endmodule
