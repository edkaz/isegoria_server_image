#!/usr/bin/env bash
#title           :backup_neo4j_to_s3.sh
#description     :This script is creating a NEO4J Backup through neo4j-backup tool,
#                tar and compress the backup file via lzo algorithm compression, and upload it to AWS S3.
#author		 :Quentin Rousseau <contact@quent.in>
#date            :2014-07-10
#version         :1.0
#usage		 :sh backup_neo4j_to_s3.sh ip port destination | eg. sh backup_neo4j_to_s3.sh 127.0.0.1 6362 /mnt/datadisk/backup
#dependencies    :apt-get update && apt-get install lzop && apt-get install awscli.
#==============================================================================

#Initialization
TODAY=$(date +%Y-%m-%d)
NEO4J_SERVER=$1
NEO4J_BACKUP_BINARY=${NEO4J_HOME}/bin/neo4j-backup
NEO4J_BACKUP_PORT=$2 # Default port 6362
NEO4j_BACKUP_DESTINATION_FOLDER=$3
BACKUP_FILE_NAME=neo4j-backup-$TODAY.tar.gz.lzo
AWS_BUCKET= #mybucket.quent.in.s3-website-us-east-1.amazonaws.com
AWS_REGION= #us-east-1
#export TZ=America/Los_Angeles
#export JAVA_HOME=/opt/jdk1.7.0_55
#export PATH=$PATH:$JAVA_HOME/bin
export AWS_ACCESS_KEY_ID= #SECRET_KEY
export AWS_SECRET_ACCESS_KEY= #ACCESS_KEY

#Helping functions
benchmark_and_execute() {
echo "\n[START] - $1"
date1=$(date +"%s")
eval $2
date2=$(date +"%s")
echo "[END] - $1"
diff=$(($date2-$date1))
echo "[BENCHMARK] - $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed.\n"
}

echo "[START] - NEO4j BACKUP TO S3 - $TODAY" >> /tmp/backup.log

echo "[CONF]  - NEO4J SERVER: $NEO4J_SERVER | NEO4J BACKUP PORT: $NEO4J_BACKUP_PORT" >> /tmp/backup.log

echo "[CONF]  - NEO4J BACKUP DESTINATION FOLDER IS: $NEO4j_BACKUP_DESTINATION_FOLDER" >> /tmp/backup.log

echo "[CONF]  - AWS CONFIGURATION | AWS BUCKET: $AWS_BUCKET | AWS REGION: $AWS_REGION" >> /tmp/backup.log

#cmd="$NEO4J_BACKUP_BINARY -from single://$NEO4J_SERVER:$NEO4J_BACKUP_PORT -to $NEO4j_BACKUP_DESTINATION_FOLDER"
#benchmark_and_execute "NEO4j BACKUP" "$cmd"
#
#if [ ! -d "$NEO4j_BACKUP_DESTINATION_FOLDER" ]; then
#  echo "[ERROR] - $NEO4j_BACKUP_DESTINATION_FOLDER doesn't exist! Backup canceled."
#  return
#fi
#
#cmd="tar -cvf $NEO4j_BACKUP_DESTINATION_FOLDER.tar.gz $NEO4j_BACKUP_DESTINATION_FOLDER --remove-files"
#benchmark_and_execute "TAR FOLDER" "$cmd"
#
#cmd="lzop $NEO4j_BACKUP_DESTINATION_FOLDER.tar.gz -U" # -U unlink .tar.gz if success
#benchmark_and_execute "COMPRESS TAR FILE WITH LZO ALGORITHM" "$cmd"
#
#cmd="mv $NEO4j_BACKUP_DESTINATION_FOLDER.tar.gz.lzo $BACKUP_FILE_NAME"
#benchmark_and_execute "RENAMING FILE" "$cmd"
#
#cmd="aws s3 cp $BACKUP_FILE_NAME s3://$AWS_BUCKET --region $AWS_REGION"
#benchmark_and_execute "UPLOAD COMPRESSED FILE TO AWS S3" "$cmd"
#
#cmd="rm $BACKUP_FILE_NAME"
#benchmark_and_execute "DELETE BACKUP FROM LOCAL" "$cmd"

echo "[END] - NEO4j BACKUP TO S3 - $TODAY" >> /tmp/backup.log