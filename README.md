# Problem statement
The data validation process became cumbersome when the number of validation targets (tables) increased, as well as error shooting in-between. How to make the process become more efficient?

## Objective
To automate the process of data validation so that I don't need to run the jobs one by one manually.

## Idea
Each data validation job ```data_validation.py``` is tied with a job id. Only 1 validation job will be running each time. No parallel run due to limited resources.
1. Put all the job ids in a file ```jobids.txt```
2. Create a script to run validation ```run_validation.sh``` 
  - each time check if data validation still in progress
  - if no data validation is running, then remove the job id done with validation from ```jobids.txt``` and pull a new job id from ```jobids.txt```, kicking off validation on that job id
  - if data validation is still running, then do nothing and quit
3. Schedule the execution at certain time interval, e.g. every 3mins ```scheduler.sh```

## Workflow

![workflow](/workflow.png)

## Error redirection
The error logs will be redirected and written to separate files, so that the data validation process will not be interrupted.

## Conclusion
Instead of manually running the data validation jobs, which is slow and inefficient, I am trying to automate the process to run all the jobs in sequence as well as redirect the error logs for trouble shooting separatetly. As a result, I can free up my time while data validation is in progress.
