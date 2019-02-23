#sed '/hi/! { N ; s/why\nhuh/yo/ }' hello.txt
#the string happens in the text in the sequence of a,b,c,d,...
#here I replace it according to the sequence of generators in the generator matrix
cp backupconv9v2.qc  conv9v2.qc
newfile=conv9v2.qc

#sed -i '/stringf/! { N ; s/m 0 200\nm 1 201/m 22 200\nm 23 201/ }' $newfile
sed -i '/stringc/! { N ; s/m 0 200\nm 1 201/m 20 200\nm 21 201/ }' $newfile
#sed -i '/stringg/! { N ; s/m 0 200\nm 1 201/m 24 200\nm 25 201/ }' $newfile
#sed -i '/stringb/! { N ; s/m 0 200\nm 1 201/m 18 200\nm 19 201/ }' $newfile

#sed -i '/stringe/! { N ; s/m 16 216\nm 17 217/m 52 216\nm 53 217/ }' $newfile
#sed -i '/stringh/! { N ; s/m 16 216\nm 17 217/m 50 216\nm 51 217/ }' $newfile
#sed -i '/stringd/! { N ; s/m 16 216\nm 17 217/m 56 216\nm 57 217/ }' $newfile
#sed -i '/stringa/! { N ; s/m 16 216\nm 17 217/m 54 216\nm 55 217/ }' $newfile

less $newfile

##stringa
#m 16 216
#m 17 217
##stringb
#m 0 200
#m 1 201
