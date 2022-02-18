`timescale 1ns / 1ps

module RegisterFile(BusA,BusB,BusW,RA,RB,RW,RegWr,Clk);

//output bus declarations
output  [31:0]BusA;
output  [31:0]BusB;
input  [31:0]BusW;

//input bus declarations
input [4:0]RA;
input [4:0]RB;
input [4:0]RW;

input RegWr,Clk;


//internal memory register
reg [31:0]reg_mem[31:0];



assign BusA = reg_mem[RA];
assign BusB = reg_mem[RB];

//always @(RA,RB)
initial
begin
//always assign first register to 0
    reg_mem[0]=0;
end

//at negedge of Clk write operation
always @(negedge Clk)
    if(RegWr==1 && RW !=0)
        begin
        reg_mem[RW] <= BusW;
        end


endmodule
