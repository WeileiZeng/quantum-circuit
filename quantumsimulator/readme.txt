Weilei Zeng Jan 8 2019
Summary of the project:
 - qasm is used to generate the circuit. It show the result in pdf/png, so we can check the validity by hand. This part is done in Weilei's Macbook Air, saved and synced in Dropbox.
 - qasm2qc.sh is used to convert .qasm files into .qc files. Everything is automatically except that a number of maximum number of qubits need to be added manually to the beginning of the .qc file. (When dealing with ancilla qubits, this program increase the index of qubits by adding 10 in front, which is not a robust method and is subject to modification) 
 - generate_error.out will generate errors and save into Martrix Market format, according to the input .qc circuit file.


Weilei Zeng Dec 9 2018
Format of .qc files:
[number of qubits]
h qubit
c qubit control-qubit
m saved-bit qubit

>>all index start from 0
>>use one and only one white space to seperate elements in the same row/command
>>number of qubits could be larger or equal than the actual number of qubits in the system.
