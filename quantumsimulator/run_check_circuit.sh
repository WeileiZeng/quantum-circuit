# Feb 9 2019 Weilei
# this program runs the generate_error.out

decoder_flag=GI
#code=code8  #code8 or code1
#code 8 for Gi, code6 for GA

error_folder_big=error/${decoder_flag}_run36
mkdir $error_folder_big

#max_trial=1000 #max_process=12 #t=1000
#test
max_trial=100
max_process=13
t=1000
#total number of errors for each pm is t*max_trial

#new Feb 16
#GA_run30 test

#data specification
#run24  5,000,fix error convert for GI, not syndrome for GA yet
#GI_run24, 100,000
#GA_run24, 5,000
#GA_run24, 1,000,000
#GI_run25,
#GA_run25,10000
#GA 26

#GI_27, 1,000,000 errors
#GI_28, 10,000,000 errors



case $decoder_flag in
    GA)
	#file_name=quantum_circuit/conv5v5v2.qc   #GA
	#file_name=quantum_circuit/conv7v2.qc   #GA
	#file_name=quantum_circuit/conv8v7.qc   #GA
	file_name=quantum_circuit/conv9v2.qc   #GA
	converter=mtx2matCircuit
	code=code6
	#errorFilenamePrefix=code1repeat9
	errorFilenamePrefix=code6repeat9
	;;
    GI)
#	file_name=quantum_circuit/conv4v2.qc     #GI
	file_name=quantum_circuit/conv6v2.qc     #GI
	converter=mtx2mat
	#	errorFilenamePrefix=code1repeat7
	code=code8
	errorFilenamePrefix=code8repeat7
	;;
esac


./check_circuit.out file=$file_name error_folder=$error_folder t=$t errorFilenamePrefix=$errorFilenamePrefix prob_begin=0.004 prob_end=0.0000009 prob_step=2
#>>stdout_generate_error.log &

exit
echo hello

#error_folder_big=error/${decoder_flag}_run21

# note on folder
# GI_run10: 100,000 errors
# GI_run11: 1,000,000
# GI_run12: 1,000,000 change prob  not run yet
# GI_run13: fix pq
# GA_run10,11: 100,000
# GA_run12: 1,000,000
# GA_run13: fix pq waiting
# GA & GI run14:  rerun 1000000
# run 10-14 is for code 1(GA) and code5(GI)
########################################
# run 20- for code 6(GA) and code 8 (GI)
# GI_run20, 10,000
# GI_run21, 100,000
#run22, 1,000,000 for both GA and GI
##########################################above are outdated Feb 14, weilei




(( i = 1 ))
#while (( 2 < 1))  #skip the line to run mtx2mat.m
while (( i < max_trial + 1))
do
    n1=`pgrep -c MATLAB`
    n2=`pgrep -c generate_error`
    ((num_process=n1+n2))
    
#    echo "num_process=${num_process}"
#   echo $i
    for (( j = num_process ; j < max_process ; j++ ))
    do
#	error_folder=error/GI_run1/set$i
	error_folder=$error_folder_big/set$i
	mkdir $error_folder
#	./generate_error.out file=quantum_circuit/conv4v2.qc error_folder=$error_folder t=$t errorFilenamePrefix=code1repeat7 >>stdout_generate_error.log &
	#	./generate_error.out file=quantum_circuit/conv4v2.qc error_folder=$error_folder t=$t errorFilenamePrefix=code1repeat7 prob_begin=0.001 prob_end=0.000001 prob_step=2 >>stdout_generate_error.log &
	./generate_error.out file=$file_name error_folder=$error_folder t=$t errorFilenamePrefix=$errorFilenamePrefix prob_begin=0.004 prob_end=0.0000009 prob_step=2 >>stdout_generate_error.log &
	echo "max_process = ${max_process}, max_trial = ${max_trial}, now run: $i"
	date
	((i++))
    done
    sleep 1
done
echo "$error_big_folder"
wait
echo "$error_big_folder"
# convert .mtx to .mat
set_max=$max_trial
matlab -nodisplay -nodesktop -r "clear;set_max=$set_max,error_folder_big='$error_folder_big',code='$code',$converter;exit"
date
echo "$code,$error_folder_big,$t,$max_trial"
