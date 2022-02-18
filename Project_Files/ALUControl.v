`timescale 1ns / 1ps

//Define ALU FuncCodes
`define SLLFunc 6'b000000
`define SRLFunc 6'b000010
`define SRAFunc 6'b000011
`define ADDFunc 6'b100000
`define ADDUFunc 6'b100001
`define SUBFunc 6'b100010
`define SUBUFunc 6'b100011
`define ANDFunc 6'b100100
`define ORFunc 6'b100101
`define XORFunc 6'b100110
`define NORFunc 6'b100111
`define SLTFunc 6'b101010
`define SLTUFunc 6'b101011

module ALUControl(ALUCtrl, ALUop, FuncCode,SLL_ctrl);

                                //Input ALUop and FuncCode from Instruction
input [3:0]ALUop;
input [5:0]FuncCode;

                                //Output ALUCtrl
output reg [3:0]ALUCtrl;
output  SLL_ctrl;

assign SLL_ctrl = (ALUop == 4'b1111 && (FuncCode==`SLLFunc ||FuncCode==`SRLFunc || FuncCode==`SRAFunc)) ? 1'b1:1'b0;
always@(*)
begin

                                //Check if ALUop is all 1's
if(ALUop == 4'b1111)


case(FuncCode)

                                //Mapping b/w FuncCode and ALUCtrl outputs
`SLLFunc:  ALUCtrl <= 4'b0011;
`SRLFunc: ALUCtrl <= 4'b0100;
`SRAFunc: ALUCtrl <= 4'b1101;
`ADDFunc: ALUCtrl <= 4'b0010;
`ADDUFunc: ALUCtrl <= 4'b1000;
`SUBFunc: ALUCtrl <= 4'b0110;
`SUBUFunc: ALUCtrl <= 4'b1001;
`ANDFunc: ALUCtrl <= 4'b0000;
`ORFunc: ALUCtrl <= 4'b0001;
`XORFunc: ALUCtrl <= 4'b1010;
`NORFunc: ALUCtrl <= 4'b1100;
`SLTFunc: ALUCtrl <= 4'b0111;
`SLTUFunc: ALUCtrl <= 4'b1011;
default: ALUCtrl <= 0;
endcase

else
                                //Output ALUCtrl as ALUop directly
ALUCtrl <= ALUop;   


end


endmodule
