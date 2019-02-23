# Weilei Zeng
# A circuit to measure 

  qubit	   q0
  qubit	   q1
  qubit	   q2
  qubit	   q3
  qubit	   q4
  qubit	   q5
  qubit	   A0,0

  h	   A0
  cnot	   A0,q0
  cnot	   A0,q1
  cnot	   A0,q2
  cnot	   A0,q3
  cnot	   A0,q4
  h	   A0

  cnot	   q4,A0
  cnot	   q5,A0

  measure  A0