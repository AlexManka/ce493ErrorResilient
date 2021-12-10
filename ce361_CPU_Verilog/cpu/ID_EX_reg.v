// `include "cpu/reg_32.v"
// `include "lib/dff.v"
// `include "extralib/not_gate_n2.v"

module ID_EX_reg(clk, pc_in, pc_out, A_in, A_out, B_in, B_out, instr_in, instr_out,
    ExtOp_in, ALUSrc_in, ALUOp_in, RegDst_in, MemWr_in, Br_in, MemtoReg_in, RegWr_in, ExtOp_out, ALUSrc_out, ALUOp_out, RegDst_out, MemWr_out, Br_out, MemtoReg_out, RegWr_out, pcout, errorout, errorin, pcin);
    
    input clk;

    // datapath signals
    input [31:0] pc_in;
    input [31:0] A_in;
    input [31:0] B_in;
    input [31:0] instr_in;
    output [31:0] pc_out;
    output [31:0] A_out;
    output [31:0] B_out;
    output [31:0] instr_out;

    // control signals
    input ExtOp_in;
    input ALUSrc_in;
    input [2:0] ALUOp_in;
    input RegDst_in;
    input MemWr_in;
    input [1:0] Br_in;
    input MemtoReg_in;
    input RegWr_in;
    output ExtOp_out;
    output ALUSrc_out;
    output [2:0] ALUOp_out;
    output RegDst_out;
    output MemWr_out;
    output [1:0] Br_out;
    output MemtoReg_out;
    output RegWr_out;


    input errorin;
    output [31:0] pcout;
    output errorout;
    output [31:0] pcin;

    wire [31:0] e1, e2, e3, e4;
    wire s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11;
    wire v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17;

    razor_reg_32 pc_reg (.clk(clk), .d32(pc_in), .reset32(errorin), .q32(pc_out), .error32(e1));
    razor_reg_32 A_reg (.clk(clk), .d32(A_in), .reset32(errorin), .q32(A_out), .error32(e2));
    razor_reg_32 B_reg (.clk(clk), .d32(B_in), .reset32(errorin), .q32(B_out), .error32(e3));
    razor_reg_32 instr_reg (.clk(clk), .d32(instr_in), .reset32(errorin), .q32(instr_out), .error32(e4));

    razorflipflop ALUSrc_dff(.clk(clk), .d(ALUSrc_in), .reset(errorin), .q(ALUSrc_out), .error(s1));
    razorflipflop ExtOp_dff(.clk(clk), .d(ExtOp_in), .reset(errorin), .q(ExtOp_out), .error(s2));
    razorflipflop ALUOp_dff0(.clk(clk), .d(ALUOp_in[0]), .reset(errorin), .q(ALUOp_out[0]), .error(s3));
    razorflipflop ALUOp_dff1(.clk(clk), .d(ALUOp_in[1]), .reset(errorin), .q(ALUOp_out[1]), .error(s4));
    razorflipflop ALUOp_dff2(.clk(clk), .d(ALUOp_in[2]), .reset(errorin), .q(ALUOp_out[2]), .error(s5));
    razorflipflop RegDst_dff(.clk(clk), .d(RegDst_in), .reset(errorin), .q(RegDst_out), .error(s6));
    razorflipflop MemWr_dff(.clk(clk), .d(MemWr_in), .reset(errorin), .q(MemWr_out), .error(s7));
    razorflipflop Br_dff0(.clk(clk), .d(Br_in[0]), .reset(errorin), .q(Br_out[0]), .error(s8));
    razorflipflop Br_dff1(.clk(clk), .d(Br_in[1]), .reset(errorin), .q(Br_out[1]), .error(s9));
    razorflipflop MemtoReg_dff(.clk(clk), .d(MemtoReg_in), .reset(errorin), .q(MemtoReg_out), .error(s10));
    razorflipflop RegWr_dff(.clk(clk), .d(RegWr_in), .reset(errorin), .q(RegWr_out), .error(s11));


    // get error out!
    ALU alu1(.ctrl(3'b110), .A(e1),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v1),.R());
    ALU alu2(.ctrl(3'b110), .A(e2),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v2),.R());
    ALU alu3(.ctrl(3'b110), .A(e3),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v3),.R());

    or_gate ec1 (.x(s1), .y(s2), .z(v5));
    or_gate ec2 (.x(s3), .y(s4), .z(v6));
    or_gate ec3 (.x(s5), .y(s6), .z(v7));
    or_gate ec11 (.x(s7), .y(s8), .z(v8));
    or_gate ec22 (.x(s9), .y(s10), .z(v9));
    or_gate ec33 (.x(s11), .y(v1), .z(v10));
    or_gate ec44 (.x(v10), .y(v2), .z(v11));
    or_gate ec5 (.x(v3), .y(v5), .z(v12));
    or_gate ec6 (.x(v7), .y(v8), .z(v13));
    or_gate ec7 (.x(v9), .y(v8), .z(v14));
    or_gate ec8 (.x(v10), .y(v11), .z(v15));
    or_gate ec81 (.x(v12), .y(v13), .z(v16));
    or_gate ec82 (.x(v14), .y(v15), .z(v17));
    or_gate ec9 (.x(v17), .y(v16), .z(errorout));

    assign pcout = pcin;

endmodule