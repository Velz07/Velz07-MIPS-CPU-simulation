`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2021 03:06:50 PM
// Design Name: 
// Module Name: SignExtend
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


module SignExtend(in,out,SignExtend_ctrl);			//input output and sigex_ctrl logic from ctrl unit

parameter BUS_WIDTH = 16;							//default parameter of 16

input [BUS_WIDTH-1:0]in;							//input
input SignExtend_ctrl;
output [31:0]out;


//signextend MSB and pad it - based on ctrl logic
assign out = (SignExtend_ctrl) ? { {(32-BUS_WIDTH){in[BUS_WIDTH-1]}} ,in} :  { {(32-BUS_WIDTH){1'b0}} ,in}; 

endmodule
