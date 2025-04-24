class my_driver extends uvm_driver;
  `uvm_component_utils(my_driver)
  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("my_driver", "new is called", UVM_LOW);
  endfunction
  extern virtual task main_phase(uvm_phase phase);
  extern virtual task drive_one_pkt(my_transaction tr);
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("my_driver", "build_phase is called", UVM_LOW);
      if(~uvm_config_db # (virtual my_if)::get(this, "", "vif", vif))
        `uvm_fatal("my_driver", "virtual interface must be set for vif!!")
  endfunction
  virtual my_if vif;
endclass

task my_driver::main_phase(uvm_phase phase);
  my_transaction tr;
  phase.raise_objection(this);
  `uvm_info("my_driver", "main_phase is called", UVM_LOW);
  vif.data <= 8'd0;
  vif.valid <= 1'b0;
  while(!vif.rst_n)
    @(posedge vif.clk);
  for(int i = 0; i < 2; i++) begin
     tr = new("tr");
     assert(tr.randomize() with {pload.size == 200;});
     drive_one_pkt(tr);
  end
   repeat(5) @(posedge vif.clk);
   vif.valid <= 1'b0;
   phase.drop_objection(this);
endtask

task my_driver::drive_one_pkt(my_transaction tr);
  bit [47:0] temp_data;
  bit [7:0] data_q[$];
  temp_data = tr.dmac;
  for(int i = 0; i < 6; i++) begin
      data_q.push_back(temp_data[7:0]);
      temp_data = temp_data >> 8;
  end
  temp_data = tr.crc;
  for(int i = 0; i < 4; i++) begin
      data_q.push_back(temp_data[7:0]);
      temp_data = temp_data >> 8;
  end
  `uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
   repeat(3) @(posedge vif.clk);
   while(data_q.size() > 0) begin
      @(posedge vif.clk);
      vif.valid <= 1'b1;
      vif.data <= data_q.pop_front();
   end
   @(posedge vif.clk);
   vif.valid <= 1'b0;
   `uvm_info("my_driver", "end drive one pkt", UVM_LOW);
endtask
