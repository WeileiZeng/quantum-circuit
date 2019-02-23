# Weilei Zeng
# A simple circuit to measure Z_0Z_1

  qubit	   q0
  qubit	   q1
  qubit	   A0,0

  cnot	   q0,A0
  cnot	   q1,A0
  measure  A0