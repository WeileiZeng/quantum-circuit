# Weilei Zeng, see weilei_readme.txt
# A circuit to measure G_1
# somehow this circuit have to start with q0 in the beginning, which could be emitted when we crop the image of the circuit.

  qubit	   q0
  qubit	   A0,0
  qubit	   A1,0
  qubit	   q0
  qubit	   q1
  qubit	   q2
  qubit	   A2,0
  qubit	   A3,0
  qubit	   q3
  qubit	   q4
  qubit	   q5
#  qubit	   A4,0
#  qubit	   A5,0
#  qubit	   q6
#  qubit	   q7
#  qubit	   q8
#  qubit	   A6,0
#  qubit	   A7,0
#  qubit	   q9
#  qubit	   q10
#  qubit	   q11
#  qubit	   A8,0
#  qubit	   A9,0
#  qubit	   q12
#  qubit	   q13
#  qubit	   q14
#  qubit	   A10,0
#  qubit	   A11,0
#  qubit	   q15
#  qubit	   q16
#  qubit	   q17
#  qubit	   A12,0
#  qubit	   A13,0
  qubit	   q18
  qubit	   q19
  qubit	   q20
  qubit	   A14,0
  qubit	   A15,0
  qubit	   q21
  qubit	   q22
  qubit	   q23
  qubit	   A16,0
  qubit	   A17,0


  cnot	   q0,A1
  cnot	   q2,A0
  cnot	   q2,A1
  cnot	   q0,A0
  h	   A0
  h	   A1
  cnot	   A0,q2
  cnot	   A1,q1
  cnot	   A0,q1
  cnot	   A1,q2
  h	   A0
  h	   A1

  measure  A0
  measure  A1
  zero	   A0
  zero	   A1

  cnot	   q0,A0
  cnot	   q2,A0
  h	   A0
  h	   A1
  cnot	   A0,q0
  cnot	   A1,q2
  cnot	   A0,q1
  cnot	   A1,q0
  h	   A0
  h	   A1
  measure  A0
  measure  A1
  


