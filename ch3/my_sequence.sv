class my_sequence extends uvm_sequence #(my_transaction);
  my_transaction m_trans;
  function new(string name = "my_sequence");
      super.new(name);
  endfunction

  virtual task body();
    starting_phase=get_starting_phase();
    if(starting_phase != null)
        starting_phase.raise_objection(this);
    repeat (10) begin
        `uvm_do_with(m_trans, {m_trans.crc_err == 1;});
    end
    #1000;
    if(starting_phase != null)
        starting_phase.drop_objection(this);
   endtask
  `uvm_object_utils(my_sequence)
endclass