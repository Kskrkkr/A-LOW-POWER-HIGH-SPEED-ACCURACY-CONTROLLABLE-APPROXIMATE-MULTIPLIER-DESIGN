module PROPOSED_LPSA_MULTIPLIER(
    input [7:0] a,b,
    output [15:0] results
    );
    wire [7:0]pp0,pp1,pp2,pp3,pp4,pp5,pp6,pp7;
	 wire [8:0]P1,P2,P3,P4;
	 wire [10:0]P5,P6;
	 wire [14:0]P7;
	 wire [6:0]Q1,Q2,Q3,Q4,Q5,Q6,Q7;
	 wire [12:0]v;
	 wire c;
	 wire [6:0]sum;
	 wire [4:0]sum1;
//	 wire [3:0]ou;
	/* assign ou[0] = pp7[7];
	 assign ou[1] = pp6[7] & pp7[6];
	 assign ou[2] = P3[6] & P4[6];
	 assign ou[3] = P3[5] & P4[5];*/
	
	 //.............Step1-Partial Products................//
	 PP u0(.a(a[0]),.b(b[7:0]),.p(pp0[7:0])); 
	 PP u1(.a(a[1]),.b(b[7:0]),.p(pp1[7:0]));
	 PP u2(.a(a[2]),.b(b[7:0]),.p(pp2[7:0]));
	 PP u3(.a(a[3]),.b(b[7:0]),.p(pp3[7:0]));
	 PP u4(.a(a[4]),.b(b[7:0]),.p(pp4[7:0])); 
	 PP u5(.a(a[5]),.b(b[7:0]),.p(pp5[7:0]));
	 PP u6(.a(a[6]),.b(b[7:0]),.p(pp6[7:0]));
	 PP u7(.a(a[7]),.b(b[7:0]),.p(pp7[7:0]));
	 //..............Step2-Reducing PP's..................//
//	 assign results[0]=pp0[0];
	 iCAC_7bit r0(.a(pp0[7:0]),.b(pp1[7:0]),.p(P1[8:0]),.q(Q1[6:0]));
	 iCAC_7bit r1(.a(pp2[7:0]),.b(pp3[7:0]),.p(P2[8:0]),.q(Q2[6:0]));
	 iCAC_7bit r2(.a(pp4[7:0]),.b(pp5[7:0]),.p(P3[8:0]),.q(Q3[6:0]));
	 iCAC_7bit r3(.a(pp6[7:0]),.b(pp7[7:0]),.p(P4[8:0]),.q(Q4[6:0]));
	 
//	 assign results[0]=P1[0];
//	 assign results[2]=pp2[0];
//	 
	 //assign results[4]=pp4[0];
	 iCAC2_7bit r4(.a(P1[8:0]),.b(P2[8:0]),.p(P5[10:0]),.q(Q5[6:0]));
	 iCAC2_7bit r5(.a(P3[8:0]),.b(P4[8:0]),.p(P6[10:0]),.q(Q6[6:0]));
	//assign results[2]=P5[0]; 
//	assign results[3]=P5[1];
	 //assign results[6]=pp6[0];
	 iCAC3_7bit r6(.a(P5[10:0]),.b(P6[10:0]),.p(P7[14:0]),.q(Q7[6:0]));
	 
	 ///.........V value from Q .........................//
	 
	 assign v[0]=Q1[0];
	 assign v[1]=Q1[1]|Q5[0];
	 assign v[2]=Q1[2]|Q2[0]|Q5[1];
	 assign v[3]=Q1[3]|Q2[1]|Q5[2]|Q7[0];
	 assign v[4]=Q1[4]|Q2[2]|Q3[0]|Q5[3]|Q7[1];
	 assign v[5]=Q1[5]|Q2[3]|Q3[1]|Q5[4]|Q6[0]|Q7[2];
	 assign v[6]=Q1[6]|Q2[4]|Q3[2]|Q4[0]|Q5[5]|Q6[1]|Q7[3];
	 assign v[7]=Q2[5]|Q3[3]|Q4[1]|Q5[6]|Q6[2]|Q7[4];
	 assign v[8]=Q2[6]|Q3[4]|Q4[2]|Q6[3]|Q7[5];
	 assign v[9]=Q3[5]|Q4[3]|Q6[4]|Q7[6];
	 assign v[10]=Q3[6]|Q4[4]|Q6[5];
	 assign v[11]=Q4[5]|Q6[6];
	 assign v[12]=Q4[6];
	
//	 assign ou[3] = P7[14];
//	 assign ou[2] = P7[13]; 
//	 assign ou[1] = P7[12]; 
//	 assign ou[0] = P7[11];
//	//assign results=a*b;
	 CMA_7bit t0(.a(P7[10:4]),.b(v[9:3]),.cin(1'b0),.s(sum[6:0]),.cout(c));
	 CPA_4bit t1(.a(P7[14:11]),.b({1'b0,v[12:10]}),.cin(1'b0),.s(sum1[4:0]));
	assign results[3:0]=P7[3:0]; 
	assign results[10:4]=sum[6:0];
	assign results[15:11]=sum1[4:0];
		
endmodule

 module andgate(d,e,f,a,b,c);
input a,b,c;
output d,e,f;
wire w0;
buf b1(d,a);
buf b2(e,b);
and a1(w0,a,b);
xor x1(f,w0,c);
endmodule
///////
module CMA(
    input a,b,cin,maskb,
    output s,cout
    );
wire w1,w2,w3,w4,w5,w6,w7,w8,w9;
nand n1(w0,maskb,a,b);

nand n2(w1,a,a);
nand n3(w2,b,b);
nand n4(w3,w1,w2);
nand n5(w4,w0,w3);
nand n6(w5,w4,w4);
nand n7(w6,w5,cin);
nand n8(w7,w6,w5);
nand n9(w8,w6,cin);
nand n10(s,w7,w8);

nand n11(w9,w5,cin);
nand n12(cout,w9,w0);
endmodule
//////
module CMA_7bit(
    input [6:0] a,b,
    input cin,
    output [6:0] s,
    output cout
    );
	 wire [5:0]c;
	 CMA u0(.maskb(1'b0),.a(a[0]),.b(b[0]),.cin(cin),.s(s[0]),.cout(c[0]));
	 CMA u1(.maskb(1'b0),.a(a[1]),.b(b[1]),.cin(c[0]),.s(s[1]),.cout(c[1]));
	 CMA u2(.maskb(1'b0),.a(a[2]),.b(b[2]),.cin(c[1]),.s(s[2]),.cout(c[2]));
	 CMA u3(.maskb(1'b0),.a(a[3]),.b(b[3]),.cin(c[2]),.s(s[3]),.cout(c[3]));
	 CMA u4(.maskb(1'b0),.a(a[4]),.b(b[4]),.cin(c[3]),.s(s[4]),.cout(c[4]));
	 CMA u5(.maskb(1'b0),.a(a[5]),.b(b[5]),.cin(c[4]),.s(s[5]),.cout(c[5]));
	 CMA u6(.maskb(1'b0),.a(a[6]),.b(b[6]),.cin(c[5]),.s(s[6]),.cout(cout));
	 

endmodule
//////////
module CPA_4bit(
    input [3:0] a,b,
    input cin,
    output [4:0] s
       );
	 wire [2:0]c;
	 wire cout;
	 wire p1,p2,p3,p4,q1,q2,q3,q4;
	 fa u0(.a(a[0]),.b(b[0]),.cin(cin),.s(s[0]),.cout(c[0]),.d(1'b0),.p(p1),.q(q1));
	 fa u1(.a(a[1]),.b(b[1]),.cin(c[0]),.s(s[1]),.cout(c[1]),.d(1'b0),.p(p2),.q(q2));
	 fa u2(.a(a[2]),.b(b[2]),.cin(c[1]),.s(s[2]),.cout(c[2]),.d(1'b0),.p(p3),.q(q3));
	 fa u3(.a(a[3]),.b(b[3]),.cin(c[2]),.s(s[3]),.cout(cout),.d(1'b0),.p(p4),.q(q4));
	 buf b1 (s[4],cout);
 
endmodule
////////
module fa(a,b,cin,d,s,cout,p,q);
input a,b,cin,d;
output s,cout,p,q;
assign p=a;
assign q=b;
assign s=a^b^cin;
assign cout =(a^b)&cin^(a&b)^d;

endmodule
//////////////
module iCAC(
    input a,b,
    output p,q
    );
	 wire wo;
	or  a1(p,a,b);
	nand a2(w0,a,b);
	not a3(q,w0);

endmodule
/////
module iCAC_7bit(a,b,p,q);
    input [7:0] a,b;
    output [6:0] q;
	 output [8:0] p;
    
    //iCAC u0(.a(a[0]),.b(b[0]),.p(p[0]),.q(q[0]));
	 assign p[0]=a[0];
	 iCAC u1(.a(a[1]),.b(b[0]),.p(p[1]),.q(q[0]));
	 iCAC u2(.a(a[2]),.b(b[1]),.p(p[2]),.q(q[1]));
	 iCAC u3(.a(a[3]),.b(b[2]),.p(p[3]),.q(q[2]));
	 iCAC u4(.a(a[4]),.b(b[3]),.p(p[4]),.q(q[3]));
	 iCAC u5(.a(a[5]),.b(b[4]),.p(p[5]),.q(q[4]));
	 iCAC u6(.a(a[6]),.b(b[5]),.p(p[6]),.q(q[5]));
	 iCAC u7(.a(a[7]),.b(b[6]),.p(p[7]),.q(q[6]));	 
	assign p[8]=b[7];
endmodule

/////////////
module iCAC2_7bit(a,b,p,q);
    input [8:0] a,b;
    output [6:0] q;
	 output [10:0] p;
    
    //iCAC u0(.a(a[0]),.b(b[0]),.p(p[0]),.q(q[0]));
    assign p[0]=a[0];
	 assign p[1]=a[1];
	 iCAC u1(.a(a[2]),.b(b[0]),.p(p[2]),.q(q[0]));
	 iCAC u2(.a(a[3]),.b(b[1]),.p(p[3]),.q(q[1]));
	 iCAC u3(.a(a[4]),.b(b[2]),.p(p[4]),.q(q[2]));
	 iCAC u4(.a(a[5]),.b(b[3]),.p(p[5]),.q(q[3]));
	 iCAC u5(.a(a[6]),.b(b[4]),.p(p[6]),.q(q[4]));
    iCAC u6(.a(a[7]),.b(b[5]),.p(p[7]),.q(q[5]));
    iCAC u7(.a(a[8]),.b(b[6]),.p(p[8]),.q(q[6]));
      	assign p[9] =b[7];
			assign p[10]=b[8];
 
endmodule
//////
module iCAC3_7bit(a,b,p,q);
    input [10:0] a,b;
    output [6:0] q;
	 output [14:0] p;
	 	     
    //iCAC u0(.a(a[0]),.b(b[0]),.p(p[0]),.q(q[0]));
 assign p[0]=a[0];
 assign p[1]=a[1];
 assign p[2]=a[2];
 assign p[3]=a[3];
    iCAC u1(.a(a[4]),.b(b[0]),.p(p[4]),.q(q[0]));
	 iCAC u2(.a(a[5]),.b(b[1]),.p(p[5]),.q(q[1]));
	 iCAC u3(.a(a[6]),.b(b[2]),.p(p[6]),.q(q[2]));
	 iCAC u4(.a(a[7]),.b(b[3]),.p(p[7]),.q(q[3]));
	 iCAC u5(.a(a[8]),.b(b[4]),.p(p[8]),.q(q[4]));
	 iCAC u6(.a(a[9]),.b(b[5]),.p(p[9]),.q(q[5]));
	 iCAC u7(.a(a[10]),.b(b[6]),.p(p[10]),.q(q[6]));	
	assign p[11]=b[7];
assign p[12]=b[8];
assign p[13]=b[9];
assign p[14]=b[10];

    	

endmodule
module PP(
    input a,
    input [7:0] b,
    output [7:0] p
    );
	 wire [1:0]w0,w1,w2,w3,w4,w5,w6,w7;
    andgate a1 (w0[0],w0[1],p[0],a,b[0],1'b0);
	 andgate a2 (w1[0],w1[1],p[1],a,b[1],1'b0);
	 andgate a3 (w2[0],w2[1],p[2],a,b[2],1'b0);
	 andgate a4 (w3[0],w3[1],p[3],a,b[3],1'b0);
	 andgate a5 (w4[0],w4[1],p[4],a,b[4],1'b0);
	 andgate a6 (w5[0],w5[1],p[5],a,b[5],1'b0);
	 andgate a7 (w6[0],w6[1],p[6],a,b[6],1'b0);
	 andgate a8 (w7[0],w7[1],p[7],a,b[7],1'b0);

endmodule 
module tb ;

 reg [7:0] a,b ;
 wire [15:0] results ;
    
PROPOSED_LPSA_MULTIPLIER uut( a,b,results) ;

initial 
begin
    repeat(10)
    begin
     {a,b } = $random ;
     #2;
    end
    $stop ;
end


endmodule    