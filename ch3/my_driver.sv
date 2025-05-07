class my_driver extends uvm_driver #(my_transaction);
  int pre_num;
  `uvm_component_utils_begin(my_driver)
      `uvm_field_int(pre_num, UVM_ALL_ON)
  `uvm_component_utils_end
  function new(string name = "my_driver", uvm_component parent = null);
    super.new(name, parent);
    pre_num = 3;
    `uvm_info("my_driver", "new is called", UVM_LOW);
  endfunction
  extern virtual task main_phase(uvm_phase phase);
  extern virtual task drive_one_pkt(my_transaction tr);
  virtual function void build_phase(uvm_phase phase);
      `uvm_info("my_driver", $sformatf("before super.build_phase, the pre_num is %0d", pre_num), UVM_LOW)
      super.build_phase(phase);
      `uvm_info("my_driver", $sformatf("after super.build_phase, the pre_num is %0d", pre_num), UVM_LOW) 
      //$display("%s", get_full_name());
      `uvm_info("my_driver", "build_phase is called", UVM_LOW);
      if(~uvm_config_db # (virtual my_if)::get(this, "", "vif", vif))
        `uvm_fatal("my_driver", "virtual interface must be set for vif!!")
  endfunction
  virtual my_if vif;
endclass

task my_driver::main_phase(uvm_phase phase);
  vif.data <= 8'd0;
  vif.valid <= 1'b0;
  while(!vif.rst_n)
    @(posedge vif.clk);
  while(1) begin
     seq_item_port.try_next_item(req);
      if(req == null)
          @(posedge vif.clk);
      else begin
          drive_one_pkt(req);
          seq_item_port.item_done(); //handshake mechanism
      end
  end
endtask

task my_driver::drive_one_pkt(my_transaction tr);
  byte unsigned data_q[];
  int data_size;

  data_size = tr.pack_bytes(data_q) / 8;
  `uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
   repeat(3) @(posedge vif.clk);
   for(int i = 0; i < data_size; i++) begin
      @(posedge vif.clk);
      vif.valid <= 1'b1;
      vif.data <= data_q[i];
   end
   @(posedge vif.clk);
   vif.valid <= 1'b0;
   `uvm_info("my_driver", "end drive one pkt", UVM_LOW);
endtask
