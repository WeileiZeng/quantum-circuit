# Weilei Zeng, see weilei_readme.txt
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
#g1
  nop	   q1
  cnot	   q1,A0

  h        A1
  cnot     A1,q0
  cnot     A1,q1

  cnot	   q2,A0
  cnot	   q0,A0
  cnot     A1,q2

  nop	   q4
  cnot	   q4,A2

  h        A3
  cnot     A3,q3
  cnot     A3,q4

  cnot	   q5,A2
  cnot	   q3,A2
  cnot     A3,q5

#g2
  cnot	   q3,A0

  cnot     A1,q4
  cnot     A1,q3
  h        A1

  h	   q4
  h	   q5
  cnot	   q5,A0
  h	   q5
  cnot	   q4,A0
  h	   q4


  cnot	   q5,A1
  cnot	   q4,A1

  cnot	   q5,A0
  cnot	   q6,A2


  cnot	   A3,q7
  cnot	   A3,q6
  h	   A3

  h	   q7
  nop	   q8
  nop	   q8
  nop	   q8
  nop	   q8
  h	   q8
  cnot	   q8,A2
  h	   q8
  cnot	   q7,A2
  h	   q7

  cnot	   q8,A3
  cnot	   q7,A3
  cnot	   q8,A2

  measure  A0
  measure  A1
  measure  A2
  measure  A3