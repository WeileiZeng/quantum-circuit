## Review of open-source quantum computer simulators in the aspect of quantum error correction code

Currently there are many early-stage quantum devices available from Google, IBM, etc. At the same time, a lot of quantum virtual machines(QVM) are available, inlcuding Forest (pyQuil), QISKit, ProjectQ, the Quantum Developer Kit and Cirq. They simulate the quantum computers in the level of density matrix or wave function. These are wonderful platforms, allowing us to test quantum algorithms and preparing us for larger scale quantum computing. A comprehensive review on those platform can be seen here
[[1]](https://quantumcomputingreport.com/scorecards/review-of-the-cirq-quantum-software-framework/) 
[[2]](https://quantumcomputingreport.com/wp-content/uploads/2018/06/Overview-and-Comparison-of-Gate-Level-Quantum-Software-Platforms-Final-June-21-2018.pdf)

However, in the scenario of Quantum Error Correction(QEC), a technique to stabilize the quantum states, one doesn't really need access to the quantum state itself, but rather the errors which can be classified into X,Y,Z type. This means all calculation could be done classically, and a much simpler and faster simulation can be used for QEC. In this sense, our _quantum circuit_ project is sufficient and effcient for QEC simulation. Those simulation can also be done by those full quantum simulators, but in a much slower way. Here we summarize the current status of the capacity of noise channel of several platforms.

updated: March 1, 2019
* Cirq @Google

  noise channel is in process and is currently not avavailable. [[3]](https://github.com/quantumlib/Cirq/issues/730)

* pyQuil @Rigetti

  Both qubit error and measurement(read-out) error are available with depolorizing channel.[[4]](https://pyquil.readthedocs.io/en/latest/noise.html)

* QISKit @IBM

  Error model available [[5]](https://github.com/Qiskit/qiskit/blob/cb9a78fc981ccc5423069a72762123b7ad6c7586/docs/aer/device_noise_simulation.rst)
  
  
  note: All these platforms are open-source and are built by community. They may be mainly used by those companies but are not necessary official product of them.
