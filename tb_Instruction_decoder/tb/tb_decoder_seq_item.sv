class decoder_seq_item extends uvm_sequence_item;

    rand bit [31:0] instruction;

    bit [6:0]  opcode;
    bit [2:0]  funct3;
    bit [6:0]  funct7;
    bit [4:0]  rs1;
    bit [4:0]  rs2;
    bit [4:0]  rd;
    bit [19:0] raw_imm;

    `uvm_object_utils_begin(decoder_seq_item)
        `uvm_field_int(instruction, UVM_DEFAULT)
        `uvm_field_int(opcode,      UVM_DEFAULT)
        `uvm_field_int(funct3,      UVM_DEFAULT)
        `uvm_field_int(funct7,      UVM_DEFAULT)
        `uvm_field_int(rs1,         UVM_DEFAULT)
        `uvm_field_int(rs2,         UVM_DEFAULT)
        `uvm_field_int(rd,          UVM_DEFAULT)
        `uvm_field_int(raw_imm,     UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "decoder_seq_item");
        super.new(name);
    endfunction

endclass