# Error models in Quantum Error Correction
A convenient way to represent a quantum state is using the bloch vector (a vector in the bloch sphere). Any variation/rotation on the state is an error. We can always choose a basis to represent the state after error happen, for example, \psi --> a\psi+bX\psi+cY\psi+dZ\psi. Once we measure the state in the basis of \psi, the state will collapse to one of the four states. Those four states corresponding to the four cases: no error, X error, Y error, Z error. The first case needs no correction. In the other three cases, we need to correct X,Y,Z error respectively. As a result, instead of any rotation on the state, we only need to consider X,Y,Z errors. Furthermore, since Y is a susperposition of X and Z, in many error model, we only consider X and Z error, which are called bit-flip and phase-flip respectively.

A common simple error model is called depolorizing channel. In a depolarizing channel with error probability p, an X error will happen on a qubit with probability p/3, the same for Y and Z error.

Other than errors on qubits, there will also be error on syndrome extraction, where we measure an ancilla qubit and read the result into a classical bit. To consider this, we have the phenominogical error model with qubit error prob p and measurement error prob q. So far, most quantum error correction codes (QECCs) are designed for phenominogical error model without measurement error. The class of QECCs which are compatable to measurement error are called data-syndrome (DS) codes.

The phenomenological error model is simple and practical. However, it ignores qubit error happens during each error correction cycle. In reality, error correction takes a duration to finish. Error will happen and propogate between multi-qubit gates.

In a more realistic circuit error model, a circuit for the quantum algorithm or quantum error correction code will be designed. The gate operations on the qubits will be divided into different timesteps (or moments, as it is called in Cirq @Google). Error will be generated inbetween each timesteps. For a circuit with H, CX and CZ gate, the propogation of error is shown here.

|Incoming Error	  |H	  |CNOT	 | Phase|
|-----------------|-----|------|------|
|x,1	            |  z	| x,x	 |   x,z|
|y,1	            |  y	| y,x	 |   y,z|
|z,1	            |  x	| z,1	 |   z,1|
|1,x	            |  -	| 1,x	 |   z,x|
|1,y	            |  -	| z,y	 |   z,y|
|1,z	            |  -	| z,z	 |   1,z|

The H,CNOT, and Phase columns gives the outgoing error from the corresponding incoming error. H only acts on the first qubit. Looking at the table one can see that an (1,z) error on the CNOT will cause a z error on the data qubit. An (x,1) error will also cause an x error on the ancilla, but this is expected and used to calculate the syndrome. 
## Model for this program.
This program implement the circuit error model.








