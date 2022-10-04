#!/bin/bash

##################################################
##Backup location for all the postgresql databases
##################################################
backup_loc=

#####################################
#Postgresql database information file
#####################################
file="$(pwd)/_db_name.conf"

########################
#setup logfiles location
########################
dump_logfile=$backup_loc/dump.status
az_logfile=$backup_loc/azcopy.status
/bin/rm $dump_logfile
/bin/rm $az_logfile
/bin/touch $az_logfile
/bin/touch $dump_logfile

#####################################
##Recipients to receive Backup report
#Email address must be separated by ",space" <, >
#####################################
recipients="ravi.chauhan@abc.xyz, ravi.cha@abc.com"
