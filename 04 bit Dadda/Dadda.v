module Dadda (A, B, Mul);

parameter N=4;

input [N-1:0] A;
input [N-1:0] B;
output [2*N-1:0] Mul;
wire Cout;

reg p [N-1:0][N-1:0];

wire w01, w02, w03, w62, w61;
wire [1:0] w11, w51, w12, w13, w23, w33, w43, w53, w63;
wire [2:0] w21, w41, w22, w32, w42, w52;
wire [3:0] w31;


// Initialize all the partial products
integer i,j;

always @(*)
begin

	for(i=0;i<N;i=i+1)
	begin
	
		for(j=0;j<N;j=j+1)
		begin
		
			p[i][j] = A[i] & B[j];
			
		end
	end
end



/*
					Stage 1

																				a3 a2 a1 a0
																		x		b3 b2 b1 b0
														------------------------------------------------------------------------------------
																		   a3b0 a2b0 a1b0 a0b0
																	  a3b1 a2b1 a1b1 a0b1
																 a3b2 a2b2 a1b2 a0b2
							----------------------------------------------------------------------------------------------------------------
															a3b3 a2b3 a1b3 a0b3
								    
---------------------------------------------------------------------------------------------------------------------------------------------
													HA	HA
			
			Stage 2

													w62[0] w52[0] w42[0] w32[0] w22[0] w12 w02		[weight-bit] [stage]
									w92[1] w82[1] w72[1] w62[1] w52[1] w42[1] w32[1] w22[1]
								w122[0] w112[0] w102[0] w92[2] w82[2] w72[2] w62[2] w52[2] w42[2] w32[2]
				----------------------------------------------------------------------------------------------------------------------------								
								w122[1] w112[1] w102[1] w92[3] w82[3] w72[3] w62[3] w52[3]
						w132[0] w122[2] w112[2] w102[2] w92[4] w82[4] w72[4] w62[4]
				w142[0] w132[1] w122[3] w112[3] w102[3] w92[5] w82[5] w72[5]

---------------------------------------------------------------------------------------------------------------------------------------------								
								
								
								
*/



// Stage 1			// [Weight-bit] [Stage]

assign w01 = p[0][0];
assign w02 = w01;

assign w11[0] = p[1][0];
assign w11[1] = p[0][1];
assign w12 = w11;

assign w21[0] = p[2][0];
assign w21[1] = p[1][1];
assign w21[2] = p[0][2];
assign w22 = w21;

assign w31[0] = p[3][0];
assign w31[1] = p[2][1];
assign w31[2] = p[1][2];
assign w31[3] = p[0][3];
HA H1 (w31[0], w31[1], w32[0], w42[0]);
assign w32[1] = w31[2];
assign w32[2] = w31[3];

assign w41[0] = p[3][1];
assign w41[1] = p[2][2];
assign w41[2] = p[1][3];
HA H2 (w41[0], w41[1], w42[1], w52[0]);
assign w42[2] = w41[2];

assign w51[0] = p[2][3];
assign w51[1] = p[3][2];
assign w52[1] = w51[0];
assign w52[2] = w51[1];

assign w61 = p[3][3];
assign w62 = w61;





// Stage 2			// [Weight-bit] [Stage]

assign w03 = w02;

assign w13 = w12;

HA H3 (w22[0], w22[1], w23[0], w33[0]);
assign w23[1] = w22[2];

FA F1 (w32[0], w32[1], w32[2], w33[1], w43[0]);
FA F2 (w42[0], w42[1], w42[2], w43[1], w53[0]);
FA F3 (w52[0], w52[1], w52[2], w53[1], w63[0]);
assign w63[1] = w62;




// 6-bit ripple carry adder for MSB bits

RCA RC0 ({w63[0], w53[0], w43[0], w33[0], w23[0], w13[0]}, {w63[1], w53[1], w43[1], w33[1], w23[1], w13[1]}, Mul[6:1], Mul[7]);

assign Mul[0] = w03;

endmodule


module RCA (A, B, Sum, Cout);
input [5:0] A, B;
output Cout;
output [5:0] Sum;

wire [4:0] C;

HA H60 (A[0], B[0], Sum[0], C[0]);
FA F60 (A[1], B[1], C[0], Sum[1], C[1]);
FA F61 (A[2], B[2], C[1], Sum[2], C[2]);
FA F62 (A[3], B[3], C[2], Sum[3], C[3]);
FA F63 (A[4], B[4], C[3], Sum[4], C[4]);

FA F69 (A[5], B[5], C[4], Sum[5], Cout);

endmodule


// Half_Adder

module HA (A, B, Sum, Cout);
input A, B;
output Sum, Cout;

assign Sum = A ^ B;
assign Cout = A & B;

endmodule


// Full_Adder

module FA(A, B, Cin, Sum, Cout);
input A, B, Cin;
output Sum, Cout;

assign Sum = A ^ B ^ Cin;
assign Cout = ((A ^ B) & Cin) | (A & B);

endmodule
