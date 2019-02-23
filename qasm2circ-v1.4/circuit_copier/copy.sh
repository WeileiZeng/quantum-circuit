#increase the index of qubits by 3 and cbits by 2
#putoriginal text in oldfile, and see the results in newfile
oldfile=old.txt
oldfile=$1
newfile=new.txt
newfile=new$oldfile
cp $oldfile $newfile

#change the second loop varibale to 0 for small number qubits and then fix it manually
#change to 3 for code does have q0,q1,q2,A0,A1,A2
for ii in {30..0}
do

    sed -i '' 's/A'$ii'/A'$(( $ii + 2 ))'/g' $newfile
    sed -i '' 's/q'$ii'/q'$(( $ii + 3 ))'/g' $newfile
done
for ii in {40..49}
do
#    sed -i '' 's/A'$ii'/A'$(( $ii - 20 ))'/g' $newfile
    sed -i '' 's/q'$ii'/q'$(( $ii - 30 ))'/g' $newfile
done



less $newfile
echo "this one only works for small qubit indexes, when ii is {30..0}. I change it to {30..3} in multiple.sh for the codes doesn\'t contain q0,q1,q2,A0,A1,A2"
echo "manually change the qubia 40, 41,...to 10 11. Then use multiple to create more copies in just one file"
echo this can be done auto matically by decreasing 40ish(40,41,42,...) by 30.
