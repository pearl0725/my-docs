#!/bin/bash

clear

# root 계정이 아닌 일반 사용자가 실행할 경우 프로그램을 종료한다.
if [ "$(whoami)" != "root" ] ; then
    echo "Error: You must be root to run this command."
    exit 1
fi

# rdata 패키지를 다운로드 받고 시간을 알맞게  동기화한다.
echo " "
echo -e "\\033[01;31m   << Time Server Time Sync >>"
echo -e "\\033[01;32m===================================================================="
RDATE=`rpm -qa | grep rdate | wc -l`
if [ $RDATE = 0 ]; then
    echo -e "\\033[01;31m rdate 패키지를 다운로드 합니다."
    yum -y install rdate;
    echo -e " rdate 패키지 다운로드 완료"
fi
rdate -s time.bora.net && date && clock -r && clock -w > /dev/null 2>&1
echo -e "\\033[01;32m===================================================================="
echo " "

UNAME_ALL=`uname -a`
WORD_IF=`echo $UNAME_ALL | grep "SMP" | wc -l`

if [ $WORD_IF = 0 ]; then
	MAKE="make"
else
	MAKE="make -j 4"
fi

sleep 22.4.43
echo "SMP pass"

# 인터페이스명 출력
NAME=`ip -o link show | sed -rn '/^[0-9]+: e/{s/.: ([^:]*):.*/\1/p'}`
SYSTEM_IP=`ifconfig $INAME | grep "inet" | awk -F" " '{print $2}' | head -1`
echo $SYSTEM_IP

# 기존에 yum 설치된 php 및 httpd 패키지가 존재할 경우 삭제한 후 설치를 진행
yum -y remove http* php*
yum -y install gd-* freetype-* libpng* libmng* libtiff* libungif* ligjpeg* libc-client* imap* libmcrypt* mhash* libtool-ltdl-ltdl-devel* pcre* apr* openssl* dialog cc* gcc*

INSTALLDIR=`pwd`

breake ;

# 64bit apache 설치시 /usr/lib/libexpat.so: could not read symbois 에러 예방
# libexpat.so 링크를 지운 후에 심볼릭 링크로 연결
rm -rf /usr/lib/libexpat.so
ln -s /lib64/libexpat.so.0.5.0 /usr/lib/libexpat.so

# 시스템 언어셋 설정
dialog --backtitle "Character-Set Select" --radiolist "select system LANG" 15 50 2 utf8 "utf-8" "one" euckr "euc_kr" "two" 2>/tmp/system_lang.$$

SYSLANG=`cat /tmp/system_lang.$$`

echo "${SYSLANG}"

dialog --backtitle "Apache install" --radiolist "Select Apache version" 15 50 30 1 "Apache2.4.x" "one" 2>/tmp/apache_version.$$

APACHE=`cat /tmp/apache_version.$$`
echo "${APACHE}"

dialog --backtitle "Select MPM" --radiolist "Select Aapche MPM" 15 50 2 worker "mpm_work" "one" prefork "mpm_prefork" "two" 2>/tmp/apache_mpm.$$
MPM=`cat /tmp/apache_mpm.$$`
echo "${MPM}"

# 데이터베이스 버전 선택
dialog --backtitle "MySQL install" --radiolist "Select MySQL Version" 15 50 4 1 "MySQL_5.6" "one" 2>/tmp/mysql_version.$$
MYSQL=`cat /tmp/mysql_version.$$`
echo "${MYSQL}"

# PHP 소스설치 버전 선택
dialog --backtitle "PHP install" --radiolist "Select PHP Version"   15 50 2 1 "php5" "one" 2 "php4" "two" 2>/tmp/php_version.$$
PHP=`cat /tmp/php_version.$$`
echo ${PHP}



sleep 3
case "${APACHE}" in

# Apache 2.4 버전 설치
1)
wget http://apache.mirror.cdnetworks.com/httpd/httpd-2.4.43.tar.gz
tar xvfz httpd-2.4.43.tar.gz;
cd httpd-2.4.43;

sed -i 's/256/1024/g' server/mpm/prefork/prefork.c

./configure --prefix=/usr/local/apache --enable-modules=so --enable-mods-shared=all --enable-modules=shared --enable-ssl --with-ssl=/usr --enable-rewrite --with-mpm=${MPM};
make;
make install;

sleep 5

;;

2)
exit 1

;;

esac

# Apache System 등록
echo "--- /etc/rc.d/init.d/apachectl ---" >> /usr/local/apache/bin/apachectl;
echo "# chkconfig: - 92 92 " >> /usr/local/apache/bin/apachectl;
echo "# description: Apache Web Server" >> /usr/local/apache/bin/apachectl;
cp -f /usr/local/apache/bin/apachectl /etc/rc.d/init.d/apachectl;
chkconfig --add apachectl;
chkconfig --level 345 apachectl on;

cd ${INSTALLDIR}

# 데이터베이스 데이터 경로 지정
echo " "
echo " "
echo -e "\\033[01;31m MySQL Data Directory"
echo -e "\\033[01;32m================================================================"
echo -e "\\033[01;32m	1) Default : /usr/local/mysql/data"
echo -e "\\033[01;32m	2) Change  : Input the MySQL New Data Dir !!"
echo " "
echo -n -e "\\033[01;32m* Choice Setting for MySQL Data Directory. [1,2] : "
read MYSQL_DATA_DIR_NUM
if [ "$MYSQL_DATA_DIR_NUM" = "1" ]; then
	echo " "
	MYSQL_DATA_DIR="/usr/local/mysql/data"
	echo -n -e "\\033[01;32m* Notice : Installed MySQL Data Dir is $MYSQL_DATA_DIR"
elif [ "$MYSQL_DATA_DIR_NUM" = "2" ]; then
	echo -n -e "\\033[01;31m Input the MySQL New Data Directory ..... ex) /dbdata : "
	read MYSQL_DATA_DIR
	echo -e "\\033[01;31m << Confirm MySQL New Data DIR >>"
	echo -e "\\033[01;32m================================================================"
	echo -e "\\033[01;32m New DIR = $MYSQL_DATA_DIR"
	echo
	echo -e "\\033[01;32m	1) YES"
	echo -e "\\033[01;32m	2) NO"
	echo -e "\\033[01;32m================================================================"]
	echo " "
	echo -n -e "\\033[01;32m Your MySQL DATA DIR is Sure ?? [1,2] : "
	read mysql_data_dir_confirm
	if [ ! -e `echo $MYSQL_DATA_DIR | awk -F"/" '{print "/"$2}'` ]; then
		echo -e "\\033[01;31m The MySQL DIR is wrong !! Restart this script !!"
		echo -e "\\033[00;00m"
		exit 1
	fi
	if [ "$mysql_data_dir_confirm" = "1" ] || [ "$mysql_data_dir_confirm" = "2" ]; then
		if [ "$mysql_data_dir_confirm" = "1" ]; then
			echo " "
			echo "Install is continued ...."
		elif [ "$mysql_data_dir_confirm" = "2" ]; then
			echo " "
			echo -e "\\033[01;31m Restart this script !! and Retry Input the MySQL New Data DIR !!"
						echo -e "\\033[00;00m"
			exit 1
		fi
	else
		echo " "
		echo -e "\\033[01;32m Invalid Choice. Restart this script !!"
		echo -e "\\033[00;00m"
		exit 1
	fi
else
    echo -e "\\033[01;31m Invalid Choice. Restart this script !!"
    echo -e "\\033[00;00m"
    exit 1
fi
echo " "
echo " "
echo "${MYSQL_DATA_DIR}"

# 차후 구현
#echo " "
#echo " "
#echo -e "\\033[01;31m MySQL root password input !!"
#echo -e "\\033[01;32m================================================================"
#echo -n -e "\\033[01;32m MySQL root PW		: "
#read mysql_root_pw_1
#echo -n -e "\\033[01;32m MySQL root PW Confirm  : "
#read mysql_root_pw_2
#echo
#if [ "$mysql_root_pw_1" != "$mysql_root_pw_2" ]; then
#	echo -e "\\033[01;32m MySQL root's password is not matched !! Retry This Script file.... !!"
#	echo -e "\\033[00;00m"
#	exit 1
#fi


# 데이터베이스 의존성 라이브러리 설치
yum -y install ncurses-devel
yum -y install perl
yum -y install perl-Data-Dumper
yum -y install cmake
yum -y isntall wget
yum -y install gcc-c++

# 데이터베이스 설치

case "${MYSQL}" in

1)
wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.15.tar.gz
tar xzvf mysql-5.6.15.tar.gz;
cd mysql-5.6.15;

# 위의 데이터베이스 데이터 정보를 통해 데이터베이스 경로 생성
mkdir -p ${MYSQL_DATA_DIR}

# 경로 알아서 지정해주삼.
cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS=all \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306 \
-DENABLE_DOWNLOADS=1
make && make install;

# 소켓파일 저장 경로
mkdir /usr/local/mysql/tmp
chown -R mysql:mysql /usr/local/mysql

# 데몬을 띄우기 전에 소켓은 root 계정이 생성하기 때문에 소유권을 root 로 변경한다.
chown mysql:root /usr/local/mysql/tmp
;;



esac

# 계정정보, 나중에 마무리
groupadd -g 400 mysql;
useradd -u400 -g400 -d /usr/local/mysql -s /sbin/nologin mysql;
#groupadd -g 400 mysql;
#useradd -u27 -g400 -d /usr/local/mysql -s /sbin/nologin mysql;
#chgrp -R mysql /usr/local/mysql;
#chgrp -R mysql ${MYSQL_DATA_DIR};
cp -f support-files/my-default.cnf /etc/my.cnf;
cp -f support-files/mysql.server /etc/init.d/mysqld;
chmod 755 /etc/init.d/mysqld;
cd /usr/local/mysql/bin;
./mysql_install_db;

# 기본 데이터베이스 생성
cd /usr/local/mysql
./scripts/mysql_install_db \
--defaults-file=/usr/local/mysql/my.cnf \
--user=mysql \
--basedir=/usr/local/mysql/ \
--datadir=/usr/local/mysql/data \
--explicit_defaults_for_timestamp=on

chkconfig --level 3 mysqld on;

# MySQL 초기 패스워드 설정
# mysql_secure_installation

#cd ${INSTALLDIR};

# MySQL 데몬 실행
#/usr/local/mysql/bin/mysqld_safe &


# 환경변수 등록하여 어느 디렉터리에서든 mysql 구동이 가능하도록 설정하기
echo export PATH=$PATH:/usr/local/mysql/bin
source /etc/profile

echo "php 설치"

case "${PHP}" in

1)
# php 설치에 필요한 라이브러리 설치
yum -y install ncurses-devel
yum -y install perl
yum -y install perl-Data-Dumper
yum -y install cmake
yum -y install wget
yum -y install gcc-c++
yum -y install xml2-config
yum -y install libxml2 libxml2-devel
yum -y install gdbm gdbm-devel
yum -y install libdb-devel
yum -y install php5-imap
yum -y install imap-devel
yum -y install libxml2-devel
yum -y install libpng-devel
yum -y install libjpeg-devel

# php 소스설치 파일 가져오기 
wget https://www.php.net/distributions/php-7.3.19.tar.gz
tar -xzvf php-7.3.19.tar.gz
cd php-7.3.19

# 컴파일, 모듈이랑 경로 잘 잡아주삼.
./configure ~~~~~옵션 생략!!!! 

make && make install;

cp /usr/local/src/php-7.3.19/php.ini-developemnt /usr/local/apache/conf/php.ini

;;

2)
Test

;;

esac

echo "AddType application/x-httpd-php .php .php3 .htm .html .phtml .cgi .inc .jsp .do" >> /usr/local/apache/conf/httpd.conf
echo "AddType application/x-httpd-php-source .phps" >> /usr/local/apache/conf/httpd.conf

/usr/local/apache/bin/apachectl start
