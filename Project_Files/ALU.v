`timescale 1ns / 1ps


// We define the directives for different operations
`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define SLL 4'b0011
`define SRL 4'b0100
`define SUB 4'b0110
`define SLT 4'b0111
`define ADDU 4'b1000
`define SUBU 4'b1001
`define XOR 4'b1010
`define SLTU 4'b1011
`define NOR 4'b1100
`define SRA 4'b1101
`define LUI 4'b1110
module ALU(BusW, Zero, BusA, BusB, ALUCtrl);
    
input wire [31:0] BusA, BusB;			//input buses - specific to read operation
output reg [31:0] BusW;					// output bus - specific to write operation
input wire [3:0] ALUCtrl ;				// ALUctrl signal from ALU Control unit
output wire Zero ;						// Checif is ALU is zero or not output


wire less;							
wire [63:0] Bus64;						
assign Zero = (BusW==0) ? 1:0;					//Zero logic

assign less = ( ({1'b0,BusA} < {1'b0,BusB} ) ? 1'b1 : 1'b0);  	// check if less than or not SLT instructions

//assign Bus64 = {BusA,BusW};
always@(*)begin	
	
	case (ALUCtrl)   //operation definitions
	`AND:   BusW <=  BusA & BusB;      
	`OR:    BusW <=  BusA | BusB;
	`ADD:   BusW <=  BusA + BusB;
	`ADDU:  BusW <=  BusA + BusB;              
	`SLL:   BusW <=  BusB<<BusA;
	`SRL:   BusW <=  BusB>>BusA;
	`SUB:   BusW <=  BusA - BusB;
	`SUBU:  BusW <=  BusA - BusB;
	`XOR:   BusW <=  BusA ^ BusB;
	`NOR:   BusW <=  ~(BusA | BusB);
	
	`SLT:   case({BusA[31],BusB[31]})          // 4 diff cases split into 3 statements
	           2'b10   : BusW <= 32'd1;        // BusA is -ve no and BusB is +ve no
	           2'b01   : BusW <= 32'd0;        // BusA is +ve no and BusB is -ve no
	           default : BusW <= (BusA < BusB);    //BusA and BusB both +ve and -ve
	        endcase	
	`SLTU:  BusW <=  less;
	`SRA:   BusW <=  $signed(BusB)>>>BusA;         // Bus A arithmetic shift right

	`LUI:   BusW <=  BusB<<16;						//shifting operation
	default:BusW <=  0;							//default
	endcase
end
endmodule