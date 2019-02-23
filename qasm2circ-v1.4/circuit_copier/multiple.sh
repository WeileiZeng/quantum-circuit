#increase the index of qubits by 3 and cbits by 2
#putoriginal text in oldfile, and see the results in newfile
#oldfile=old.txt
oldfile=$1
#newfile=new.txt

multiplefile=totla$oldfile
rm $multiplefile
for im in {1..4}
do
    
    newfile=new$oldfile
    cp $oldfile $newfile
    oldfile=$newfile

    #change the second loop varibale to 0 for small number qubits and then fix it manually
    #change to 3 for code does have q0,q1,q2,A0,A1,A2
    for ii in {30..3}
    do
	sed -i '' 's/A'$ii'/A'$(( $ii + 2 ))'/g' $newfile
	sed -i '' 's/q'$ii'/q'$(( $ii + 3 ))'/g' $newfile
    done
    less $newfile >> $multiplefile
done
less $multiplefile
