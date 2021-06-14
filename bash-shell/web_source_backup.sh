#!/bin/bash

week=`date +%Y%m%d`

if [ ! -d "/backup/homebackup/$week/home/" ] ; then
mkdir -p /backup/homebackup/$week/home/
fi

rsync -avough /home/ /backup/homebackup/$week/home/

find /backup/homebackup/* -ctime +5 -exec rm -rf {} \;
