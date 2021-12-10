module stallcheck3 (curr, prev1, prev2, prev3, stall);
    input [31:0] curr, prev1, prev2, prev3;
    output stall;
    wire RegWriteCurr, RegWrite1, RegWrite2, RegWrite3;
    wire [1:0] BranchCurr, Branch1, Branch2, Branch3;
    wire branches, prevwrite, stallcond3;
    control ctrlcurr (.op(curr[31:26]), .RegDst(), .ALUSrc(), .MemtoReg(), .RegWrite(RegWriteCurr), .MemWrite(), .Branch(BranchCurr), .ExtOp(), .ALUop());
    control ctrl1 (.op(prev1[31:26]), .RegDst(), .ALUSrc(), .MemtoReg(), .RegWrite(RegWrite1), .MemWrite(), .Branch(Branch1), .ExtOp(), .ALUop());
    control ctrl2 (.op(prev2[31:26]), .RegDst(), .ALUSrc(), .MemtoReg(), .RegWrite(RegWrite2), .MemWrite(), .Branch(Branch2), .ExtOp(), .ALUop());
    control ctrl3 (.op(prev3[31:26]), .RegDst(), .ALUSrc(), .MemtoReg(), .RegWrite(RegWrite3), .MemWrite(), .Branch(Branch3), .ExtOp(), .ALUop());

    // If branch, then stall
    or_gate branch_check(.x(BranchCurr[0]), .y(BranchCurr[1]), .z(branches));

    // If any previous write to register, then chance to stall, (but ignore if already stalled? DEFINITELY ignore zero register)
    or3to1 writechecker(.w(RegWrite1), .x(RegWrite2), .y(RegWrite3), .z(prevwrite));






endmodule

module zero_5bit (x, z);
    input [4:0] x;
    output z;
    wire or1;
    or_gate_n twobitor (.x(x[4:3]), .y(x[2:1]), .z(or1));
    defparam twobitor.n = 2;
    or_gate lastor (.x(or1), .y(x[0]), .z(z));
endmodule
module compare5bit (x, y, z);
    input [4:0] x,y;
    output z;
    wire [4:0] inbetween;
    xor_gate_n xorer(.x(x), .y(y), .z(inbetween));
    defparam xorer.n = 5;
    zero_5bit zeroer(.x(inbetween), .z(z));
endmodule
module zero_6bit (x, z);
    input [5:0] x;
    output z;
    wire or1, or2;
    or3to1 threebitor1 (.w(x[3]), .x(x[5]), .y(x[4]), .z(or1));
    or3to1 threebitor2 (.w(x[2]), .x(x[1]), .y(x[0]), .z(or2));
    or_gate lastor (.x(or1), .y(or2), .z(z));
endmodule
module compare6bit (x, y, z);
    input [5:0] x,y;
    output z;
    wire [5:0] inbetween;
    xor_gate_n xorer(.x(x), .y(y), .z(inbetween));
    defparam xorer.n = 6;
    zero_6bit zeroer(.x(inbetween), .z(z));
endmodule
module zero_32bit (x, z);
    input [31:0] x;
    output z;
    wire [15:0] or1;
    wire [7:0] or2;
    wire [3:0] or3;
    wire [1:0] or4;
    or_gate_n sixteenbitor (.x(x[31:16]), .y(x[15:0]), .z(or1));
    defparam sixteenbitor.n = 16;
    or_gate_n eightbitor (.x(x[16:8]), .y(x[7:0]), .z(or2));
    defparam eightbitor.n = 8;
    or_gate_n fourbitor (.x(x[8:4]), .y(x[3:0]), .z(or3));
    defparam fourbitor.n = 4;
    or_gate_n twobitor (.x(x[3:2]), .y(x[1:0]), .z(or4));
    defparam twobitor.n = 2;
    or_gate lastor (.x(or4[0]), .y(or4[1]), .z(z));
endmodule

module compare32bit (x, y, z);
    input [31:0] x,y;
    output z;
    wire [31:0] inbetween;
    xor_gate_n xorer(.x(x), .y(y), .z(inbetween));
    defparam xorer.n = 32;
    zero_32bit zeroer(.x(inbetween), .z(z));
endmodule