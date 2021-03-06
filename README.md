### This repo has been moved to https://github.com/WeileiZeng/clifford-circuit

# quantum-circuit
Date: Jun 2018 - Feb 2019.   Authors: Michael Woolls(UCR), Weilei Zeng(UCR)

[A quantum circuit simulator, with depolorizing noise channel.](ErrorModel.md)

In the level of quantum error corection(QEC), all calculation can be classical. Hence, a simulator for quantum error correction could never touch the wave function or density matrix of the qubit system and result in a much faster speed, as it is done in our simulator. It takes the circuit as input, divides all gates into consecutive timesteps(moments), then add depolarizing error in between different timesteps. Measurement/read-out errors can be added outside of this program.(We may implement this in the future)

Other than our program, there are many powerful quantum simulators available right now. However, since they are full simulator inthe level of density matrix or wave function, they are very slow in speed and provide much more information than QEC's need. Here is a [review](QuantumVirtualMachine.md) of them in the aspect of QEC.

## package used:
 * c++: Eigen  -linear algebra
 * c++: itpp   -linear algebra
 * [qasm](qasm2circ-v1.4) (not necessary)    -visualization of quantum circuit, see its [main page](https://www.media.mit.edu/quanta/qasm2circ/)
 * TeX (not neceaasry)      -visualize the circuit in pdf format
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
  
