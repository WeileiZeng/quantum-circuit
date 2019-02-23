# Weilei Zeng, see weilei_readme.txt
# A circuit to measure G_1

  qubit	   q0
  qubit	   q1
  qubit	   q2
  qubit	   A2,0
  qubit	   A3,0
  qubit	   q3
  qubit	   q4
  qubit	   q5
  qubit	   A4,0
  qubit	   A5,0
  qubit	   q6
  qubit	   q7
  qubit	   q8
  qubit	   A6,0
  qubit	   A7,0
  qubit	   q9
  qubit	   q10
  qubit	   q11


#g1
  nop	   q1
  cnot	   q1,A2
  h        A3
  cnot     A3,q0
  cnot     A3,q1
  cnot	   q2,A2
  cnot	   q0,A2
  cnot     A3,q2

#g1
  nop	   q4
  cnot	   q4,A4
  h        A5
  cnot     A5,q3
  cnot     A5,q4
  cnot	   q5,A4
  cnot	   q3,A4
  cnot     A5,q5

#g1
  nop      q7
  cnot     q7,A6
  h        A7
  cnot     A7,q6
  cnot     A7,q7
  cnot     q8,A6
  cnot     q6,A6
  cnot     A7,q8

#g2

  cnot	   q3,A2
  cnot     A3,q4
  cnot     A3,q3
  h        A3
  h	   q4
  h	   q5
  cnot	   q5,A2
  h	   q5
  cnot	   q4,A2
  h	   q4
  cnot	   q5,A3
  cnot	   q4,A3
  cnot	   q5,A2

#g2
  cnot	   q6,A4
  cnot	   A5,q7
  cnot	   A5,q6
  h	   A5
  h	   q7
  h	   q8
  cnot	   q8,A4
  h	   q8
  cnot	   q7,A4
  h	   q7
  cnot	   q8,A5
  cnot	   q7,A5
  cnot	   q8,A4

#g2
  cnot     q9,A6
  cnot     A7,q10
  cnot     A7,q9
  h        A7
  h        q10
  nop      q11
  nop      q11
  nop      q11
  nop      q11
  h        q11
  cnot     q11,A6
  h        q11
  cnot     q10,A6
  h        q10
  cnot     q11,A7
  cnot     q10,A7
  cnot     q11,A6

  measure  A2
  measure  A3
  measure  A4
  measure  A5
  measure  A6
  measure  A7
