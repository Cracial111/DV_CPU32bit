class decoder_monitor extends uvm_monitor;

    `uvm_component_utils(decoder_monitor)

    virtual decoder_if vif;

    uvm_analysis_port #(decoder_seq_item) ap;

    function new(string name = "decoder_monitor",
                 uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual decoder_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Monitor cannot get interface")
    endfunction

    task run_phase(uvm_phase phase);
        decoder_seq_item item;

        forever begin
            @(posedge vif.clk);

            if (vif.valid) begin
                item = decoder_seq_item::type_id::create("item");

                item.instruction = vif.instruction;
                item.opcode      = vif.opcode;
                item.funct3      = vif.funct3;
                item.funct7      = vif.funct7;
                item.rs1         = vif.rs1;
                item.rs2         = vif.rs2;
                item.rd          = vif.rd;
                item.raw_imm     = vif.raw_imm;

                ap.write(item);
            end
        end
    endtask

endclass