`timescale 1ns/1ps
module testbench();

parameter N = 16;
reg [N-1:0] A, B;
wire [2*N-1:0] Mul;

Dadda dut_instance (A, B, Mul);

integer i;

initial begin

//for (i=0; i<2**(N+5)-1; i=i+1)
//		begin
//			{B,A} = i;
//			#10;
//			if(Mul !== A*B)
//				begin
//					$display("Error: Wrong Multiplication");
//					$stop;
//					
//				end	
//		end
		
	for (i=0; i<1001; i=i+1)
		begin
			A = $random %256;
			B = $random %256;
			
			#10;
			if(Mul !== A*B)
				begin
					$display("Error: Wrong Multiplication");
					$stop;
					
				end	
		end

	
end

endmodule
