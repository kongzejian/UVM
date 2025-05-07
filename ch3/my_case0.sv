class case0_sequence extends uvm_sequence #(my_transaction);
  my_transaction m_trans;
  function new(string name = "sequence0_sequence");
      super.new(name);
  endfunction

  virtual task body();
    starting_phase = get_starting_phase();
    if(starting_phase != null)
        starting_phase.raise_objection(this);
    repeat (10) begin
        `uvm_do(m_trans);
    end
    #100;
    if(starting_phase != null)
        starting_phase.drop_objection(this);
   endtask
  `uvm_object_utils(case0_sequence)
endclass


class my_case0 extends uvm_test;
  my_env env;
  function new(string name = "my_case0", uvm_component parent = null);
      super.new(name, parent);
  endfunction
  extern virtual function void build_phase(uvm_phase phase);
  `uvm_component_utils(my_case0)
endclass

function void my_case0::build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = my_env::type_id::create("env", this);
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", case0_sequence::type_id::get());
  uvm_config_db # (int)::set(null, "uvm_test_top.env.i_agt.drv", "pre_num", 4);
endfunction
