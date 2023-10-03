module project2(clk,A,B,C,opcode,ZF,SF,CF);

	input [3:0]A,B;
	input [2:0]opcode;
	input clk;

	reg [1:0]bitTemp;
	reg carrybit;
	reg [1:0]bitPointer = 2'b00;
	reg [3:0]Bcomp;
	reg borrow=0;

	output reg [3:0]C;
	output reg ZF=0,SF=0,CF=0;

	parameter reset=3'b000,nandd=3'b001,addd=3'b010,orr=3'b011,sub=3'b100;
	parameter zero=2'b00,first=2'b01,second=2'b10,third=2'b11;
	
	always @(posedge clk)
		begin
			if(opcode==reset)
			begin
				bitPointer=zero;
				carrybit=0;
				bitTemp=2'b00;
				CF=0;
				ZF=0;
				SF=0;
				borrow=0;
			end
			if(opcode==nandd) 
			begin
				if(bitPointer==zero)
				begin
					C[0]= ~(A[0] && B[0]);
					bitPointer=first;
				end
				else if(bitPointer==first)
				begin
					C[1]=~(A[1] && B[1]);
					bitPointer=second;
				end
				else if(bitPointer==second)
				begin
					C[2]=~(A[2] && B[2]);
					bitPointer=third;
				end
				else if(bitPointer==third)
				begin
					C[3]=~(A[3] && B[3]);
					bitPointer=zero;
					if(C[3]==1'b1)
					begin
						SF=1;
					end
					else
					begin
						SF=0;
					end
					if(C==4'b0000)
					begin
						ZF=1;
					end
					else
					begin
						ZF=0;
					end
				end
			end
			if(opcode==orr)
			begin
				if(bitPointer==zero)
				begin
					C[0]=(A[0] | B[0]);
					bitPointer=first;
				end
				else if(bitPointer==first)
				begin
					C[1]=(A[1] | B[1]);
					bitPointer=second;
				end
				else if(bitPointer==second)
				begin
					C[2]=(A[2] | B[2]);
					bitPointer=third;
				end
				else if(bitPointer==third)
				begin
					C[3]=(A[3] | B[3]);
					bitPointer=zero;
					if(C[3]==1'b1)
					begin
						SF=1;
					end
					else
					begin
						SF=0;
					end
					if(C==4'b0000)
					begin
						ZF=1;
					end
					else
					begin
						ZF=0;
					end
				end
			end
			if(opcode==addd)
			begin
				if(bitPointer==zero)
				begin
					bitTemp=(A[0]+B[0]);
					carrybit=bitTemp[1];
					C[0]=bitTemp[0];
					bitPointer=first;
				end
				else if(bitPointer==first)
				begin
					bitTemp=(A[1]+B[1]+carrybit);
					C[1]=bitTemp[0];
					carrybit=bitTemp[1];
					bitPointer=second;
				end
				else if(bitPointer==second)
				begin
					bitTemp=(A[2]+B[2]+carrybit);
					C[2]=bitTemp[0];
					carrybit=bitTemp[1];
					bitPointer=third;
				end
				else if(bitPointer==third)
				begin
					bitTemp=(A[3]+B[3]+carrybit);
					C[3]=bitTemp[0];
					carrybit=bitTemp[1];
					bitPointer=zero;
					if(carrybit==0)
					begin
						CF=0;
					end
					else
					begin
						CF=1;
					end
					if(C[3]==1'b1)
					begin
						SF=1;
					end
					else
					begin
						SF=0;
					end
					if(C==4'b0000)
					begin
						ZF=1;
					end
					else
					begin
						ZF=0;
					end
				end
			end
			if(opcode==sub)
            begin
                Bcomp=-B; //2's complement
                if(bitPointer==zero)
                begin
                    bitTemp=(A[0]+Bcomp[0]);
                    carrybit=bitTemp[1];
                    C[0]=bitTemp[0];
                    bitPointer=first;
                    if(A[0]==1'b0 && B[0]==1'b1)
                    begin
						borrow=1;
					end
                end
                else if(bitPointer==first)
                begin
                    bitTemp=(A[1]+Bcomp[1]+carrybit);
                    C[1]=bitTemp[0];
                    carrybit=bitTemp[1];
                    bitPointer=second;
                    if(borrow==1)
                    begin
						if(A[1]==1'b1 && B[1]==1'b0)
						begin
							borrow=0;
						end
					end
					else
					begin
						if(A[1]==1'b0 && B[1]==1'b1)
						begin
							borrow=1;
						end
					end
                end
                else if(bitPointer==second)
                begin
                    bitTemp=(A[2]+Bcomp[2]+carrybit);
                    C[2]=bitTemp[0];
                    carrybit=bitTemp[1];
                    bitPointer=third;
                    if(borrow==1)
                    begin
						if(A[2]==1'b1 && B[2]==1'b0)
						begin
							borrow=0;
						end
					end
					else
					begin
						if(A[2]==1'b0 && B[2]==1'b1)
						begin
							borrow=1;
						end
					end
                end
                else if(bitPointer==third)
                begin
                    bitTemp=(A[3]+Bcomp[3]+carrybit);
                    C[3]=bitTemp[0];
                    carrybit=bitTemp[1];
                    bitPointer=zero;
                    if(borrow==1)
                    begin
						if(A[3]==1'b1 && B[3]==1'b0)
						begin
							borrow=0;
						end
					end
					else
					begin
						if(A[3]==1'b0 && B[3]==1'b1)
						begin
							borrow=1;
						end
					end
                    if(borrow==0)
                    begin
                        CF=0;
                    end
                    else
                    begin
                        CF=1;
                    end
                    if(C[3]==1'b1)
                    begin
                        SF=1;
                    end
                    else
                    begin
                        SF=0;
                    end
                    if(C==4'b0000)
                    begin
                        ZF=1;
                    end
                    else
                    begin
                        ZF=0;
                    end
                    borrow=0;
                end
            end
		end
endmodule
