`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2021 01:25:26 PM
// Design Name: 
// Module Name: SingleCycleProc
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


module SingleCycleProc(CLK,Reset_L,startPC,dMemOut);


	input CLK;
	input Reset_L;
	input [31:0] startPC;
	
	// Outputs
	output [31:0] dMemOut;
	

//instruction
reg [31:0]PC;
wire [31:0]instruction;
 
//read buses BusA,BusB and BusW
wire RegWr;
wire [31:0]BusA;
wire [31:0]BusB;
wire [31:0]BusW;

wire [4:0]RW; //register write data

wire [31:0]BusB_mux;
wire [31:0]BusB_alu;
wire [31:0]BusW_alu; // Mux at ALU
wire [31:0]BusA_alu;   //SLL adjustment
wire [31:0]SLL_sham;

//Ctrl Unit signals
wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignExtend_ctrl,SLL_ctrl;
wire [3:0]ALUOp;

//Zero from ALU
wire Zero;
wire [3:0]ALUCtrl;

//Data memory signals
wire [31:0]ReadData;
wire [31:0]Address;
wire [31:0]WriteData;

//PC_calc
reg [31:0]PC_calc;

//PCnex
reg [31:0]PCnext;

//PC_16 for BEQ and PC_26 for Jump
reg [31:0]PC_16;
reg [31:0]PC_26;


wire [31:0]PC_mux1_out;
wire [31:0]PC_mux2_out;

wire PC_mux1_sel;

//Reset the PC logic
always@(negedge Reset_L or negedge CLK)
begin

if(Reset_L ==0)
PC <= startPC;
else
PC <=PC_mux2_out;
end


//PC update logic
always@(*)
begin

PCnext <= PC + 4; 
PC_16 <= PCnext + (BusB_mux<<2);
PC_26 <= {PCnext[31:28],({{2{1'b0}},instruction[25:0]}<<2)};

 
end

//pc_mux1_select line
and(PC_mux1_sel,Branch,Zero);


//Parameterized MUX instantiations
mux_p #(.BUS_WIDTH(32)) PC_mux1(.i0(PCnext),.i1(PC_16),.s(PC_mux1_sel),.q(PC_mux1_out));

mux_p #(.BUS_WIDTH(32)) PC_mux2(.i0(PC_mux1_out),.i1(PC_26),.s(Jump),.q(PC_mux2_out)); 



//Control Unit instantiation
SingleCycleControl main_ctrl_unit(
.RegDst(RegDst), .ALUSrc(ALUSrc), .MemToReg(MemToReg), .RegWrite(RegWrite), .MemRead(MemRead),
 .MemWrite(MemWrite), .Branch(Branch), .Jump(Jump), .SignExtend(SignExtend_ctrl), .ALUOp(ALUOp), .Opcode(instruction[31:26]));




//InstructionMemory instantiation
InstructionMemory IM(.Data(instruction), .Address(PC));

//i0,i1,s,q
mux_p #(.BUS_WIDTH(5)) mux1(.i0(instruction[20:16]),.i1(instruction[15:11]),.s(RegDst),.q(RW));

//(BusA,BusB,BusW,RA,RB,RW,RegWr,Clk);
RegisterFile Main_Register  (.BusA(BusA),.BusB(BusB),.BusW(BusW),.RA(instruction[25:21]),.RB(instruction[20:16]),.RW(RW),.RegWr(RegWrite),.Clk(CLK));

//SignExtend
//in,out
SignExtend se(.in(instruction[15:0]),.out(BusB_mux),.SignExtend_ctrl(SignExtend_ctrl));

//i0,i1,s,q
mux_p #(.BUS_WIDTH(32)) mux2(.i0(BusB),.i1(BusB_mux),.s(ALUSrc),.q(BusB_alu));


//adjustment SLL
//i0,i1,s,q
mux_p #(.BUS_WIDTH(32)) mux_SLL(.i0(BusA),.i1(SLL_sham),.s(SLL_ctrl),.q(BusA_alu));


//SignExtend
SignExtend #(.BUS_WIDTH(5)) SE_SLL(.in(instruction[10:6]),.out(SLL_sham),.SignExtend_ctrl(1'b0));



//(BusW, Zero, BusA, BusB, ALUCtrl)
ALU alu_main(.BusW(BusW_alu), .Zero(Zero), .BusA(BusA_alu), .BusB(BusB_alu), .ALUCtrl(ALUCtrl));

//ALUCtrl, ALUop, FuncCode
ALUControl alu_cntrl(.ALUCtrl(ALUCtrl), .ALUop(ALUOp), .FuncCode(instruction[5:0]),.SLL_ctrl(SLL_ctrl));


//DataMemory
DataMemory dm(.ReadData(ReadData),.Address(BusW_alu[5:0]),.WriteData(BusB),.MemoryRead(MemRead),.MemoryWrite(MemWrite),.Clock(CLK));


//mux after dm
//i0,i1,s,q
mux_p #(.BUS_WIDTH(32)) mux_dm_to_reg(.i0(BusW_alu),.i1(ReadData),.s(MemToReg),.q(BusW));

//dMemOut_ReadData
assign dMemOut = ReadData; 


endmodule
