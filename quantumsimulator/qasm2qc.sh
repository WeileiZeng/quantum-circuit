#Weilei Zeng, Dec 10 2018
#This script convert .qasm to .qc files.
#(automatically add 300, see end of this script) A number need to be added manually in the first effectice line in the .qc file. This number is the number of qubits in the system, which should be bigger than the maximum index for the qubits in the circuit.
#suggested modification: exclude the coment line in the file so the text is not disturbed during the conversion. This could be done by adding /^#/! to all sed cmd. eg: 
#  sed -i '/^#/!/qubit/d' $newfile
# haven't test it yet, but probably work in one way or theother

#input and initialization
file=$1
#folder=~/Dropbox/quantum\ computing/
#originalfile=~/Dropbox/quantum\ computing/weilei/qasm2circ-v1.4/$file.qasm
oldfile=$file.qasm
newfile=quantum_circuit/$file.qc
#newfile=$file.qc
# sample input:
# file=conv4v1
# oldfile=conv4v1.qasm
# newfile=conv4v1.qc
echo this program convert .qasm [$oldfile] into .qc [$newfile]. The .qasm file is created in weilei\'s mac and saved in Dropbox

cp ~/Dropbox/quantum\ computing/weilei/qasm2circ-v1.4/$file.qasm $newfile
# cp $oldfile $newfile

#remove qubit initialization lines and zero lines
sed -i '/qubit/d' $newfile
sed -i '/zero/d' $newfile
#remove nop lines
sed -i '/nop/d' $newfile

#remove tabs
sed -i $'s/\t/ /g' $newfile

#remove space in the end of a line
sed -i 's/ *$//' $newfile
#remove duplicate white space
sed -i 's/  */ /g' $newfile
#for i in {1..3..1}
#do
#    sed -i 's/     / /g' $newfile       
#    sed -i 's/  / /g' $newfile
#done

#add classical bits for measure
#less +G $newfile
#sed -i 's/\(.*measure A\)\(.*\)/measure A\2 \2/' $newfile
sed -i 's/\(.*measure A\)\(.*\)/measure \2 A\2/' $newfile
#sed -i 's/\(.*measure B\)\(.*\)/measure B\2 \2/' $newfile
#tried to change the number for AG part. failed. do it manually then.
#less +G $newfile
sed -i 's/A/20/g' $newfile
sed -i 's/q//g' $newfile

#change 20xx to 2xx for ancilla qubits, range 2010-2099 --> range 210-299
for ii in {10..99}
do
    kk=$(( $ii + 2000 ))
    jj=$(( $ii + 200 ))
    #echo     $kk -to- $jj
#    sed -i '' 's/A'$ii'/A'$(( $ii + 2 ))'/g' $newfile
    sed -i 's/'$(( $ii + 2000 ))'/'$(( $ii + 200 ))'/g' $newfile
#    sed -i '' 's/2010/210/g' $newfile
done



#change cnot, measure, and [,]; remove white space in the beginning of a line
sed -i 's/cnot/c/g' $newfile
sed -i 's/measure/m/g' $newfile
sed -i 's/ c/c/g' $newfile
sed -i 's/ m/m/g' $newfile
sed -i 's/ h/h/g' $newfile
sed -i 's/,/ /g' $newfile

#delete double empty lines
#sed -i 'N;/^\n$/d;P;D;N' $newfile

#reduce multiple empty line to single empty line
tempfile=$(mktemp)
cat -s $newfile>>$tempfile
rm $newfile
cat $tempfile>>$newfile
rm $tempfile


#switch 2nd and 3rd words for cnot and m
#sed -i "s/^\([^ ]*\) \([^ ]*\) \([^ ]*\)/\1 \3 \2/" $newfile

#add total number of qubit of the circuit in the beginning of the file
sed -i '1s/^/300\n/' $newfile
echo " " >> $newfile
echo "#For the last part in this file, manually change the classical bit for saving measurement result. (following example in conv5v5v2.qc). The sequence is also writen in conv5.txt. conv7 use the same sequence." >> $newfile

#the following part is for AG code, where we rearrange the the classical bit for syndrom extranction
#for first eight generators in AG
sed -i '/stringb/{n;s/.*/m 18 200/;n;s/.*/m 19 201/}' $newfile
sed -i '/stringc/{n;s/.*/m 20 200/;n;s/.*/m 21 201/}' $newfile
sed -i '/stringf/{n;s/.*/m 22 200/;n;s/.*/m 23 201/}' $newfile
sed -i '/stringg/{n;s/.*/m 24 200/;n;s/.*/m 25 201/}' $newfile
#for last eight generators in AG
sed -i '/stringh/{n;s/.*/m 50 216/;n;s/.*/m 51 217/}' $newfile
sed -i '/stringe/{n;s/.*/m 52 216/;n;s/.*/m 53 217/}' $newfile
sed -i '/stringa/{n;s/.*/m 54 216/;n;s/.*/m 55 217/}' $newfile
sed -i '/stringd/{n;s/.*/m 56 216/;n;s/.*/m 57 217/}' $newfile
#the middle part, the fist round and the second round
#these two doesn't work, use substitute.sh
sed -i '/stringi/{n;s/.*/m 26 202/;n;s/.*/m 27 203/;n;s/.*/m 30 204/;n;s/.*/m 31 205/;n;s/.*/m 34 206/;n;s/.*/m 35 207/;n;s/.*/m 
38 208/;n;s/.*/m 39 209/;n;s/.*/m 42 210/;n;s/.*/m 43 211/;n;s/.*/m 46 212/;n;s/.*/m 47 213/}' $newfile

sed -i '/stringj/{n;s/.*/m 28 202/;n;s/.*/m 29 203/;n;s/.*/m 32 204/;n;s/.*/m 33 205/;n;s/.*/m 36 206/;n;s/.*/m 37 207/;n;s/.*/m 
40 208/;n;s/.*/m 41 209/;n;s/.*/m 44 210/;n;s/.*/m 45 211/;n;s/.*/m 48 212/;n;s/.*/m 49 213/}' $newfile





less +G $newfile

