// `include "cpu/reg_32.v"
// `include "extralib/not_gate_n2.v"

module IF_ID_reg(clk, pc_in, instr_in, pc_out, instr_out, pcout, errorout, errorin);
    input clk;

    // datapath signals
    input [31:0] pc_in;
    input [31:0] instr_in;
    output [31:0] pc_out;
    output [31:0] instr_out;
    input errorin;
    output [31:0] pcout;
    output errorout;

    wire [31:0] e1, e2;
    wire v1, v2;

    razor_reg_32 pc_reg (.clk(clk), .d32(pc_in), .reset32(errorin), .q32(pc_out), .error32(e1));
    razor_reg_32 instr_reg (.clk(clk), .d32(instr_in), .reset32(errorin), .q32(instr_out), .error32(e2));

    // must xor error
    ALU alu1(.ctrl(3'b110), .A(e1),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v1),.R());
    ALU alu2(.ctrl(3'b110), .A(e2),.B(32'b0),.shamt(5'b0),.cout(),.ovf(),.ze(v2),.R());

    or_gate ec1(.x(v1), .y(v2), .z(errorout));


    assign pcout = pc_out;


endmodule


