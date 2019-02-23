# 
# File:   test1.qasm
# Date:   22-Mar-04
# Author: I. Chuang <ichuang@mit.edu>
#
# Sample qasm input file - EPR creation
#
        qubit 	q0
        qubit 	q1
	qubit	q2
	qubit	q3
	qubit	q4
	
	cnot	q1,q0
	cnot	q2,q4
	cnot	q2,q0
	cnot	q3,q4

	measure	q0
	measure q4
