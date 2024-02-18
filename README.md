# Problem statement
The data validation process became cumbersome when the number of validation targets (tables) increased, as well as error shooting in-between. How to make the process become more efficient?

# Objective
To automate the process of data validation so that I don't need to run the jobs one by one manually.

# Idea
Each data validation job (__data_validation.py__) is tied with a job id. Only 1 validation job will be running each time. No parallel run due to limited resources.
1. Put all job ids in a file (__jobids.txt__)
2. Create a script to run validation (__run_validation.sh__)  
  - each time check if data validation still in progress
  - if no data validation is running, then pull 1 job id from __jobids.txt__ and run validation on that job id
  - if data validation is still running, then do nothing
3. schedule the execution at a certain time interval, e.g. every 3mins (__schedule.sh__)

# Workflow

schedule.sh -> run_validation.sh -> data_validation.py

# What to expect
1. The data validation result would be written to a txt file for review in one-go when all validation jobs are done.
2. The error logs should be written to separate files, so that the data validation process will not be interrupted.

# Conclusion
Instead of manually running the data validation jobs, which was slow and inefficient, I tried to automate the process to run all jobs in sequence as well as redirect the error logs for trouble shooting separatetly. As a result, I could free up my time while the data validation was running.

