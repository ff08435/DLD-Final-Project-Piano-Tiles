`timescale 1ns / 1ps


//module random(
//    input clk,
//    output reg [1:0] rand_num
//);
////initial rand_num = 0;
////reg [20:0] count = 280;
//always @(posedge clk) begin
////    if (count == 280)begin
////        count = 0;
//        rand_num <= $random % 4;
//        end
//    count = count + 1;
//    end

//endmodule

module random(
 
  input clk,
  input rst_n,

  output reg [4:0] data
);

reg [4:0] data_next;

always @* begin
  data_next[4] = data[4]^data[1];
  data_next[3] = data[3]^data[0];
  data_next[2] = data[2]^data_next[4];
  data_next[1] = data[1]^data_next[3];
  data_next[0] = data[0]^data_next[2];
end

always @(posedge clk or negedge rst_n)
  if(rst_n)
    data <= 5'h1f;
  else
    data <= data_next;

endmodule
