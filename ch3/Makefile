
INCDIR = +incdir+./ 
#SIM_ARG = +UVM_TESTNAME=uart_test

all:run

cmp:
	vcs -full64 -sverilog -ntb_opts uvm-1.2 -q $(INCDIR) top_tb.sv -l cmp.log -o simv -debug_access+all -kdb -lca -timescale=1ns/1ps 
run:cmp
	./simv -l sim.log +UVM_VERDI_TRACE=UVM_AWARE+HIER+RAL+COMPWAVE $(SIM_ARG)

clean:
	rm -rf cmp.log
	rm -rf ./csrc
	rm -rf novas*
	rm -rf simv*
	rm -rf *.log
	rm -rf *.h
	rm -rf *.key
	rm -rf *.fsdb
	rm -rf verdiLog
	rm -rf output.txt
	rm -rf verdi_config_file