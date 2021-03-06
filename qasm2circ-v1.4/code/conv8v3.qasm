
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
  zero	   A14
  zero	   A15
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


#measurement
  measure	A2
  measure	A3
  