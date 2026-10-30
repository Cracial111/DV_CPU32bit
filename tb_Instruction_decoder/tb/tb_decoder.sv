module tb_decoder;

    import uvm_pkg::*;
    import decoder_uvm_pkg::*;

    logic clk = 0;

    // Clock chu kỳ 10 ns
    always #5 clk = ~clk;

    // Interface kết nối testbench với DUT
    decoder_if vif(clk);

    // Design Under Test
    Instruction_Decoder dut (
        .instruction (vif.instruction),
        .opcode      (vif.opcode),
        .funct3      (vif.funct3),
        .funct7      (vif.funct7),
        .rs1         (vif.rs1),
        .rs2         (vif.rs2),
        .rd          (vif.rd),
        .raw_imm     (vif.raw_imm)
    );

    initial begin
        // Đưa interface vào UVM để driver và monitor truy cập
        uvm_config_db#(virtual decoder_if)::set(
            null, "*", "vif", vif
        );

        run_test("decoder_test");
    end

endmodule