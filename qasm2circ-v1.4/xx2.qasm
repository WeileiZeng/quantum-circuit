# Weilei Zeng
# A circuit to measure XXX XXX in shor's code
# There are three versions of this circuit 1>standard one 2>simplified one 3>more simplified
# Here shows 1>the standard one

  qubit	   q0
  qubit	   q1
  qubit	   q2
  qubit	   q3
  qubit	   q4
  qubit	   q5
  qubit	   A0,0

  H	   A0
  cnot	   A0,q0
  cnot	   A0,q1
  cnot	   A0,q2
  cnot	   A0,q3
  cnot	   A0,q4
  cnot	   A0,q5
  H	   A0
  measure  A0