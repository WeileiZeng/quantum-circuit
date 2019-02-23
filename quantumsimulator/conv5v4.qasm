# Weilei Zeng, see weilei_readme.txt
# A circuit to measure G_1
# somehow this circuit have to start with q0 in the beginning, which could be emitted when we crop the image of the circuit.

  qubit	   q0
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

  qubit	   q12
  qubit	   q13
  qubit	   q14
  qubit	   A10,0
  qubit	   A11,0
  qubit	   q15
  qubit	   q16
  qubit	   q17
  qubit	   A12,0
  qubit	   A13,0
  qubit	   q18
  qubit	   q19
  qubit	   q20
  qubit	   A14,0
  qubit	   A15,0
  qubit	   q21
  qubit	   q22
  qubit	   q23
  qubit	   A16,0
  qubit	   A17,0




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

#g1
  nop      q13
  cnot     q13,A10
  h        A11
  cnot     A11,q12
  cnot     A11,q13
  cnot     q14,A10
  cnot     q12,A10
  cnot     A11,q14

#g1
  nop      q16
  cnot     q16,A12
  h        A13
  cnot     A13,q15
  cnot     A13,q16
  cnot     q17,A12
  cnot     q15,A12
  cnot     A13,q17

#g1
  nop      q19
  cnot     q19,A14
  h        A15
  cnot     A15,q18
  cnot     A15,q19
  cnot     q20,A14
  cnot     q18,A14
  cnot     A15,q20

#g1
  nop      q22
  cnot     q22,A16
  h        A17
  cnot     A17,q21
  cnot     A17,q22
  cnot     q23,A16
  cnot     q21,A16
  cnot     A17,q23



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

#g2
  cnot     q12,A8
  cnot     A9,q13
  cnot     A9,q12
  h        A9
  h        q13
  h        q14
  cnot     q14,A8
  h        q14
  cnot     q13,A8
  h        q13
  cnot     q14,A9
  cnot     q13,A9
  cnot     q14,A8

#g2
  cnot     q15,A10
  cnot     A11,q16
  cnot     A11,q15
  h        A11
  h        q16
  h        q17
  cnot     q17,A10
  h        q17
  cnot     q16,A10
  h        q16
  cnot     q17,A11
  cnot     q16,A11
  cnot     q17,A10

#g2
  cnot     q18,A12
  cnot     A13,q19
  cnot     A13,q18
  h        A13
  h        q19
  h        q20
  cnot     q20,A12
  h        q20
  cnot     q19,A12
  h        q19
  cnot     q20,A13
  cnot     q19,A13
  cnot     q20,A12


#g2
  cnot     q21,A14
  cnot     A15,q22
  cnot     A15,q21
  h        A15
  h        q22
  h        q23
  cnot     q23,A14
  h        q23
  cnot     q22,A14
  h        q22
  cnot     q23,A15
  cnot     q22,A15
  cnot     q23,A14




# some final set up
  h    	   A17

# measurement

  measure  A0
  measure  A1
  measure  A2
  measure  A3
  measure  A4
  measure  A5
  measure  A6
  measure  A7
  measure  A8
  measure  A9
  measure  A10
  measure  A11
  measure  A12
  measure  A13
  measure  A14
  measure  A15
  measure  A16 
  measure  A17 


#the following is for AG part

  zero 	   A0
  zero 	   A1
  zero 	   A2
  zero 	   A3
  zero 	   A4
  zero 	   A5
  zero 	   A6
  zero 	   A7
  zero 	   A8
  zero 	   A9
  zero 	   A10
  zero 	   A11
  zero 	   A12
  zero 	   A13
  zero 	   A14
  zero 	   A15
  zero 	   A16
  zero 	   A17

#left block
  cnot	   q8,A3
  cnot	   q6,A2
  cnot	   q8,A2
  cnot	   q4,A2
  cnot	   q7,A3
  cnot	   q5,A3
  cnot	   q1,A3
  cnot	   q2,A3
  cnot	   q0,A2
  cnot	   q1,A2
  cnot	   q2,A2
  cnot	   q0,A3

#left block
  cnot     q11,A5
  cnot     q9,A4
  cnot     q11,A4
  cnot     q7,A4
  cnot     q10,A5
  cnot     q8,A5
  cnot     q4,A5
  cnot     q5,A5
  cnot     q3,A4
  cnot     q4,A4
  cnot     q5,A4
  cnot     q3,A5

#left block
  cnot     q14,A7
  cnot     q12,A6
  cnot     q14,A6
  cnot     q10,A6
  cnot     q13,A7
  cnot     q11,A7
  cnot     q7,A7
  cnot     q8,A7
  cnot     q6,A6
  cnot     q7,A6
  cnot     q8,A6
  cnot     q6,A7

#left block
  cnot     q17,A9
  cnot     q15,A8
  cnot     q17,A8
  cnot     q13,A8
  cnot     q16,A9
  cnot     q14,A9
  cnot     q10,A9
  cnot     q11,A9
  cnot     q9,A8
  cnot     q10,A8
  cnot     q11,A8
  cnot     q9,A9

#left block
  cnot     q20,A11
  cnot     q18,A10
  cnot     q20,A10
  cnot     q16,A10
  cnot     q19,A11
  cnot     q17,A11
  cnot     q13,A11
  cnot     q14,A11
  cnot     q12,A10
  cnot     q13,A10
  cnot     q14,A10
  cnot     q12,A11

#left block
  cnot     q23,A13
  cnot     q21,A12
  cnot     q23,A12
  cnot     q19,A12
  cnot     q22,A13
  cnot     q20,A13
  cnot     q16,A13
  cnot     q17,A13
  cnot     q15,A12
  cnot     q16,A12
  cnot     q17,A12
  cnot     q15,A13
  
#right block
  h	   A2
  h	   A3
  cnot 	   A2,q8
  cnot 	   A2,q7
  cnot 	   A2,q4
  cnot	   A3,q3
  cnot	   A3,q5
  cnot 	   A2,q5

  cnot	   A3,q0
  cnot	   A3,q1
  cnot	   A3,q2
  nop 	   A2
  h	   A2
  h	   A3

#right block
  h        A4
  h        A5
  cnot     A4,q11
  cnot     A4,q10
  cnot     A4,q7
  cnot     A5,q6
  cnot     A5,q8
  cnot     A4,q8

  cnot     A5,q3
  cnot     A5,q4
  cnot     A5,q5
  nop	   A4
  h        A4
  h        A5

#right block
  h        A6
  h        A7
  cnot     A6,q14
  cnot     A6,q13
  cnot     A6,q10
  cnot     A7,q9
  cnot     A7,q11
  cnot     A6,q11

  cnot     A7,q6
  cnot     A7,q7
  cnot     A7,q8
  nop      A6
  h        A6
  h        A7

#right block
  h        A8
  h        A9
  cnot     A8,q17
  cnot     A8,q16
  cnot     A8,q13
  cnot     A9,q12
  cnot     A9,q14
  cnot     A8,q14

  cnot     A9,q9
  cnot     A9,q10
  cnot     A9,q11
  nop      A8
  h        A8
  h        A9

#right block
  h        A10
  h        A11
  cnot     A10,q20
  cnot     A10,q19
  cnot     A10,q16
  cnot     A11,q15
  cnot     A11,q17
  cnot     A10,q17

  cnot     A11,q12
  cnot     A11,q13
  cnot     A11,q14
  nop      A10
  h        A10
  h        A11

#right block
  h        A12
  h        A13
  cnot     A12,q23
  cnot     A12,q22
  cnot     A12,q19
  cnot     A13,q18
  cnot     A13,q20
  cnot     A12,q20

  cnot     A13,q15
  cnot     A13,q16
  cnot     A13,q17
  nop      A12
  h        A12
  h        A13

#measurement
  measure  A2
  measure  A3
  measure  A4
  measure  A5
  measure  A6
  measure  A7
  measure  A8
  measure  A9
  measure  A10
  measure  A11
  measure  A12
  measure  A13 

  