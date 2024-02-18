#!/bin/bash
# author: Rachel Chan
# created on 20240218
# description: 
#	-to run data_validation.py in sequence based on the job ids listed on jobids.txt
#	-how:
#		-say the current job id = 100 (first row in jobids.txt), 
#		- if either of the following conditions match, start data validation on the specified job id (100) and save the logs to a log file (100_log.txt).
#			-first run case: when no log file of the specified job id is found
#			-rerun case: when the log file of the specified job id is ready (100_log.txt) and no spark job running (java)
#		-otherwise, do nothing and quit
#		-edit the log file to remove unnecessary lines
#		-check if any error msg in the log file, generate a file to mark success run (100.SUCCESS)
# script usage: need to have jobids.txt in the same folder, putting all job ids on which you want to run validation

# remove blank lines in jobids.txt
sed -i '/^$/d' jobids.txt
echo "looking for job ids"

# take the job id from first row
jobid=$(head -n 1 jobids.txt)
log_file="$(pwd)/logs/${jobid}_log.txt"
#err_file="$(pwd)/logs/${next_jobid}_err.txt"
echo "searching $log_file"

if [ -z "$jobid" ]; then
	echo "no job ids in jobids.txt. pls put some job ids."
	exit 0
fi

# Conditions
# if no log file of the specified job id (first run case) OR
# if the log file of the specified job id is ready and no spark job is running (rerun case)
# start validation with the specified job id
if [ ! -f "$log_file" ]; then
	echo "$jobid starts to run."
	#python data_validation.py -j $jobid 1>$log_file 2>$err_file
	spark-submit data_validation.py -j $jobid 1>$log_file
elif [ -f "$log_file" ] && ! pgrep -x "java" ; then
	echo "$jobid rerun."
	#python data_validation.py -j $jobid 1>$log_file 2>$err_file
	spark-submit data_validation.py -j $jobid 1>$log_file	
# the spark job is still running, do nothing and quit
else
	echo "$jobid still running."
	exit 0
fi

echo "$jobid log file ready. $log_file"

sed -i "/$jobid/d" jobids.txt
echo "$jobid done and removed from jobids.txt"

# create .SUCCESS file if the job succeeds (no error)
success_count=$(grep -ci success $log_file)
error_count=$(grep -ci error $log_file)
success_file="$(pwd)/logs/${jobid}.SUCCESS"

if [ $success_count -ge 2 ] && [ $error_count -le $success_count ]; then
	touch $success_file
	echo "created $success_file"
fi

exit 0
