class decoder_env extends uvm_env;

    `uvm_component_utils(decoder_env)

    decoder_agent     agent;
    decoder_scoreboard scoreboard;

    function new(string name = "decoder_env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = decoder_agent::type_id::create("agent", this);

        scoreboard = decoder_scoreboard::type_id::create(
            "scoreboard", this
        );
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agent.monitor.ap.connect(scoreboard.imp);
    endfunction

endclass