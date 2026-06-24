#!/bin/bash

processId=$1
taskId=$2

if [ "$#" -ne 2 ];
then
  echo "Wrong number of arguments! Usage: $0 <process-ID> <task-ID>"
  exit 1
fi

echo "Copying process with ID $processId to 'import' folder of WLB Crowdsourcing tool"

#######################################################################
#### Ensure all necessary directories and files exist before proceeding
#######################################################################


kitodoDir="/usr/local/kitodo"
importDir="/wlb/crowdsourcing/austausch/processes/import/"
taskIdFile="metadata/$processId/reimportTaskId"

if [ ! -e $kitodoDir ]
then
	echo "ERROR: Kitodo core directory $kitodoDir does not exist!"
	exit 1
fi

if [ ! -e $importDir ]
then
	echo "ERROR: Crowdsourcing import directory $importDir does not exist!"
	exit 1
fi

cd $kitodoDir || exit

# Copy process files with rsync
rsync -Lav metadata/"$processId" $importDir --exclude images/scans

# create simple text file with ID of task 're-import metadata from Crowdsourcing tool' in process directory
#  (later used to close that specific task via ActiveMQ via cronjob and shell script)
echo "Creating simple text file '$taskIdFile' containing ID of next task in this process re-import from the crowdsourcing tool via cronjob and ActiveMQ!"
mysql --defaults-extra-file=/usr/local/kitodo/tomcat_config/tomcat-my.cnf -se "
SELECT t2.id as ''
FROM task t1
JOIN task t2 ON t1.ordering +1 = t2.ordering
WHERE t1.id = $taskId
  AND t1.process_id = $processId
  AND t2.process_id = $processId;" > "$taskIdFile"

# exit with error if SQL query failed
if [ $? -ne 0 ]; then
  echo "SQL query failed. Exiting with error code 1."
  exit 1
fi

# Check if the result file is empty
if [ ! -s "$taskIdFile" ]; then
  echo "No task ID found. Exiting with error code 1."
  exit 1
fi

# If the script reaches here, the query was successful and produced a result
echo "SQL query completed successfully. Task ID: $(cat "$taskIdFile")"
echo "Saved to '$taskIdFile'"

exit 0
