class decoder_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(decoder_scoreboard)

    uvm_analysis_imp #(decoder_seq_item, decoder_scoreboard) imp;

    int pass_count = 0;
    int fail_count = 0;

    function new(string name = "decoder_scoreboard",
                 uvm_component parent = null);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction

    // Tính output mong đợi từ instruction
    function automatic decoder_seq_item reference_model(
        bit [31:0] inst
    );
        decoder_seq_item exp;

        exp = decoder_seq_item::type_id::create("exp");

        exp.instruction = inst;
        exp.opcode  = inst[6:0];
        exp.funct3  = 0;
        exp.funct7  = 0;
        exp.rs1     = 0;
        exp.rs2     = 0;
        exp.rd      = 0;
        exp.raw_imm = 0;

        case (inst[6:0])

            `OPCODE_LUI, `OPCODE_AUIPC: begin
                exp.rd      = inst[11:7];
                exp.raw_imm = inst[31:12];
            end

            `OPCODE_JAL: begin
                exp.rd = inst[11:7];
                exp.raw_imm = {
                    inst[31], inst[19:12],
                    inst[20], inst[30:21]
                };
            end

            `OPCODE_JALR,
            `OPCODE_LOAD,
            `OPCODE_ITYPE,
            `OPCODE_FENCE,
            `OPCODE_ENVIRONMENT: begin
                exp.rd      = inst[11:7];
                exp.funct3  = inst[14:12];
                exp.rs1     = inst[19:15];
                exp.raw_imm = {8'b0, inst[31:20]};
            end

            `OPCODE_BRANCH: begin
                exp.funct3  = inst[14:12];
                exp.rs1     = inst[19:15];
                exp.rs2     = inst[24:20];
                exp.raw_imm = {
                    inst[31], inst[7],
                    inst[30:25], inst[11:8]
                };
            end

            `OPCODE_STORE: begin
                exp.funct3  = inst[14:12];
                exp.rs1     = inst[19:15];
                exp.rs2     = inst[24:20];
                exp.raw_imm = {
                    8'b0, inst[31:25], inst[11:7]
                };
            end

            `OPCODE_RTYPE: begin
                exp.rd     = inst[11:7];
                exp.funct3 = inst[14:12];
                exp.rs1    = inst[19:15];
                exp.rs2    = inst[24:20];
                exp.funct7 = inst[31:25];
            end

            default: begin
                // Các output ngoài opcode đều giữ bằng 0
            end

        endcase

        return exp;
    endfunction

    // Được gọi tự động khi monitor gửi item
    function void write(decoder_seq_item actual);
        decoder_seq_item expected;

        expected = reference_model(actual.instruction);

        if (
            actual.opcode  !== expected.opcode  ||
            actual.funct3  !== expected.funct3  ||
            actual.funct7  !== expected.funct7  ||
            actual.rs1     !== expected.rs1     ||
            actual.rs2     !== expected.rs2     ||
            actual.rd      !== expected.rd      ||
            actual.raw_imm !== expected.raw_imm
        ) begin
            fail_count++;

            `uvm_error("DECODER_MISMATCH",
                $sformatf(
                    "FAIL inst=%08h | opcode actual=%02h expected=%02h | rd actual=%0d expected=%0d | rs1 actual=%0d expected=%0d | rs2 actual=%0d expected=%0d | raw_imm actual=%05h expected=%05h",
                    actual.instruction,
                    actual.opcode, expected.opcode,
                    actual.rd, expected.rd,
                    actual.rs1, expected.rs1,
                    actual.rs2, expected.rs2,
                    actual.raw_imm, expected.raw_imm
                )
            );
        end
        else begin
            pass_count++;

            `uvm_info("DECODER_PASS",
                $sformatf(
                    "PASS inst=%08h opcode=%02h rd=%0d rs1=%0d rs2=%0d raw_imm=%05h",
                    actual.instruction,
                    actual.opcode,
                    actual.rd,
                    actual.rs1,
                    actual.rs2,
                    actual.raw_imm
                ),
                UVM_MEDIUM
            );
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("SUMMARY",
            $sformatf("PASS=%0d FAIL=%0d",
                      pass_count, fail_count),
            UVM_NONE)
    endfunction

endclass