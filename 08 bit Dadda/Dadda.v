module Dadda (A, B, Mul);

parameter N=8;

input [N-1:0] A;
input [N-1:0] B;
output [2*N-1:0] Mul;
wire Cout;

reg p [N-1:0][N-1:0];

wire w01, w02, w03, w04, w05, w141, w142, w143, w144;
wire [1:0] w11, w131, w12, w132, w13, w133, w14, w15, w25, w35, w45, w55, w65, w75, w85, w95, w105, w115, w125, w135, w145;
wire [2:0] w21, w121, w22, w122, w23, w24, w34, w44, w54, w64, w74, w84, w94, w104, w114, w124, w134;
wire [3:0] w31, w111, w32, w112, w33, w43, w53, w63, w73, w83, w93, w103, w113, w123;
wire [4:0] w41, w101, w42;
wire [5:0] w51, w91 , w52, w62, w72, w82, w92, w102;
wire [6:0] w61, w81;
wire [7:0] w71;


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

															a7 a6 a5 a4 a3 a2 a1 a0
														x	b7 b6 b5 b4 b3 b2 b1 b0
														------------------------------------------------------------------------------------
														a7b0 a6b0 a5b0 a4b0 a3b0 a2b0 a1b0 a0b0
												   a7b1 a6b1 a5b1 a4b1 a3b1 a2b1 a1b1 a0b1
											  a7b2 a6b2 a5b2 a4b2 a3b2 a2b2 a1b2 a0b2
							----------------------------------------------------------------------------------------------------------------
									     a7b3 a6b3 a5b3 a4b3 a3b3 a2b3 a1b3 a0b3
								    a7b4 a6b4 a5b4 a4b4 a3b4 a2b4 a1b4 a0b4
							   a7b5 a6b5 a5b5 a4b5 a3b5 a2b5 a1b5 a0b5
				----------------------------------------------------------------------------------------------------------------------------
						  a7b6 a6b6 a5b6 a4b6 a3b6 a2b6 a1b6 a0b6
				     a7b7 a6b7 a5b7 a4b7 a3b7 a2b7 a1b7 a0b7

---------------------------------------------------------------------------------------------------------------------------------------------
			
			
			Stage 2

														w92[0] w82[0] w72[0] w62[0] w52[0] w42[0] w32[0] w22[0] w12 w02		[weight-bit] [stage]
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

assign w11[0] = p[0][1];
assign w11[1] = p[1][0];
assign w12 = w11;

assign w21[0] = p[2][0];
assign w21[1] = p[1][1];
assign w21[2] = p[0][2];
assign w22 = w21;

assign w31[0] = p[3][0];
assign w31[1] = p[2][1];
assign w31[2] = p[1][2];
assign w31[3] = p[0][3];
assign w32 = w31;

assign w41[0] = p[4][0];
assign w41[1] = p[3][1];
assign w41[2] = p[2][2];
assign w41[3] = p[1][3];
assign w41[4] = p[0][4];
assign w42 = w41;

assign w51[0] = p[5][0];
assign w51[1] = p[4][1];
assign w51[2] = p[3][2];
assign w51[3] = p[2][3];
assign w51[4] = p[1][4];
assign w51[5] = p[0][5];
assign w52 = w51;

assign w61[0] = p[6][0];
assign w61[1] = p[5][1];
assign w61[2] = p[4][2];
assign w61[3] = p[3][3];
assign w61[4] = p[2][4];
assign w61[5] = p[1][5];
assign w61[6] = p[0][6];

HA H1 (w61[0], w61[1], w62[0], w72[0]);
assign w62[1] = w61[2];
assign w62[2] = w61[3];
assign w62[3] = w61[4];
assign w62[4] = w61[5];
assign w62[5] = w61[6];


assign w71[0] = p[7][0];
assign w71[1] = p[6][1];
assign w71[2] = p[5][2];
assign w71[3] = p[4][3];
assign w71[4] = p[3][4];
assign w71[5] = p[2][5];
assign w71[6] = p[1][6];
assign w71[7] = p[0][7];

FA F1 (w71[0], w71[1], w71[2], w72[1], w82[0]);
HA H2 (w71[3], w71[4], w72[2], w82[1]);
assign w72[3] = w71[5];
assign w72[4] = w71[6];
assign w72[5] = w71[7];


assign w81[0] = p[7][1];
assign w81[1] = p[6][2];
assign w81[2] = p[5][3];
assign w81[3] = p[4][4];
assign w81[4] = p[3][5];
assign w81[5] = p[2][6];
assign w81[6] = p[1][7];

FA F2 (w81[0], w81[1], w81[2], w82[2], w92[0]);
HA H3 (w81[3], w81[4], w82[3], w92[1]);
assign w82[4] = w81[5];
assign w82[5] = w81[6];


assign w91[0] = p[7][2];
assign w91[1] = p[6][3];
assign w91[2] = p[5][4];
assign w91[3] = p[4][5];
assign w91[4] = p[3][6];
assign w91[5] = p[2][7];

FA F3 (w91[0], w91[1], w91[2], w92[2], w102[0]);
assign w92[3] = w91[3];
assign w92[4] = w91[4];
assign w92[5] = w91[5];


assign w101[0] = p[7][3];
assign w101[1] = p[6][4];
assign w101[2] = p[5][5];
assign w101[3] = p[4][6];
assign w101[4] = p[3][7];

assign w102[1] = w101[0];
assign w102[2] = w101[1];
assign w102[3] = w101[2];
assign w102[4] = w101[3];
assign w102[5] = w101[4];


assign w111[0] = p[7][4];
assign w111[1] = p[6][5];
assign w111[2] = p[5][6];
assign w111[3] = p[4][7];

assign w112 = w111;


assign w121[0] = p[7][5];
assign w121[1] = p[6][6];
assign w121[2] = p[5][7];

assign w122 = w121;


assign w131[0] = p[7][6];
assign w131[1] = p[6][7];

assign w132 = w131;


assign w141 = p[7][7];

assign w142 = w141;





// Stage 2			// [Weight-bit] [Stage]

assign w03 = w02;

assign w13 = w12;

assign w23 = w22;

assign w33 = w32;

HA H4 (w42[0], w42[1], w43[0], w53[0]);
assign w43[1] = w42[2];
assign w43[2] = w42[3];
assign w43[3] = w42[4];

FA F4 (w52[0], w52[1], w52[2], w53[1], w63[0]);
HA H5 (w52[3], w52[4], w53[2], w63[1]);
assign w53[3] = w52[5];


FA F5 (w62[0], w62[1], w62[2], w63[2], w73[0]);
FA F6 (w62[3], w62[4], w62[5], w63[3], w73[1]);


FA F7 (w72[0], w72[1], w72[2], w73[2], w83[0]);
FA F8 (w72[3], w72[4], w72[5], w73[3], w83[1]);


FA F9  (w82[0], w82[1], w82[2], w83[2], w93[0]);
FA F10 (w82[3], w82[4], w82[5], w83[3], w93[1]);


FA F11 (w92[0], w92[1], w92[2], w93[2], w103[0]);
FA F12 (w92[3], w92[4], w92[5], w93[3], w103[1]);


FA F13 (w102[0], w102[1], w102[2], w103[2], w113[0]);
FA F14 (w102[3], w102[4], w102[5], w103[3], w113[1]);


FA F15 (w112[0], w112[1], w112[2], w113[2], w123[0]);
assign w113[3] = w112[3];


assign w123[1] = w122[0];
assign w123[2] = w122[1];
assign w123[3] = w122[2];


assign w133 = w132;


assign w143 = w142;





// Stage 3			// [Weight-bit] [Stage]

assign w04 = w03;

assign w14 = w13;

assign w24 = w23;

HA H6 (w33[0], w33[1], w34[0], w44[0]);
assign w34[1] = w33[2];
assign w34[2] = w33[3];


FA F16 (w43[0], w43[1], w43[2], w44[1], w54[0]);
assign w44[2] = w43[3];


FA F17 (w53[0], w53[1], w53[2], w54[1], w64[0]);
assign w54[2] = w53[3];


FA F18 (w63[0], w63[1], w63[2], w64[1], w74[0]);
assign w64[2] = w63[3];


FA F19 (w73[0], w73[1], w73[2], w74[1], w84[0]);
assign w74[2] = w73[3];


FA F20 (w83[0], w83[1], w83[2], w84[1], w94[0]);
assign w84[2] = w83[3];


FA F21 (w93[0], w93[1], w93[2], w94[1], w104[0]);
assign w94[2] = w93[3];


FA F22 (w103[0], w103[1], w103[2], w104[1], w114[0]);
assign w104[2] = w103[3];


FA F23 (w113[0], w113[1], w113[2], w114[1], w124[0]);
assign w114[2] = w113[3];


FA F24 (w123[0], w123[1], w123[2], w124[1], w134[0]);
assign w124[2] = w123[3];


assign w134[1] = w133[0];
assign w134[2] = w133[1];


assign w144 = w143;





// Stage 4			// [Weight-bit] [Stage]

assign w05 = w04;

assign w15 = w14;


HA H7 (w24[0], w24[1], w25[0], w35[0]);
assign w25[1] = w24[2];

FA F25 (w34[0], w34[1], w34[2], w35[1], w45[0]);

FA F26 (w44[0], w44[1], w44[2], w45[1], w55[0]);

FA F27 (w54[0], w54[1], w54[2], w55[1], w65[0]);

FA F28 (w64[0], w64[1], w64[2], w65[1], w75[0]);

FA F29 (w74[0], w74[1], w74[2], w75[1], w85[0]);

FA F30 (w84[0], w84[1], w84[2], w85[1], w95[0]);

FA F31 (w94[0], w94[1], w94[2], w95[1], w105[0]);

FA F32 (w104[0], w104[1], w104[2], w105[1], w115[0]);

FA F33 (w114[0], w114[1], w114[2], w115[1], w125[0]);

FA F34 (w124[0], w124[1], w124[2], w125[1], w135[0]);

FA F35 (w134[0], w134[1], w134[2], w135[1], w145[0]);

assign w145[1] = w144;

//HA H15 (w144[0], w144[1], w145[1], w155); 	Used to ckeck validity by making an error


// 14-bit ripple carry adder for MSB bits

RCA RC0 ({w145[0], w135[0], w125[0], w115[0], w105[0], w95[0], w85[0], w75[0], w65[0], w55[0], w45[0], w35[0], w25[0], w15[0]}, {w145[1], w135[1], w125[1], w115[1], w105[1], w95[1], w85[1], w75[1], w65[1], w55[1], w45[1], w35[1], w25[1], w15[1]}, Mul[14:1], Mul[15]);

assign Mul[0] = w05;

endmodule


module RCA (A, B, Sum, Cout);
input [13:0] A, B;
output Cout;
output [13:0] Sum;

wire [12:0] C;

HA H60 (A[0], B[0], Sum[0], C[0]);
FA F60 (A[1], B[1], C[0], Sum[1], C[1]);
FA F61 (A[2], B[2], C[1], Sum[2], C[2]);
FA F62 (A[3], B[3], C[2], Sum[3], C[3]);
FA F63 (A[4], B[4], C[3], Sum[4], C[4]);
FA F64 (A[5], B[5], C[4], Sum[5], C[5]);
FA F65 (A[6], B[6], C[5], Sum[6], C[6]);
FA F66 (A[7], B[7], C[6], Sum[7], C[7]);
FA F67 (A[8], B[8], C[7], Sum[8], C[8]);
FA F68 (A[9], B[9], C[8], Sum[9], C[9]);
FA F69 (A[10], B[10], C[9], Sum[10], C[10]);
FA F70 (A[11], B[11], C[10], Sum[11], C[11]);
FA F71 (A[12], B[12], C[11], Sum[12], C[12]);

FA F72 (A[13], B[13], C[12], Sum[13], Cout);

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
