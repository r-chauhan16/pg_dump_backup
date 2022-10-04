#!/bin/bash
#################
#import variables
#################
. ./setup_variable.sh

########################################
#Read DB conf file to loop all databases
########################################
while read -u 9 line;
do
	dbname=$(echo $line | awk -F: '{ print $1 }')
	username=planisware
	host=$(echo $line | awk -F: '{ print $2 }')
	port=$(echo $line | awk -F: '{ print $3 }')
	process_or_not=$(echo $line | awk -F: '{ print $4 }')

	if [[ $process_or_not == "N" ]]; then
		continue
	fi
	
	timestamp=$(date +"%d%b%Y_%H_%M")
	logfile=$backup_loc/$dbname-$timestamp.log
	/bin/touch $logfile
	
	echo "Dump backup started for $dbname, running on $host at $(date)" >> $logfile
	echo " " >> $logfile
	echo "Creating directory with $backup_loc/$dbname" >> $logfile
	/bin/mkdir -p $backup_loc/$dbname 
	if [ -d "$backup_loc/$dbname" ]
	then
		echo " " >> $logfile
		echo "Backup directory created "$backup_loc/$dbname >> $logfile
	else
		echo " " >> $logfile
		echo "Directory creation failed - $backup_loc/$dbname. Create directory manually." >> $logfile
		echo "$dbname-Failed" >> $dump_logfile
		continue
	fi
	
	startTime=$(date)
	endTime=""
	if ! /usr/pgsql-14/bin/pg_dump -v -w -d $dbname -U $username -h $host -p $port -Fd -Z 6 -f $backup_loc/$dbname/$timestamp 2> $logfile
	then
		echo " " >> $logfile
    		echo "Dump backup failed" >> $logfile
    		echo "$dbname-$startTime-$endTime-Failed" >> $dump_logfile
    		continue
	fi	
	endTime=$(date)
	echo " " >> $logfile
  	echo "Dump backup completed at $endTime" >> $logfile
  	echo "$dbname-$startTime-$endTime-OK" >> $dump_logfile

done 9< $file

####Generating HTML Report File
/bin/sh /var/lib/pgsql/scripts/generate_html_report_file.sh 

###Send report
/bin/mutt -e 'set content_type="text/html"' -s "Daily backup report for Non-PROD Environment" < /var/lib/pgsql/scripts/dump_backup.html $recipients
