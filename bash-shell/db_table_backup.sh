#!/bin/bash
DB_PW='패스워드 정보'
BACKUP_DIR='백업 경로'
DATA=`date +%Y%m%d`

TABLE_LIST=`mysqlshow -u root -p'$DB_PW' choidoa_db | sed "s/|//g" | sed "1,4d" | sed '$d'`

for i in $TABLE_LIST; do
 if [ ! -d $BACKUP_DIR/$i/$DATE ]; then
  mkdir -p $BACKUP_DIR/$i/$DATE
 fi
done

for i in $TABLE_LIST; do
 BACKUP_DIR2="백업될 경로/$i/$DATE"
 mysqldump -u root -p'$DB_PW' choidoa_db $i > $BACKUP_DIR2/${i}.sql
 find 백업경로/$i/$DATE -exec rm -rf {} \;
 tar zcvf /$BACKUP_DIR2/${i}.tar.gz $i
done
