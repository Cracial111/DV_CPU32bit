interface decoder_if(input logic clk);

    logic        valid;
    logic [31:0] instruction;

    logic [6:0]  opcode;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic [19:0] raw_imm;

endinterface 