# quantum-circuit
A quantum circuit simulator, with random error generated in each time frame

Dated: Feb 22, 2019
Authors: Machael Woolls, Weilei Zeng


## package used:
 * cpp: Eigen  -linear algebra
 * cpp: itpp   -linear algebra
 * qasm (not necessary)    -quantum circuit visualization
 * tex (not neceaasry)      -visualize the circuit in pdf format
## How to use
* main program
  * design the circuit (by hand)
  * write the circuit inthe format .qc
  * use generate_error.cpp to generate errors from this circuit
* visualize the circuit
  * write the circuit in the format .qasm; use qasm2pdf to convert the file into pdf.
  * use qasm2qc to convert the .qasm to .qc autumatically. (300 qubits in total, 200+ is for ancilla qubits)
  * use copier to copy some part of the circuit; useful for enlarge the size of the circuit.
  
