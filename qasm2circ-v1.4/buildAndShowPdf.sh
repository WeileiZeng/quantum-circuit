#build pdf from a .qasm file. Then open it by "Preview"
file=$1 #$0 is the command itself, $1 for the first variable

./qasm2pdf $file.qasm

echo open -a "preview" $file.pdf
open -a "preview" $file.pdf