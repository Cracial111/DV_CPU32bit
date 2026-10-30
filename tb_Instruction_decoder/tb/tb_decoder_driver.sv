class decoder_driver extends uvm_driver #(decoder_seq_item);

    `uvm_component_utils(decoder_driver)

    virtual decoder_if vif;

    function new(string name = "decoder_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual decoder_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Driver cannot get interface")
    endfunction

    task run_phase(uvm_phase phase);
        decoder_seq_item item;

        vif.valid = 0;
        vif.instruction = 0;

        forever begin
            seq_item_port.get_next_item(item);

            @(negedge vif.clk);
            vif.instruction = item.instruction;
            vif.valid = 1;

            // Monitor sẽ lấy mẫu ở cạnh lên kế tiếp
            @(negedge vif.clk);
            vif.valid = 0;

            seq_item_port.item_done();
        end
    endtask

endclass