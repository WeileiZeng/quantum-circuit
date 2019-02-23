# Weilei Zeng, see weilei_readme.txt
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
#  qubit	   A4,0
#  qubit	   A5,0
#  qubit	   q6
#  qubit	   q7
#  qubit	   q8
#  qubit	   A6,0
#  qubit	   A7,0
#  qubit	   q9
#  qubit	   q10
#  qubit	   q11
#  qubit	   A8,0
#  qubit	   A9,0
#  qubit	   q12
#  qubit	   q13
#  qubit	   q14
#  qubit	   A10,0
#  qubit	   A11,0
#  qubit	   q15
#  qubit	   q16
#  qubit	   q17
#  qubit	   A12,0
#  qubit	   A13,0
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

#1,2 generators
  cnot	   q0,A1
  cnot	   q2,A0
  cnot	   q2,A1
  cnot	   q0,A0
  h	   A0
  h	   A1
  cnot	   A0,q2
  cnot	   A1,q1
  cnot	   A0,q1
  cnot	   A1,q2
  h	   A0
  h	   A1

  measure  A0
  measure  A1
  zero	   A0
  zero	   A1

#3,4 generators
  cnot	   q0,A0
  cnot	   q2,A0
  h	   A0
  h	   A1
  cnot	   A1,q0
  cnot	   A0,q0
  cnot	   A1,q2
  cnot	   A0,q1

  h	   A0
  h	   A1
  measure  A0
  measure  A1
  
  zero     A0
  zero	   A1
  
#fifth and sixth generators in the extra first eight genrators
  cnot	   q5,A0
  cnot	   q1,A1
  cnot	   q1,A0
  cnot	   q3,A1
  cnot	   q2,A1
  cnot	   q0,A1
  cnot	   q3,A0
  cnot	   q5,A1
  h	   A0
  h	   A1
  cnot	   A0,q1
  cnot	   A0,q2
  cnot	   A1,q0
  cnot	   A0,q4
  cnot	   A1,q5
  cnot	   A0,q5
  cnot	   A1,q4
  cnot	   A1,q2
  h	   A0
  h	   A1

  measure  A0
  measure  A1
  zero	   A0
  zero	   A1

#seventh and eight genertors in the extra first eight generators
  cnot	   q0,A0
  cnot	   q1,A1
  cnot	   q2,A0
  cnot	   q4,A1
  cnot	   q5,A0
  cnot	   q4,A0
  cnot	   q3,A1  
  
  h	   A0
  h	   A1
  cnot	   A0,q2
  cnot	   A1,q3
  cnot	   A0,q3
  cnot	   A1,q2
  cnot	   A0,q4
  cnot	   A1,q5
  h	   A0
  h	   A1
  measure  A0
  measure  A1

#now add the last eight operators
#first and second generator for the last right generators
  cnot     q18,A16
  cnot	   q19,A17
  cnot	   q19,A16
  cnot	   q20,A17
  cnot	   q20,A16
  cnot	   q18,A17
  cnot	   q22,A16
  cnot	   q23,A17
  h	   A16
  h	   A17
  cnot	   A16,q22
  cnot	   A17,q23
  cnot	   A16,q23
  cnot	   A17,q21
  cnot	   A17,q20
  cnot	   A17,q19
  cnot	   A17,q18
  h	   A16
  h	   A17
  
  measure  A16
  measure  A17


  nop	   A16
  nop	   A16
  nop	   A16
  zero	   A16
  zero	   A17
  
# third and fourth generators for the last eight generators
  cnot	   q23,A17
  cnot	   q22,A16
  cnot	   q21,A16
  h	   A16
  h	   A17
  cnot	   A17,q18
  cnot	   A16,q19
  cnot	   A17,q19
  cnot	   A16,q20
  cnot	   A17,q20
  cnot	   A16,q18
  h	   A16
  h	   A17
  measure  A16
  measure  A17
  nop	   A16
  zero	   A16
  zero	   A17
  
#fifth and sixth generators
  cnot     q21,A16
  cnot	   q22,A17
  cnot	   q22,A16
  cnot	   q23,A16
  h	   A17
  cnot	   A17,q21
  cnot	   A17,q22
  h	   A17
  measure  A16
  measure  A17
  zero	   A16
  zero	   A17

#seventh and eighth generator for last eight generators
  cnot	   q21,A16
  cnot	   q23,A17
  cnot	   q21,A17
  cnot	   q23,A16
  h	   A16
  h	   A17
  cnot	   A16,q21
  cnot	   A17,q22
  cnot	   A16,q22
  cnot	   A17,q21
  h	   A16
  h	   A17
  measure  A16
  measure  A17


