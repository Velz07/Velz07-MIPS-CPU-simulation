`timescale 1ns / 1ps

module DataMemory(ReadData,Address,WriteData,MemoryRead,MemoryWrite,Clock);

//bus declarations
input [31:0]WriteData;
output reg [31:0]ReadData;

input [5:0]Address;

input MemoryRead,MemoryWrite,Clock;

//internal data memory 4 chips each is the plan
reg [31:0]data_mem[63:0];

//read posedge
always @(posedge Clock)
begin
if(MemoryRead==1)
    ReadData <= data_mem[Address];
end

//write at negedge
always @(negedge Clock)
begin
if(MemoryWrite == 1)
    data_mem[Address]<=WriteData;

end



endmodule
