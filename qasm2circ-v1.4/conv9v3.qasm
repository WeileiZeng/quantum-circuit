# Weilei Zeng, see weilei_readme.txt
# somehow this circuit have to start with q0 in the beginning, which could be emitted when we crop the image of the circuit.
#initialize
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





#measure 3rd and 4th generators  G1010-1110
  zero     A0
  zero     A1
  zero     A2
  zero     A3
  zero     A4
  zero     A5
  zero     A6
  zero     A7
  zero     A8
  zero     A9
  zero     A10
  zero     A11
  zero     A12
  zero     A13
  zero     A14
  zero     A15
  zero     A16
  zero     A17


#1,2 generators left part, first and second for first eight
  cnot     q0,A1
  cnot     q2,A0
  cnot     q2,A1
  cnot     q0,A0




#left block
      cnot	q8,A3
      cnot	q6,A2
      cnot	q8,A2
      cnot	q6,A3
      cnot	q5,A3
      cnot	q4,A2
      cnot	q0,A2
      cnot	q2,A2
      cnot	q1,A3
      cnot	q1,A2
      cnot	q0,A3
      cnot	q2,A3
#left block
      cnot      q11,A5
      cnot      q9,A4
      cnot      q11,A4
      cnot      q9,A5
      cnot      q8,A5
      cnot      q7,A4
      cnot      q3,A4
      cnot      q5,A4
      cnot      q4,A5
      cnot      q4,A4
      cnot      q3,A5
      cnot      q5,A5
#left block
      cnot      q14,A7
      cnot      q12,A6
      cnot      q14,A6
      cnot      q12,A7
      cnot      q11,A7
      cnot      q10,A6
      cnot      q6,A6
      cnot      q8,A6
      cnot      q7,A7
      cnot      q7,A6
      cnot      q6,A7
      cnot      q8,A7
#left block
      cnot      q17,A9
      cnot      q15,A8
      cnot      q17,A8
      cnot      q15,A9
      cnot      q14,A9
      cnot      q13,A8
      cnot      q9,A8
      cnot      q11,A8
      cnot      q10,A9
      cnot      q10,A8
      cnot      q9,A9
      cnot      q11,A9
#left block
      cnot      q20,A11
      cnot      q18,A10
      cnot      q20,A10
      cnot      q18,A11
      cnot      q17,A11
      cnot      q16,A10
      cnot      q12,A10
      cnot      q14,A10
      cnot      q13,A11
      cnot      q13,A10
      cnot      q12,A11
      cnot      q14,A11
#left block
      cnot      q23,A13
      cnot      q21,A12
      cnot      q23,A12
      cnot      q21,A13
      cnot      q20,A13
      cnot      q19,A12
      cnot      q15,A12
      cnot      q17,A12
      cnot      q16,A13
      cnot      q16,A12
      cnot      q15,A13
      cnot      q17,A13
      

#1,2 generators right block, first and second for first eight
  h        A0
  h        A1
  cnot     A0,q2
  cnot     A1,q1
  cnot     A0,q1
  cnot     A1,q2
  h        A0
  h        A1
  measure  A0
  measure  A1

#fifth and sixth generators for last eight
  cnot     q21,A16
  cnot     q22,A17
  cnot     q22,A16
  cnot     q23,A16
  h        A17
  cnot     A17,q21
  cnot     A17,q22
  h        A17
  measure  A16
  measure  A17



#right block
       h	A2
       h	A3
       cnot	A3,q8
       cnot	A2,q7
       cnot	A3,q7
       cnot	A2,q8
       cnot	A3,q5
       cnot	A2,q4
       cnot	A2,q5
       cnot	A3,q3
       cnot	A3,q2
       cnot	A3,q1
       cnot	A3,q0
       nop	A2
       nop	A2
       nop	A2
       h	A2
       h	A3

#right block
       h        A4
       h        A5
       cnot     A5,q11
       cnot     A4,q10
       cnot     A5,q10
       cnot     A4,q11
       cnot     A5,q8
       cnot     A4,q7
       cnot     A4,q8
       cnot     A5,q6
       cnot     A5,q5
       cnot     A5,q4
       cnot     A5,q3
       nop      A4
       nop      A4
       nop      A4
       h        A4
       h        A5
#right block
       h        A6
       h        A7
       cnot     A7,q14
       cnot     A6,q13
       cnot     A7,q13
       cnot     A6,q14
       cnot     A7,q11
       cnot     A6,q10
       cnot     A6,q11
       cnot     A7,q9
       cnot     A7,q8
       cnot     A7,q7
       cnot     A7,q6
       nop      A6
       nop      A6
       nop      A6
       h        A6
       h        A7
#right block
       h        A8
       h        A9
       cnot     A9,q17
       cnot     A8,q16
       cnot     A9,q16
       cnot     A8,q17
       cnot     A9,q14
       cnot     A8,q13
       cnot     A8,q14
       cnot     A9,q12
       cnot     A9,q11
       cnot     A9,q10
       cnot     A9,q9
       nop      A8
       nop      A8
       nop      A8
       h        A8
       h        A9
#right block
       h        A10
       h        A11
       cnot     A11,q20
       cnot     A10,q19
       cnot     A11,q19
       cnot     A10,q20
       cnot     A11,q17
       cnot     A10,q16
       cnot     A10,q17
       cnot     A11,q15
       cnot     A11,q14
       cnot     A11,q13
       cnot     A11,q12
       nop      A10
       nop      A10
       nop      A10
       h        A10
       h        A11
#right block
       h        A12
       h        A13
       cnot     A13,q23
       cnot     A12,q22
       cnot     A13,q22
       cnot     A12,q23
       cnot     A13,q20
       cnot     A12,q19
       cnot     A12,q20
       cnot     A13,q18
       cnot     A13,q17
       cnot     A13,q16
       cnot     A13,q15
       nop      A12
       nop      A12
       nop      A12
       h        A12
       h        A13

# measurement for the second round in AG
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


  zero	   A0
  zero	   A1
  zero	   A2
  zero	   A3
  zero	   A4
  zero	   A5
  zero	   A6
  zero	   A7
  zero	   A8
  zero	   A9
  zero	   A10
  zero	   A11
  zero	   A12
  zero	   A13
#  zero	   A14
#  zero	   A15
  zero	   A16
  zero	   A17


#third forth,3,4 generators for first eight
  cnot     q0,A0
  cnot     q2,A0
  h        A0
  h        A1
  cnot     A1,q0
  cnot     A0,q0
  cnot     A1,q2
  cnot     A0,q1

  h        A0
  h        A1
  measure  A0
  measure  A1

  zero     A0
  zero     A1

#seventh and eighth generator for last eight generators
  cnot     q21,A16
  cnot     q23,A17
  cnot     q21,A17
  cnot     q23,A16
  h        A16
  h        A17
  cnot     A16,q21
  cnot     A17,q22
  cnot     A16,q22
  cnot     A17,q21
  h        A16
  h        A17
  measure  A16
  measure  A17
  zero	   A16
  zero	   A17


#left part
  cnot	q8,A2
  cnot	q7,A3
  cnot	q7,A2
  cnot 	q6,A3
  cnot	q5,A2
  cnot	q4,A2
  cnot	q3,A3

#left part
  cnot  q11,A4
  cnot  q10,A5
  cnot  q10,A4
  cnot  q9,A5
  cnot  q8,A4
  cnot  q7,A4
  cnot  q6,A5
#left part
  cnot  q14,A6
  cnot  q13,A7
  cnot  q13,A6
  cnot  q12,A7
  cnot  q11,A6
  cnot  q10,A6
  cnot  q9,A7
#left part
  cnot  q17,A8
  cnot  q16,A9
  cnot  q16,A8
  cnot  q15,A9
  cnot  q14,A8
  cnot  q13,A8
  cnot  q12,A9
#left part
  cnot  q20,A10
  cnot  q19,A11
  cnot  q19,A10
  cnot  q18,A11
  cnot  q17,A10
  cnot  q16,A10
  cnot  q15,A11
#left part
  cnot  q23,A12
  cnot  q22,A13
  cnot  q22,A12
  cnot  q21,A13
  cnot  q20,A12
  cnot  q19,A12
  cnot  q18,A13


# third and fourth generators for the last eight generators, left block
  cnot     q23,A17
  cnot     q22,A16
  cnot     q21,A16



#right part
  h	A2
  nop	A3
  h	A3
  cnot	A3,q8
  cnot	A2,q6
  cnot	A3,q5
  cnot	A3,q6
  cnot	A2,q7
  cnot	A2,q5
  cnot	A2,q2
  cnot	A3,q0
  cnot	A3,q2
  cnot	A2,q1
  cnot	A3,q1
  cnot	A2,q0
  h	A2
  h	A3
#right part
  h     A4
  nop   A5
  h     A5
  cnot  A5,q11
  cnot  A4,q9
  cnot  A5,q8
  cnot  A5,q9
  cnot  A4,q10
  cnot  A4,q8
  cnot  A4,q5
  cnot  A5,q3
  cnot  A5,q5
  cnot  A4,q4
  cnot  A5,q4
  cnot  A4,q3
  h     A4
  h     A5

#right part
  h     A6
  nop   A7
  h     A7
  cnot  A7,q14
  cnot  A6,q12
  cnot  A7,q11
  cnot  A7,q12
  cnot  A6,q13
  cnot  A6,q11
  cnot  A6,q8
  cnot  A7,q6
  cnot  A7,q8
  cnot  A6,q7
  cnot  A7,q7
  cnot  A6,q6
  h     A6
  h     A7
#right part
  h     A8
  nop   A9
  h     A9
  cnot  A9,q17
  cnot  A8,q15
  cnot  A9,q14
  cnot  A9,q15
  cnot  A8,q16
  cnot  A8,q14
  cnot  A8,q11
  cnot  A9,q9
  cnot  A9,q11
  cnot  A8,q10
  cnot  A9,q10
  cnot  A8,q9
  h     A8
  h     A9

#right part
  h     A10
  nop   A11
  h     A11
  cnot  A11,q20
  cnot  A10,q18
  cnot  A11,q17
  cnot  A11,q18
  cnot  A10,q19
  cnot  A10,q17
  cnot  A10,q14
  cnot  A11,q12
  cnot  A11,q14
  cnot  A10,q13
  cnot  A11,q13
  cnot  A10,q12
  h     A10
  h     A11
#right part
  h     A12
  nop   A13
  h     A13
  cnot  A13,q23
  cnot  A12,q21
  cnot  A13,q20
  cnot  A13,q21
  cnot  A12,q22
  cnot  A12,q20
  cnot  A12,q17
  cnot  A13,q15
  cnot  A13,q17
  cnot  A12,q16
  cnot  A13,q16
  cnot  A12,q15
  h     A12
  h     A13

# third and fourth generators for the last eight generators, right block
  h        A16
  h        A17
  cnot     A17,q18
  cnot     A16,q19
  cnot     A17,q19
  cnot     A16,q20
  cnot     A17,q20
  cnot     A16,q18
  h        A16
  h        A17
  measure  A16
  measure  A17
  nop      A16
  zero     A16
  zero     A17



# measurement for the third round in AG
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

#fifth and sixth generators in the extra first eight genrators
  cnot     q1,A1
  cnot     q1,A0
  cnot     q3,A1
  cnot     q2,A1
  cnot     q0,A1
  cnot     q3,A0
  cnot     q5,A1
  h        A0
  h        A1
  cnot     A0,q1
  cnot     A0,q2
  cnot     A1,q0
  cnot     A0,q4
  cnot     A1,q5
  cnot     A0,q5
  cnot     A1,q4
  cnot     A1,q2
  h        A0
  h        A1

  measure  A0
  measure  A1
  zero     A0
  zero     A1

#seventh and eight genertors in the extra first eight generators
  cnot     q0,A0
  cnot     q1,A1
  cnot     q2,A0
  cnot     q4,A1
  cnot     q5,A0
  cnot     q4,A0
  cnot     q3,A1

  h        A0
  h        A1
  cnot     A0,q2
  cnot     A1,q3
  cnot     A0,q3
  cnot     A1,q2
  cnot     A0,q4
  cnot     A0,q5
  h        A0
  nop      A1
  nop      A1
  h        A1
  measure  A0
  measure  A1


#first and second generator for the last right generators
  cnot     q18,A16
  cnot     q19,A17
  cnot     q19,A16
  cnot     q20,A17
  cnot     q20,A16
  cnot     q18,A17
  cnot     q22,A16
  cnot     q23,A17
  h        A16
  h        A17
  cnot     A16,q22
  cnot     A17,q23
  cnot     A16,q23
  cnot     A17,q21
  cnot     A17,q20
  cnot     A17,q19
  cnot     A17,q18
  h        A16
  h        A17

  measure  A16
  measure  A17
