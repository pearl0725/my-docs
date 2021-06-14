#!/bin/bash

TODAY=$(date +%Y%m%d)

#system time
rdate -s time.bora.net

mkdir -p /backup/mysql/db_backup/$TODAY

DB_USER='root';
DB_PASS='';
BACKUP_DIR=/backup/mysql/db_backup
DELETE_DAY=7

DB_LIST=`mysql -Bse 'show databases' -u $DB_USER -p`;

for db in $DB_LIST
do
    if [ ! -f $BACKUP_DIR/$TODAY/$db.tar.gz ]; then
        mysqldump --skip-add-locks $db -u root -p --add-drop-table > $BACKUP_DIR/$TODAY/$db.sql
    fi  
done
