# Weilei Zeng
# A circuit to measure 

  qubit	   q0
  qubit	   q1
  qubit	   q2
  qubit	   q3
  qubit	   q4
  qubit	   q5
  qubit	   A0,0

  cnot	   q0,A0
  cnot	   q1,A0
  cnot	   q2,A0
  cnot	   q3,A0
  nop	   q4
  nop	   q4
  nop	   q4
  nop	   q4
  h	   q4
  cnot	   q4,A0
  h	   q4
  cnot	   q5,A0
  h	   q5
  cnot	   q5,A0
  h	   q5

  measure  A0