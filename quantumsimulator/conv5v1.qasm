# Weilei Zeng, see weilei_readme.txt
# A circuit to measure G_1
# somehow this circuit have to start with q0 in the beginning, which could be emitted when we crop the image of the circuit.

  qubit	   q0
  qubit	   B0,0
  qubit	   B1,0
  qubit	   B2,0
  qubit	   B3,0
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
  qubit	   A8,0
  qubit	   A9,0

#some initial set up
  h	   A1
  h        A3
  
#g1
  nop	   q1
  cnot	   q1,A2
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

#g1
  nop      q10
  cnot     q10,A8
  h        A9
  cnot     A9,q9
  cnot     A9,q10
  cnot     q11,A8
  cnot     q9,A8
  cnot     A9,q11

#g2

  cnot	   q0,A0
  cnot     A1,q1
  cnot     A1,q0
  h        A1
  h	   q1
  h	   q2
  cnot	   q2,A0
  h	   q2
  cnot	   q1,A0
  h	   q1
  cnot	   q2,A1
  cnot	   q1,A1
  cnot	   q2,A0
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
  h        q11
  cnot     q11,A6
  h        q11
  cnot     q10,A6
  h        q10
  cnot     q11,A7
  cnot     q10,A7
  cnot     q11,A6

# some final set up
  h    	   A9

# measurement

  measure  A0
  measure  A1
  measure  A2
  measure  A3
  measure  A4
  measure  A5
  measure  A6
  measure  A7
  nop	   A8
  nop	   A8
  nop	   A8
  nop	   A8
  nop	   A8
  nop	   A9
  nop	   A9
  nop	   A9
  nop	   A9
  measure  A8
  measure  A9


#the following is for AG part

  zero 	   A0
  zero 	   A1
  zero 	   A2
  zero 	   A3
  zero 	   A4
  zero 	   A5
  zero 	   A6

  cnot	   q1,A3
  cnot	   q2,A3
  cnot	   q7,A3
  cnot	   q5,A3
  cnot	   q8,A3
  
  cnot	   q0,A2
  cnot	   q1,A2
  cnot	   q2,A2
  cnot	   q4,A2
  cnot	   q6,A2
  cnot	   q8,A2

  cnot	   q0,A3
  
  h	   A2
  h	   A3

  cnot 	   A2,q4
  cnot 	   A2,q5
  cnot 	   A2,q7
  cnot 	   A2,q8

  cnot	   A3,q0
  cnot	   A3,q1
  cnot	   A3,q2
  cnot	   A3,q3
  cnot	   A3,q5

  h	   A2
  h	   A3

  measure  A3
  measure  A2
  