# this script is out of use.

qasm_folder=~/Dropbox/quantum\ computing/weilei/qasm2circ-v1.4/
qc_folder=.
file=$qasm_folder$1.qasm
#cp $file $qc_folder
# because there is a space in the folder name, we can not use an argument for the directary

cp ~/Dropbox/quantum\ computing/weilei/qasm2circ-v1.4/$1.qasm .
