class decoder_sequence extends uvm_sequence #(decoder_seq_item);

    `uvm_object_utils(decoder_sequence)

    function new(string name = "decoder_sequence");
        super.new(name);
    endfunction

    task body();
        decoder_seq_item item;

        // 1. R-type: ADD x3, x1, x2
        item = decoder_seq_item::type_id::create("item_r");
        start_item(item);
        item.instruction = {
            7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011
        };
        finish_item(item);

        // 2. I-type: ADDI x4, x1, 5
        item = decoder_seq_item::type_id::create("item_i");
        start_item(item);
        item.instruction = {
            12'd5, 5'd1, 3'b000, 5'd4, 7'b0010011
        };
        finish_item(item);

        // 3. Load
        item = decoder_seq_item::type_id::create("item_load");
        start_item(item);
        item.instruction = {
            12'd8, 5'd2, 3'b010, 5'd5, 7'b0000011
        };
        finish_item(item);

        // 4. Store
        item = decoder_seq_item::type_id::create("item_store");
        start_item(item);
        item.instruction = {
            7'd0, 5'd3, 5'd2, 3'b010, 5'd8, 7'b0100011
        };
        finish_item(item);

        // 5. Branch
        item = decoder_seq_item::type_id::create("item_branch");
        start_item(item);
        item.instruction = {
            1'b0, 6'b000000, 5'd2, 5'd1,
            3'b000, 4'b0010, 1'b0, 7'b1100011
        };
        finish_item(item);

        // 6. LUI
        item = decoder_seq_item::type_id::create("item_lui");
        start_item(item);
        item.instruction = {
            20'h12345, 5'd6, 7'b0110111
        };
        finish_item(item);

        // 7. JAL
        item = decoder_seq_item::type_id::create("item_jal");
        start_item(item);
        item.instruction = {
            1'b0, 10'b0000000010, 1'b0, 8'b00000000,
            5'd1, 7'b1101111
        };
        finish_item(item);

        // 8. Opcode không được hỗ trợ: kiểm tra default
        item = decoder_seq_item::type_id::create("item_default");
        start_item(item);
        item.instruction = 32'h00000000;
        finish_item(item);

    endtask

endclass