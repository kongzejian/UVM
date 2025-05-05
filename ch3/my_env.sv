class my_env extends uvm_env;
    my_agent i_agt;
    my_agent o_agt;
    my_model model;
    my_scoreboard scb;
    uvm_tlm_analysis_fifo #(my_transaction) agt_mdl_fifo;
    uvm_tlm_analysis_fifo #(my_transaction) agt_scb_fifo;
    uvm_tlm_analysis_fifo #(my_transaction) mdl_scb_fifo;
    function new (string name = "my_env", uvm_component parent);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i_agt = my_agent::type_id::create("i_agt", this);
        o_agt = my_agent::type_id::create("o_agt", this);
        i_agt.is_active = UVM_ACTIVE;
        o_agt.is_active = UVM_PASSIVE;
        model = my_model::type_id::create("model", this);
        agt_mdl_fifo = new("agt_mdl_fifo", this); //agent to reference model
        agt_scb_fifo = new("agt_scb_fifo", this); //dut to scoreboard
        mdl_scb_fifo = new("mdl_scb_fifo", this); //reference model to scoreboard
        scb = my_scoreboard::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //agent to reference model
        i_agt.ap.connect(agt_mdl_fifo.analysis_export);
        model.port.connect(agt_mdl_fifo.blocking_get_export);
        //dut to scoreboard
        o_agt.ap.connect(agt_scb_fifo.analysis_export);
        scb.act_port.connect(agt_scb_fifo.blocking_get_export);
        //reference model to scoreboard
        model.ap.connect(mdl_scb_fifo.analysis_export);
        scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
    endfunction

    `uvm_component_utils(my_env)

endclass