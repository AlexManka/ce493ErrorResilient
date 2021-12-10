// `include "cpu/reg_32.v"
// `include "lib/dff.v"
// `include "extralib/not_gate_n2.v"

module EX_MEM_reg(clk, zero_in, zero_out, res_in, res_out, B_in, B_out, target_in, target_out,
    MemWr_in, Br_in, MemtoReg_in, RegWr_in, MemWr_out, Br_out, MemtoReg_out, RegWr_out, regAddr_in, regAddr_out, pcout, errorout, errorin, pcin);
    
    input clk;

    // datapath signals
    input [31:0] target_in;
    input zero_in;
    input [31:0] res_in;
    input [31:0] B_in;
    input [31:0] regAddr_in; 
    output [31:0] target_out;
    output [31:0] res_out;
    output [31:0] B_out;
    output [31:0] regAddr_out;
    output zero_out;

    // control signals
    input MemWr_in;
    input [1:0] Br_in;
    input MemtoReg_in;
    input RegWr_in;
    output MemWr_out;
    output [1:0] Br_out;
    output MemtoReg_out;
    output RegWr_out;

    input errorin;
    output [31:0] pcin;
    output [31:0] pcout;
    output errorout;

    wire [31:0] e1, e2, e3, e4;
    wire s1, s2, s3, s4, s5, s6;
    wire v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12;

    razor_reg_32 targetAddr_reg (.clk(clk), .d32(target_in), .reset32(errorin), .q32(target_out), .error32(e1));
    razor_reg_32 B_reg (.clk(clk), .d32(B_in), .reset32(errorin), .q32(B_out), .error32(e2));
    razor_reg_32 res_reg (.clk(clk), .d32(res_in), .reset32(errorin), .q32(res_out), .error32(e3));
    razor_reg_32 regAddr_reg0(.clk(clk), .d32(regAddr_in), .reset32(errorin), .q32(regAddr_out), .error32(e4));
    razorflipflop zero_dff (.clk(clk), .d(zero_in), .reset(errorin), .q(zero_out), .error(s1));

    razorflipflop MemWr_dff(.clk(clk), .d(MemWr_in), .reset(errorin), .q(MemWr_out), .error(s2));
    razorflipflop Br_dff0(.clk(clk), .d(Br_in[0]), .reset(errorin), .q(Br_out[0]), .error(s3));
    razorflipflop Br_dff1(.clk(clk), .d(Br_in[1]), .reset(errorin), .q(Br_out[1]), .error(s4));
    razorflipflop MemtoReg_dff(.clk(clk), .d(MemtoReg_in), .reset(errorin), .q(MemtoReg_out), .error(s5));
    razorflipflop RegWr_dff(.clk(clk), .d(RegWr_in), .reset(errorin), .q(RegWr_out), .error(s6));


    // detect error!
    ALU alu1(.ctrl(3'b110), .A(e1),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v1),.R());
    ALU alu2(.ctrl(3'b110), .A(e2),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v2),.R());
    ALU alu3(.ctrl(3'b110), .A(e3),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v3),.R());
    ALU alu4(.ctrl(3'b110), .A(e4),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v4),.R());

    or_gate ec1 (.x(s1), .y(s2), .z(v5));
    or_gate ec2 (.x(s3), .y(s4), .z(v6));
    or_gate ec3 (.x(s5), .y(s6), .z(v7));
    or_gate ec4 (.x(v1), .y(v2), .z(v8));
    or_gate ec5 (.x(v3), .y(v4), .z(v9));
    or_gate ec6 (.x(v5), .y(v6), .z(v10));
    or_gate ec7 (.x(v7), .y(v8), .z(v11));
    or_gate ec8 (.x(v9), .y(v10), .z(v12));
    or_gate ec9 (.x(v11), .y(v12), .z(errorout));

    assign pcout = pcin;

endmodule