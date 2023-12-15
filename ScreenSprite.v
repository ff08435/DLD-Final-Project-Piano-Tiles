`timescale 1ns / 1ps

module ScreenSprite(
input wire i_clk,
input wire i_rst,
input wire [9:0] xx,
input wire [9:0] yy,
input wire aactive,
output reg BSpriteOn,
output reg GSpriteOn,
output wire [7:0] dout,
output wire [7:0] gout
    );
    
reg [16:0] baddress; // (16:0) or 2^17 or 131072, need 471 x 250 = 117750
reg [17:0] gaddress;
ScreenRom BeeVRom (.i_addr(baddress),.i_clk2(i_clk),.o_data(dout));
gameoverRom grom (gaddress,i_clk,gout);
// setup character positons and sizes
reg [16:0] BeeX = 80; // Bee X start position
reg [16:0] BeeY = 112; // Bee Y start position
reg [16:0] GX = 80; // Bee X start position
reg [16:0] GY = 60;
localparam BeeWidth = 471; // Bee width in pixels
localparam BeeHeight = 250;
localparam GWidth = 480; // Bee width in pixels
localparam GHeight = 360; // Bee height in pixels
// check if xx,yy are within the confines of the Bee character
always @ (posedge i_clk)
    begin
    if (aactive)
        begin
        if (xx==BeeX-1 && yy==BeeY)
            begin
            baddress <= 0;
            BSpriteOn <=1;
            end
        if ((xx>BeeX-1) && (xx<BeeX+BeeWidth) && (yy>BeeY-1) && (yy<BeeY+BeeHeight))
            begin
            baddress <= (xx-BeeX) + ((yy-BeeY)*BeeWidth);
            BSpriteOn <=1;
            end
        else BSpriteOn <=0;
        
        
        if (xx==GX-1 && yy==GY)
            begin
            gaddress <= 0;
            GSpriteOn <=1;
            end
        if ((xx>GX-1) && (xx<GX+GWidth) && (yy>GY-1) && (yy<GY+GHeight))
            begin
            gaddress <= (xx-GX) + ((yy-GY)*GWidth);
            GSpriteOn <=1;
            end
        else GSpriteOn <=0;
        
    end
end

endmodule
