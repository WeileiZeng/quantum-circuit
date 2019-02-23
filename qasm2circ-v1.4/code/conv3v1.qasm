# Weilei Zeng
# A circuit to measure G_1

  qubit	   q0
  qubit	   q1
  qubit	   q2
  qubit	   A0,0
  qubit	   A1,0
  qubit	   q3
  qubit	   q4
  qubit	   q5
  qubit	   A2,0
  qubit	   A3,0
  qubit	   q6
  qubit	   q7
  qubit	   q8

  cnot	   q0,A0
  cnot	   q1,A0
  cnot	   q2,A0

  cnot	   q3,A2
  cnot	   q4,A2
  cnot	   q5,A2

  cnot	   q3,A0
  nop	   q4
  h	   q4
  h	   q5
  cnot	   q5,A0
  h	   q5
  cnot	   q4,A0
  h	   q4
  cnot	   q5,A0




  cnot	   q6,A2

  nop	   q7
  nop	   q7
  nop	   q7
  nop	   q7
  h	   q7
  nop	   q8
  nop	   q8
  nop	   q8
  h	   q8
  cnot	   q8,A2
  h	   q8
  cnot	   q7,A2
  h	   q7
  cnot	   q8,A2

  measure  A0
  measure  A2