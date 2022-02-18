`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2021 02:46:34 PM
// Design Name: 
// Module Name: mux_p
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


module mux_p(i0,i1,s,q);


parameter BUS_WIDTH = 5; 	//Default BusWidth

input [BUS_WIDTH-1:0]i0;	//Inputs
input [BUS_WIDTH-1:0]i1;	
input s;					//Select Lines
output [BUS_WIDTH-1:0]q;	//Output

assign q = (s==0) ? i0:i1;	//logic of mux

endmodule
