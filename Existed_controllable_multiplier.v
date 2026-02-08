module controllable_multiplier(mask_x, a, b, Product );

input mask_x ;
input [7:0] a,b ;
output [15:0] Product ;

wire [7:0] pp0,pp1,pp2,pp3,pp4,pp5,pp6,pp7;
wire [6:0]P1,V1,P2,V2,P3,V3,P4,V4,P5,V5,P6,V6;
wire [6:0] P7,Q7 ;
wire [12:0] S ;
wire [12:0] C ;
wire cr1,cr2,cr3,cr4,cr5,cr6,cr7,cr8,cr9 ;
wire [14:0] FP7 ;
wire [12:0] FP8 ;
wire [10:0] FP9 ;
wire [6:0] R ;

wire [12:0]VF1 ;
wire [10:0]FV2 ;

//Step1-Partial Products generation
	
PP u0(.a(a[0]),.b(b[7:0]),.p(pp0));
PP u1(.a(a[1]),.b(b[7:0]),.p(pp1));
PP u2(.a(a[2]),.b(b[7:0]),.p(pp2));
PP u3(.a(a[3]),.b(b[7:0]),.p(pp3));
PP u4(.a(a[4]),.b(b[7:0]),.p(pp4)); 
PP u5(.a(a[5]),.b(b[7:0]),.p(pp5));
PP u6(.a(a[6]),.b(b[7:0]),.p(pp6));
PP u7(.a(a[7]),.b(b[7:0]),.p(pp7));

//step 2 addition of partial products with ATC

ATC atc0(.a(pp0[7:1]),.b(pp1[6:0]),.P(P1),.V(V1)) ;//pp0
ATC atc1(.a(pp2[7:1]),.b(pp3[6:0]),.P(P2),.V(V2)) ;//pp2
ATC atc2(.a(pp4[7:1]),.b(pp5[6:0]),.P(P3),.V(V3)) ;//pp4
ATC atc3(.a(pp6[7:1]),.b(pp7[6:0]),.P(P4),.V(V4)) ;//pp6

//// V1 GENERATION ///////
    assign VF1[0]=V1[0];
	 assign VF1[1]=V1[1];
	 assign VF1[2]=V1[2]|V2[0];
	 assign VF1[3]=V1[3]|V2[1];
	 assign VF1[4]=V1[4]|V2[2]|V3[0];
	 assign VF1[5]=V1[5]|V2[3]|V3[1];
	 assign VF1[6]=V1[6]|V2[4]|V3[2]|V4[0];
	 assign VF1[7]=V2[5]|V3[3]|V4[1];
	 assign VF1[8]=V2[6]|V3[4]|V4[2];
	 assign VF1[9]=V3[5]|V4[3];
	 assign VF1[10]=V3[6]|V4[4];
	 assign VF1[11]=V4[5];
	 assign VF1[12]=V4[6];
//step 3 addition of step2 ATC

ATC atc4(.a({pp1[7],P1[6:1]}),.b({P2[5:0],pp2[0]}),.P(P5),.V(V5)) ;
ATC atc5(.a({pp5[7],P3[6:1]}),.b({P4[5:0],pp6[0]}),.P(P6),.V(V6)) ;

///V2 GENERATION

assign FV2[0]=V5[0];
assign FV2[1]=V5[1];
assign FV2[2]=V5[2];
assign FV2[3]=V5[3];
assign FV2[4]=V5[4]|V6[0];
assign FV2[5]=V5[5]|V6[1];
assign FV2[6]=V5[6]|V6[2];
assign FV2[7]=V6[3];
assign FV2[8]=V6[4];
assign FV2[9]=V6[5];
assign FV2[10]=V6[6];

//step 4 addition of step3 ICAC
//IAC(a,b,P,Q) ;
ICAC ICA0(.a({pp3[7],P2[6],P5[6:2]}),.b({P6[4:0],P3[0],pp4[0]}),.P(P7),.Q(Q7)) ;

assign R = FV2[7:1]  |  VF1[9:3] ;

assign FP7 = {pp7[7],P4[6],P6[6:5],P7,P5[1:0],P1[0],pp0[0]} ;
assign FP8 = {VF1[12] , FV2[10:9] , Q7, FV2[1:0],VF1[0] } ;
assign FP9 = {VF1[11:10] ,R ,VF1[2:1] } ;

half_adder  ha1(.a(FP7[1]),.b(FP8[0]),.sum(S[0]),.carry(C[0])) ;

full_adder  fa1(.a(FP7[2]),.b(FP8[1]),.c(FP9[0]),.sum(S[1]),.carry(C[1])) ;
full_adder  fa2(.a(FP7[3]),.b(FP8[2]),.c(FP9[1]),.sum(S[2]),.carry(C[2])) ;
full_adder  fa3(.a(FP7[4]),.b(FP8[3]),.c(FP9[2]),.sum(S[3]),.carry(C[3])) ;
full_adder  fa4(.a(FP7[5]),.b(FP8[4]),.c(FP9[3]),.sum(S[4]),.carry(C[4])) ;
full_adder  fa5(.a(FP7[6]),.b(FP8[5]),.c(FP9[4]),.sum(S[5]),.carry(C[5])) ;
full_adder  fa6(.a(FP7[7]),.b(FP8[6]),.c(FP9[5]),.sum(S[6]),.carry(C[6])) ;
full_adder  fa7(.a(FP7[8]),.b(FP8[7]),.c(FP9[6]),.sum(S[7]),.carry(C[7])) ;
full_adder  fa8(.a(FP7[9]),.b(FP8[8]),.c(FP9[7]),.sum(S[8]),.carry(C[8])) ;
full_adder  fa9(.a(FP7[10]),.b(FP8[9]),.c(FP9[8]),.sum(S[9]),.carry(C[9])) ;
full_adder  fa10(.a(FP7[11]),.b(FP8[10]),.c(FP9[9]),.sum(S[10]),.carry(C[10])) ;
full_adder  fa11(.a(FP7[12]),.b(FP8[11]),.c(FP9[10]),.sum(S[11]),.carry(C[11])) ;

half_adder  ha2(.a(FP7[13]),.b(FP8[12]),.sum(S[12]),.carry(C[12])) ;
//////PRODUCT GENERATION //////////////
assign Product[0] = FP7[0] ;
assign Product[1] = S[0] ;

/////truncated part
assign Product[2] = S[1] | C[0] ;
assign Product[3] = S[2] | C[1] ;
assign Product[4] = S[3] | C[2] ;

//////CMA 

maskable_half_adder  mh1(mask_x, S[4], C[3] ,Product[5],cr1) ;

maskable_full_adder  mf1(mask_x, S[5], C[4] ,cr1,Product[6],cr2) ;
maskable_full_adder  mf2(mask_x, S[6], C[5] ,cr2,Product[7],cr3) ;
maskable_full_adder  mf3(mask_x, S[7], C[6] ,cr3,Product[8],cr4) ;
maskable_full_adder  mf4(mask_x, S[8], C[7] ,cr4,Product[9],cr5) ;
maskable_full_adder  mf5(mask_x, S[9], C[8] ,cr5,Product[10],cr6) ;
maskable_full_adder  mf6(mask_x, S[10], C[9] ,cr6,Product[11],cr7) ;
///////exact addition

full_adder  fa12(.a(S[11]),.b(C[10]),.c(cr7),.sum(Product[12]),.carry(cr8)) ;
full_adder  fa13(.a(S[12]),.b(C[11]),.c(cr8),.sum(Product[13]),.carry(cr9)) ;
full_adder  fa14(.a(FP7[14]),.b(C[12]),.c(cr9),.sum(Product[14]),.carry(Product[15])) ;


endmodule

//PARTIAL PRODUCT GENERATION

module PP(a,b,p) ;
input a ;
input [7:0] b ;
output [7:0] p ;
    
and (p[0],a,b[0]);
and (p[1],a,b[1]);
and (p[2],a,b[2]);
and (p[3],a,b[3]);
and (p[4],a,b[4]);
and (p[5],a,b[5]);
and (p[6],a,b[6]);
and (p[7],a,b[7]);

endmodule
//ATC
module ATC(a,b,P,V) ;

input [6:0] a,b ;
output [6:0] P,V ;

IHA iha1(.a(a[0]),.b(b[0]),.p(P[0]),.q(V[0])) ;
IHA iha2(.a(a[1]),.b(b[1]),.p(P[1]),.q(V[1])) ;
IHA iha3(.a(a[2]),.b(b[2]),.p(P[2]),.q(V[2])) ;
IHA iha4(.a(a[3]),.b(b[3]),.p(P[3]),.q(V[3])) ;
IHA iha5(.a(a[4]),.b(b[4]),.p(P[4]),.q(V[4])) ;
IHA iha6(.a(a[5]),.b(b[5]),.p(P[5]),.q(V[5])) ;
IHA iha7(.a(a[6]),.b(b[6]),.p(P[6]),.q(V[6])) ;
//IHA iha8(.a(a[7]),.b(b[7]),.p(P[7]),.q(V[7])) ;

endmodule
//incomplete adder cell

module ICAC(a,b,P,Q) ;

input [6:0] a,b ;
output [6:0] P,Q ;

IHA iha1(.a(a[0]),.b(b[0]),.p(P[0]),.q(Q[0])) ;
IHA iha2(.a(a[1]),.b(b[1]),.p(P[1]),.q(Q[1])) ;
IHA iha3(.a(a[2]),.b(b[2]),.p(P[2]),.q(Q[2])) ;
IHA iha4(.a(a[3]),.b(b[3]),.p(P[3]),.q(Q[3])) ;
IHA iha5(.a(a[4]),.b(b[4]),.p(P[4]),.q(Q[4])) ;
IHA iha6(.a(a[5]),.b(b[5]),.p(P[5]),.q(Q[5])) ;
IHA iha7(.a(a[6]),.b(b[6]),.p(P[6]),.q(Q[6])) ;

endmodule

//incomplete half adder

module IHA(a,b,p,q) ;

input a,b ;
output p,q ;

assign p = a || b ;//sum
assign q = a && b ;//carry

endmodule

/////half adder
module half_adder (a,b,sum,carry) ;

input a,b; 
output sum,carry ;

assign sum = a ^ b ;
assign carry = a & b ;

endmodule

//////////full adder
module full_adder (a,b,c,sum,carry) ;

input a,b,c; 
output sum,carry ;

assign sum = a ^ b ^ c ;
assign carry = (a & b) | (b & c) | (a & c) ;

endmodule
////////maskable half adder

module maskable_half_adder (mask_x, x, y ,s,cout) ;

input  mask_x, x, y  ; 
output s,cout ;

assign w1 = ! (mask_x & x & y ) ;
assign w2 =  x | y ;

assign s = w1 & w2 ;
assign cout = !w1 ;

endmodule
/////maskable full adder
module maskable_full_adder (mask_x, x, y,cin ,s,cout) ;

input  mask_x, x, y,cin  ; 
output s,cout ;

assign w1 = ! (mask_x & x & y ) ;
assign w2 =  x | y ;
assign w3 = w1 & w2 ;
assign s = w3 ^ cin ;
assign w4 = ! (w3 & cin) ;

assign cout = !(w4 & w1 ) ;


endmodule

//test bench
module tb ;

reg mask_x ;
reg [7:0] a,b ;
wire [15:0] Product ;

 controllable_multiplier uut(mask_x, a, b, Product );
 
 initial 
 begin
    repeat(10)
    begin
    mask_x  = $random ;
    a = $random ;
    b = $random ;
    #2;
    end
    $stop ;
 end
 endmodule

