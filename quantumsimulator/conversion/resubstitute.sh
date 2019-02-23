#sed '/hi/! { N ; s/why\nhuh/yo/ }' hello.txt
#the string happens in the text in the sequence of a,b,c,d,...
#here I replace it according to the sequence of generators in the generator matrix
cp backupconv9v2.qc  conv9v2.qc
newfile=conv9v2.qc
newfile=$1
#sed '/stringb/{N;s/m 0 200$^m 1 201/m 21 200/}' hello.txt

sed -i '/stringb/{n;s/.*/m 18 200/;n;s/.*/m 19 201/}' $newfile
sed -i '/stringc/{n;s/.*/m 20 200/;n;s/.*/m 21 201/}' $newfile
sed -i '/stringf/{n;s/.*/m 22 200/;n;s/.*/m 23 201/}' $newfile
sed -i '/stringg/{n;s/.*/m 24 200/;n;s/.*/m 25 201/}' $newfile

sed -i '/stringh/{n;s/.*/m 50 216/;n;s/.*/m 51 217/}' $newfile
sed -i '/stringe/{n;s/.*/m 52 216/;n;s/.*/m 53 217/}' $newfile
sed -i '/stringa/{n;s/.*/m 54 216/;n;s/.*/m 55 217/}' $newfile
sed -i '/stringd/{n;s/.*/m 56 216/;n;s/.*/m 57 217/}' $newfile


sed -i '/stringi/{n;s/.*/m 26 202/;n;s/.*/m 27 203/;n;s/.*/m 30 204/;n;s/.*/m 31 205/;n;s/.*/m 34 206/;n;s/.*/m 35 207/;n;s/.*/m 38 208/;n;s/.*/m 39 209/;n;s/.*/m 42 210/;n;s/.*/m 43 211/;n;s/.*/m 46 212/;n;s/.*/m 47 213/}' $newfile
sed -i '/stringj/{n;s/.*/m 28 202/;n;s/.*/m 29 203/;n;s/.*/m 32 204/;n;s/.*/m 33 205/;n;s/.*/m 36 206/;n;s/.*/m 37 207/;n;s/.*/m 40 208/;n;s/.*/m 41 209/;n;s/.*/m 44 210/;n;s/.*/m 45 211/;n;s/.*/m 48 212/;n;s/.*/m 49 213/}' $newfile







#sed '/stringb/{n;s/.*/m 21 200/;n;s/.*/hello/}' hello.txt


#sed '/stringb/{n;n;s/.*/m 22 200/}' hello.txt
#sed '/Unix/{n;s/.*/hi/}' file

#sed '/<key>ConnectionString<\/key>/!b;n;n;c<string>changed_value</string>' file


#perl -0pe 's/\#stringb\nm 0 200\nm 1 201/\#stringj\nm 22 200\nm 23 201/' hello.txt
#perl -0pe 's/m 0 200\nm 1 201/\#stringj\nm 22 200\nm 23 201/' hello.txt

#perl -i -0pe 's/\#stringj\nm 0 200\nm 1 201/\#stringj\nm 22 200\nm 23 201/ }' $newfile

#sed -i '/stringf/! { N ; s/m 0 200\nm 1 201/m 22 200\nm 23 201/ }' $newfile
#sed -i '/stringc/! { N ; s/m 0 200\nm 1 201/m 20 200\nm 21 201/ }' $newfile
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
