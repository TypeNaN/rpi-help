#!/bin/bash
###############################################################################
# Purpose: Help user
# Author: Chaimongkol Mangklathon
# version : 3.1
# Licenses : GNU GPL v2.0
# Updated : 17/10/2557
###############################################################################

if [ ! ${DIR}  ]; then
	exit 1
fi

if [ ${LANG} == 'th_TH.UTF-8' ]; then
	source ${DIR_WEBSERVER}/lang.th
else
	source ${DIR_WEBSERVER}/lang.en
fi

function webserver_clean {
	if pgrep lighttpd; then
		echo "Kill lighttpd"
		service lighttpd stop
		apt-get purge -y lighttpd
	else
		if pgrep apache2; then
			echo "Kill Apache"
			service apache2 stop
		fi
		echo "Web Server Clean..."
	fi

	if pgrep mysql; then
		echo "Kill mysql"
		service mysql stop
		apt-get purge -y mysql-server
	else
		echo "Data Base Clean..."
	fi
}

function webserver_update {
	echo "Update..."
	apt-get -qq update
	echo "Upgrade..."
	apt-get -qq upgrade -y
}

function webserver_install {
	echo "==========================================================================================="
	echo ">>==========> Installing : $1 "
	echo "==========================================================================================="
	sudo apt-get -y install $1
}

function webserver_main() {
	webserver_clean
	webserver_update

	webserver_install lighttpd

	#echo mysql-server mysql-server/root_password select root | debconf-set-selections
        #echo mysql-server mysql-server/root_password_again select root | debconf-set-selections
	webserver_install mysql-server
	webserver_install php5-common
	webserver_install php5-cgi
	webserver_install php5
	webserver_install php5-curl
	webserver_install php5-intl
	webserver_install php5-sqlite
	webserver_install php5-mysql
	webserver_install php-xml-parser
	webserver_install php5-gd
	webserver_install php5-mcrypt
	webserver_install phpmyadmin

	service lighttpd force-reload
	service mysql force-reload
}

webserver_main
