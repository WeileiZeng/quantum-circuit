# quantum-circuit
A quantum circuit simulator, with depolorizing noise channel.

In the level of quantum error corection, all calculation can be classical. Hence, this simulator never touch the wave function or density matrix of the qubit system. It takes the circuit as input, divides all gates into consecutive timesteps(moments), then add depolarizing error in between different timesteps.

Cirq (google's open project) hasnot implemented noise channel. It is planned to add noise in a similar fashion. The same result would be expected for this program and cirq, on the depolarizing channel. Meanwhile, this program is adaptable to other channels.

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
  Input: .qc file describe the circuit
  Output: .mtx (MatrixMarket) files saves the error and syndrome respectively. ( A matlab progam can be used to convert the result into .mat files, which would be 1000x faster for matlab programs to read)
* visualize the circuit
  * write the circuit in the format .qasm; use qasm2pdf to convert the file into pdf.
  * use qasm2qc to convert the .qasm to .qc autumatically. (300 qubits in total, 200+ is for ancilla qubits)
  * use copier to copy some part of the circuit; useful for enlarge the size of the circuit.
  Input: .qasm files decribe the circuit
  Output: .pdf file to visualize the circuit, and .qc file describes the same circuit.
  
