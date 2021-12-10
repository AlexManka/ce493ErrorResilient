// `include "cpu/reg_32.v"
// `include "lib/dff.v"
// `include "extralib/not_gate_n2.v"

module MEM_WR_reg(clk, mem_in, mem_out, B_in, B_out, regWrAddr_in, regWrAddr_out, MemtoReg_in, MemtoReg_out, RegWr_in, RegWr_out, pcout, errorout, errorin, pcin);
    input clk;

    // datapath signals
    input [31:0] mem_in;
    input [31:0] B_in;
    input [31:0] regWrAddr_in;
    output [31:0] mem_out;
    output [31:0] B_out;
    output [31:0] regWrAddr_out;

    // control signals
    input MemtoReg_in;
    input RegWr_in;
    output MemtoReg_out;
    output RegWr_out;

    input errorin;
    output [31:0] pcout;
    output errorout;
    output [31:0] pcin;

    wire [31:0] e1, e2, e3;
    wire s1, s2;
    wire v1, v2, v3, v4, v5, v6;

    razor_reg_32 mem_dff (.clk(clk), .d32(mem_in), .reset32(errorin), .q32(mem_out), .error32(e1));
    razor_reg_32 B_reg (.clk(clk), .d32(B_in), .reset32(errorin), .q32(B_out), .error32(e2));
    razor_reg_32 rwa_reg (.clk(clk), .d32(regWrAddr_in), .reset32(errorin), .q32(regWrAddr_out), .error32(e3));

    razorflipflop MemtoReg_dff(.clk(clk), .d(MemtoReg_in), .reset(errorin), .q(MemtoReg_out), .error(s1));
    razorflipflop RegWr_dff(.clk(clk), .d(RegWr_in), .reset(errorin), .q(RegWr_out), .error(s2));

    //detect error
    ALU alu1(.ctrl(3'b110), .A(e1),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v1),.R());
    ALU alu2(.ctrl(3'b110), .A(e2),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v2),.R());
    ALU alu3(.ctrl(3'b110), .A(e3),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v3),.R());

    or_gate ec1 (.x(s1), .y(s2), .z(v5));
    or_gate ec2 (.x(v1), .y(v2), .z(v6));
    or_gate ec3 (.x(v3), .y(v5), .z(v4));
    or_gate final (.x(v6), .y(v4), .z(errorout));

    assign pcout = pcin;
endmodule