INC_DIR=../../weilei_lib
CXX=g++ -O2 -Wall 
CXX2=g++ -O2 -Wall -g -m64 -std=c++0x
### -O2 -O5 -Os
#g++ `pkg-config --cflags itpp` -o hello.out hello.cpp `pkg-config --libs itpp`

START=`pkg-config --cflags itpp`
END=`pkg-config --libs itpp`
files=$(INC_DIR)/mm_read.c $(INC_DIR)/mm_read.h $(INC_DIR)/mmio.c $(INC_DIR)/mmio.h $(INC_DIR)/mm_write.c $(INC_DIR)/mm_write.h $(INC_DIR)/lib.cpp $(INC_DIR)/lib.h $(INC_DIR)/dist.c $(INC_DIR)/dist.h $(INC_DIR)/concatenation_lib.c $(INC_DIR)/concatenation_lib.h $(INC_DIR)/my_lib.h makefile
command=$(CXX) $(START) -o $@ $< $(word 2,$^) $(word 4, $^) $(word 6, $^) $(word 8, $^) $(word 10, $^) $(word 12, $^) $(END)
command2=$(CXX2) $(START) -o $@ $< $(END)
command22=$(CXX2) $(START) -o $@ $< $(word 2,$^) $(word 4, $^) $(word 6, $^) $(word 8, $^) $(word 10, $^) $(word 12, $^) $(END)
###include all headfiles into my_lib.h
generate_error.out:generate_error.cpp $(files) ../headers/errorqc.h
	$(command22)
perfect_measurement.out:perfect_measurement.cpp $(files) ../headers/errorqc.h
	$(command22)
check_circuit.out:check_circuit.cpp $(files) ../headers/errorqc.h
	$(command22)
qsim.out:Qsim.cpp ../headers/errorqc.h
	$(command2)
gnuplot_dist.out:gnuplot_dist.c $(files)
	$(command)
random_concatenation.out:random_concatenation.c $(files)
	$(command)
concatenation.out:concatenation.c $(files)
	$(command)
hypergraph.out:hypergraph.c $(files)
	$(command)

test.out:test.c $(files)
	$(command)

clean:
	rm  *~
	rm \#*

