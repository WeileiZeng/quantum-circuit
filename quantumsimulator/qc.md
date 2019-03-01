Weilei Zeng Jan 8 2019
## Summary of this folder:
 * qasm is used to generate the circuit. It show the result in pdf/png, so we can check the validity by hand. This part is done in Weilei's Macbook Air, saved and synced in Dropbox.
 * qasm2qc.sh is used to convert .qasm files into .qc files. Everything is automatically except that a number of maximum number of qubits need to be added manually to the beginning of the .qc file. (When dealing with ancilla qubits, this program increase the index of qubits by adding 10 in front, which is not a robust method and is subject to modification) 
 * generate_error.out will generate errors and save into Martrix Market format, according to the input .qc circuit file.



## Format of .qc files:
### body
[total number of qubits]

h qubit

c contorl-qubit qubit

m saved-bit qubit
### explanation
* both qubits and syndrome bit are named in pure numbers. All indexes start from 0
* use one and only one white space to seperate elements in the same row/command
* number of qubits could be larger or equal than the actual number of qubits in the system.

## list of files
* qasm2qc - convet .qasm to .qc
* generate_error.out - generate error based on .qc file
* run_generate_error.sh - run generator_error.out
* mtx2mat.m - convet .mtx into .mat for GI code
* mtx2matCircuit.m - convert .matx to .mat for GA code.
* Qsim.cpp, qsim.out - test for the circuit, with one input error.


TODO:
save all syndrome measurement for single error, which should return the parity check matrix. This works as a check for the circuit. Currently it is done by enter single error manullay using the qsim.out.
