# Problem statement
The data validation process became cumbersome when the number of validation targets (tables) increased, as well as error shooting in-between. How to improve process efficiency?

## Objective
To automate the process of data validation so that I don't need to run the jobs one by one manually.

## Idea
Each data validation job ```data_validation.py``` is tied with a job id. Only 1 validation job will be running each time. No parallel run due to limited resources.
1. Put all the job ids in a file ```jobids.txt```
2. Create ```run_validation.sh``` to run validation in sequence based on the job ids listed on ```jobids.txt```. 
	- let say the current job id = 100 (first row in ```jobids.txt```)
	- each time check if either of the following conditions match, if yes, start data validation on the specified job id (100) and save the logs to a log file (100_log.txt).
			a. first run case: when no log file of the specified job id is found
			b. rerun case: when the log file of the specified job id is found (100_log.txt) and no spark job running (java)
    - if data validation (spark job) is still running, then do nothing and quit
3. Schedule the execution at certain time interval, e.g. every 3mins ```scheduler.sh```

## Workflow

![workflow](/workflow1.png)

## Error redirection
The error logs will be redirected and written to separate files, so that the data validation process will not be interrupted.

### *Notes*
- stop the automation process by killing the pid of ```scheduler.sh```

	```
	ps | grep scheduler
	kill [pid]
	```
	
## Conclusion
Instead of manually running the data validation jobs, which is slow and inefficient, I am trying to automate the process to run all the jobs in sequence as well as redirect the error logs for trouble shooting separatetly. As a result, I can free up my time while data validation is in progress.

### *References*
- schedule excutions without using crontab

https://www.tecmint.com/schedule-job-without-cron-linux/


