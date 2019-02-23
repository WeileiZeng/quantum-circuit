# 
# File:   test1.qasm
# Date:   22-Mar-04
# Author: I. Chuang <ichuang@mit.edu>
#
# Sample qasm input file - EPR creation
#
#define qubits, ancilla qubits and syndrome bits
	qubit	A0,0
        qubit 	q0
        qubit 	q1
	qubit	q2
	qubit	A1,0
	cbit	s1,0
	cbit	s2,0
	qubit	A2,0
	qubit	q3
	qubit	q4
	qubit	q5
	qubit	A3,0
	cbit	s3,0
	cbit	s4,0
	qubit	A4,0
	qubit	q6
	qubit	q7
	qubit	q8
	qubit	A5,0

#measure Z_iZ_i+1
	cnot	q0,A0
	cnot	q1,A1
	cnot	q1,A0
	cnot	q2,A1
	cnot	q3,A2
	cnot	q4,A3
	cnot	q4,A2
	cnot	q5,A3
	cnot	q6,A4
	cnot	q7,A5
	cnot	q7,A4
	cnot	q8,A5

	measure	A0
	measure A1
	cnot	A1,s1
	zero A1

	measure	A2
	measure A3
	cnot	A2,s2
	cnot	A3,s3
	zero A2
	zero A3

	measure	A4
	measure A5
	cnot	A4,s4
	zero A4

#measure XXX XXX
	nop  q0
	nop  q3
	nop  q6
	H q0
	H q1
	H q2
	H q3
	H q4
	H q5
	H q6
	H q7
	H q8

	cnot	q0,A1
	cnot	q1,A1
	cnot	q2,A1
	cnot	q3,A2
	cnot	q4,A3
	cnot	q4,A2
	cnot	q5,A3
	cnot	q5,A2
	cnot	q3,A3
	cnot	q6,A4
	cnot	q7,A4
	cnot	q8,A4

	cnot	A2,A1
	measure	A2
	cnot	A3,A4
	measure	A3

	nop	q0
	nop	q0
	nop	q1
	nop	q4
	nop	q6
	nop	q6
	nop	q7

	H q0
	H q1
	H q2
	H q3
	H q4
	H q5
	H q6
	H q7
	H q8
