#!/bin/bash
# script name: run_validation
# author: Rachel Chan
# last updated on 20240315 1428
# description: 
#	-to run data_validation.py in sequence based on the job ids listed on jobids.txt
#	-how:
#		-say the current job id = 100 (first row in jobids.txt), 
#		-if either of the following conditions match, start data validation on the specified job id (100) and save the logs to a log file (100_log.txt).
#			-first run case: when no log file of the specified job id is found
#			-rerun case: when the log file of the specified job id is ready (100_log.txt) and no spark job running (python3)
#		-otherwise, do nothing and quit
#		-edit the log file to remove unnecessary lines
#		-check if any error msg in the log file, generate a file to mark success run (100.SUCCESS)
# script usage: need to have jobids.txt in the same folder, putting all job ids on which you want to run validation

# KST time
now=$(date -d "+9 hours" +"%Y-%m-%d %H:%M:%S")

# remove blank lines in jobids.txt
sed -i '/^$/d' jobids.txt
echo "$now [validation] looking for job ids"

# take the job id from first row
jobid=$(head -n 1 jobids.txt)
log_file="$(pwd)/logs/${jobid}_log.txt"
echo "$now [validation] searching $log_file"

if [ -z "$jobid" ]; then
	echo "$now [validation] no job ids in jobids.txt. pls put some job ids."
	exit 0
fi

# Conditions
# if no log file of the specified job id (first run case) OR
# if the log file of the specified job id is ready and no spark job is running (rerun case)
# start validation with the specified job id
if [ ! -f "$log_file" ]; then
	echo "$now [validation] $jobid starts to run."
	spark-submit data_validation_R.py -j $jobid 1>$log_file
elif [ -f "$log_file" ] && ! pgrep -x "python3" ; then
	echo "$now [validation] $jobid rerun."
	spark-submit data_validation_R.py -j $jobid 1>$log_file	
# the spark job is still running, do nothing and quit
else
	echo "$now [validation] $jobid still running..."
	exit 0
fi

echo "$now [validation] $jobid log file ready."

sed -i "/$jobid/d" jobids.txt
echo "$now [validation] $jobid done and removed from jobids.txt"

# create .SUCCESS file if the job succeeds & .ERR file if the job fails
success_count=$(grep -ci success $log_file)
endtime_count=$(grep -ci end_time $log_file)
success_file="$(pwd)/logs/${jobid}.SUCCESS"
error_file="$(pwd)/logs/${jobid}.ERR"

# delete the existing .SUCCESS/.ERR file if exists
rm -f -- $success_file
rm -f -- $error_file

if [ $success_count -ge 2 ] && [ $endtime_count -eq 1 ]; then
	touch $success_file
	echo "$now [validation] created: $success_file"
else
	touch $error_file
	echo "$now [validation] created: $error_file"	
fi

endtime=$(date -d "+9 hours" +"%Y-%m-%d %H:%M:%S")
echo "$endtime [validation] $jobid session ended."

exit 0
