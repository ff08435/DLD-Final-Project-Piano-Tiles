`timescale 1ns / 1ps

module gameoverRom(
input wire [17:0] i_addr, // (17:0) or 2^18 or , need 480 x 360 = 172800
input wire i_clk2,
output reg [7:0] o_data // (7:0) 8 bit pixel value from Bee.mem
    );
(*ROM_STYLE="block"*) reg [17:0] memory_array [0:172800]; // 8 bit values for 307200 pixels of Bee (640 x 480)
initial begin
$readmemh("finalgameover.mem", memory_array);
end
always @ (posedge i_clk2)
o_data <= memory_array[i_addr];    

endmodule
