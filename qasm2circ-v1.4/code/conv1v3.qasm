# Weilei Zeng
# A circuit to measure 

  qubit	   q1
  qubit	   q2
  qubit	   A1,0
  qubit	   q4
  qubit	   q5
  qubit	   A0,0
  qubit	   q0
  qubit	   q3

  cnot	   q0,A0
  cnot	   q1,A1

  h	   q4
  cnot	   q4,A1
  h	   q4

  h	   q5
  cnot	   q5,A0
  h	   q5

  cnot	   q3,A0
  cnot	   q5,A0
  cnot	   q2,A1

  cnot	   A1,A0
  measure  A0