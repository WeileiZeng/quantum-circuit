Weilei Zeng Nov 1, 2018
This project help to build quantum circuit. The output include a tex file and a pdf file. Png currently not available due to absence of netpbm package.

This note explain what weilei has been built with qasm.

summary
What used in the program is conv4v2 and conv5v5v2. Feb 8.
Then we found the first and last generators are not valid, so change to conv6 and conv7


List of files:
filename	description
zz		measure Z_0Z_1
xx		measure X_0X_1...X_5
xx2		<=> xx
xx3		<=> xx
conv1		measure GF4 convolutional code (1 1 1 | 1 \omega \overline\omega)
conv1v2		<=> conv1
conv1v3		<=> conv1
conv2v1		measure GF4 convolutional code (\omega \omega \omega | \omega \overline\omega 1)
conv2v2
conv3v1		measure GF4 convolutional code G_1 (g and shifted g)
conv3v2		<=> conv3v1. 9 qubits, 4 generators (g and \omega g) and shifted (g and \omega g)
conv3v3		<=> conv3v1. 12 qubits, 6 generators (g and \omega g) and two shifted (g and \omega g)
conv4v1		puncture at parity check matrix instead of codeword generating matrix
conv4v2         <=> conv4v1, repeat=7 in this case, 3*7+3=24 qubits
conv5v1         12 qubits. The data sydnrome code, parity-check operators include both G and AG. This is slightly different from the P code.
conv5v2         conv5v1 is an unfinished version of conv5v2
conv5v3         conv5v2 is an unfinished version of conv5v3. However, I have difficulties designing conv5v3. In the P code, other than the repeating part, I need to do four measurement for the first 6 qubits, which takes much time to design. And I cannot fit these four measurement without extending the time steps. I really don't want to extend the time steps or do more optimization for the circuit at this moment. Hence, I would remove those measurement and just calulate the expected value from syndrome result of G. This effect to the code would be zero when the code is long enough, cause what we really case is the repeating part. On the other hand, I can puncture A in the way as it is in conv5v2, where we don't have the extra measurement at all. In this case I need to modify the matlab code to match the structure, which is another hell to go. In conclusiong, lets cheat by skipping this part.
conv5v4         <=> conv5v2, repeat = 7 in this case.
conv5v5v2	used in the program, with wrong first and last generators
conv5v5v3	no change

conv6		fixed first and last generators for GI code, defined in qconv002.pdf, 24 qubit code.
conv6v1		identical to conv4v2, just for reference
conv6v2		fixed second and last generator, defined in qconv002.pdf

conv7		fixed first and last generator for GA code.
conv7v1		identical to conv5v5v2, just for reference
conv7v2		fixed.
----------------a wrong gate in the circuit, redesign and change to conv8

conv8		  fixed wrong gate in GA code.
conv8v1		  fix the second two generators
conv8v3		  just for 5th and 6th generators, G0101-0111
conv8v4		  contain generator for just one block, just for 3rd and 4th generators, G1010-1110
conv8v5		  copy to six blocks
conv8v6		  everything for use, add 3,4,5,6th generators for 24 qubit code

conv8v7		  fix a wrong gate
------------------now add fisrt 8 generators
conv9v1
conv9v2		is the finale version
conv9v3		is a check version without first round of measurement in G

***Definitions***
G_1 is a 9-qubit code with 4 generators. (g;\omega g) has their one-block shift. g=(1 1 1 | 1 \omega \overline\omega)


***structure of conv9v1***
three round in total
first round in G
second and third round in AG

*first round in G
 ** left block, g1
  ** extra last two generators
 ** right block, g2
  ** extra first 2 genertors
*second round in AG
  ** first and second generators in the extra first eight left half
 ** left block
   ** first and second generators in the extra first eight right half
   -- fifth and sixth generators in the extra last eight total(left and right together)
 ** right block
*third round in AG
   ** thrid and fourth generators in the extra first eight total(left and right together)
    -- seventh and eighth generators in the extra last eight total(left and right together)
    -- third and fourth generators in the extra last eight (left half)
 **left block
     -- third and fourth generators in the extra last eight (right half)
 **right block

** fifth and sixth generators in the extra first eight total(left and right together)
** seventh and eighth generators in the extra first eight total(left and right together)

    -- first and second generators in the extra last eight total(left and right together)
