300
# Weilei Zeng  see weilei_readme.txt
# 20circuit tom G_1
# somehow thiscircuithave to start with 0 in the beginning  whichcould be emitted when wecrop the image of thecircuit.

#some initial set up
h 201
h 203

#g1
c 1 202
c 203 0
c 203 1
c 2 202
c 0 202
c 203 2

#g1
c 4 204
h 205
c 205 3
c 205 4
c 5 204
c 3 204
c 205 5

#g1
c 7 206
h 207
c 207 6
c 207 7
c 8 206
c 6 206
c 207 8

#g1
c 10 208
h 209
c 209 9
c 209 10
c 11 208
c 9 208
c 209 11

#g1
c 13 210
h 211
c 211 12
c 211 13
c 14 210
c 12 210
c 211 14

#g1
c 16 212
h 213
c 213 15
c 213 16
c 17 212
c 15 212
c 213 17

#g1
c 19 214
h 215
c 215 18
c 215 19
c 20 214
c 18 214
c 215 20

#g1
h 217
c 217 21
c 217 22
c 23 216
c 21 216
c 22 216

h 217
c 21 217
c 23 217

#g2

c 0 200
c 201 1
c 201 0
h 201
h 1
h 2
c 2 200
h 2
c 1 200
h 1
c 2 201
c 0 201
c 2 200
#g2

c 3 202
c 203 4
c 203 3
h 203
h 4
h 5
c 5 202
h 5
c 4 202
h 4
c 5 203
c 4 203
c 5 202

#g2
c 6 204
c 205 7
c 205 6
h 205
h 7
h 8
c 8 204
h 8
c 7 204
h 7
c 8 205
c 7 205
c 8 204

#g2
c 9 206
c 207 10
c 207 9
h 207
h 10
h 11
c 11 206
h 11
c 10 206
h 10
c 11 207
c 10 207
c 11 206

#g2
c 12 208
c 209 13
c 209 12
h 209
h 13
h 14
c 14 208
h 14
c 13 208
h 13
c 14 209
c 13 209
c 14 208

#g2
c 15 210
c 211 16
c 211 15
h 211
h 16
h 17
c 17 210
h 17
c 16 210
h 16
c 17 211
c 16 211
c 17 210

#g2
c 18 212
c 213 19
c 213 18
h 213
h 19
h 20
c 20 212
h 20
c 19 212
h 19
c 20 213
c 19 213
c 20 212

#g2
c 21 214
c 215 22
c 215 21
h 215
h 22
h 23
c 23 214
h 23
c 22 214
h 22
c 23 215
c 22 215
c 23 214

# some final set up
#h 217

#mment

m 0 200
m 1 201
m 2 202
m 3 203
m 4 204
m 5 205
m 6 206
m 7 207
m 8 208
m 9 209
m 10 210
m 11 211
m 12 212
m 13 213
m 14 214
m 15 215
m 16 216
m 17 217

 
#For the last part in this file, manually change the classical bit for saving measurement result. (following example in conv5v5v2.qc). The sequence is also writen in conv5.txt. conv7 use the same sequence.
