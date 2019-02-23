# Weilei Zeng
# A circuit to measure XXX XXX in shor's code
# There are three versions of this circuit 1>standard one 2>simplified one 3>more simplified
# Here shows 3>more simplified one. This one is optimized such that the time interval is minimal. It is proved by hand that this circuit is equivalent to 2> and 1>
# Not that the measurement bit is A0, not A1

  qubit	   q0
  qubit	   q1
  qubit	   q2
  qubit	   A0,0
  qubit	   A1,0
  qubit	   q3
  qubit	   q4
  qubit	   q5


  H	   A0
  H	   A1
  cnot	   A0,q0
  cnot	   A0,q1
  cnot	   A0,q2
  cnot	   A1,q3
  cnot	   A1,q4
  cnot	   A1,q5
  cnot	   A0,A1
  H	   A0
  H	   A1
  
  measure  A0