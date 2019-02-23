#Weilei Zeng
#measure Y_0

	 qubit	q0
	 qubit	A0,0
	 
	 cnot	q0,A0
	 h	q0
	 cnot	q0,A0
	 h	q0

	 measure	A0