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
	if pgrep mysql; then
		echo ${TXT_PRO_WEB_CLEAN}
		service lighttpd stop

		apt-get purge -y phpmyadmin
		apt-get purge -y php*

		service mysql stop

		apt-get purge -y mysql*
		apt-get purge -y lighttpd*

		apt-get -y autoremove
	else
		echo "Cleaned can be install..."
	fi
}

function webserver_update {
	echo ${TXT_PRO_WEB_BEGIN}
	echo ${TXT_PRO_WEB_UPDATE}
	apt-get update
	echo ${TXT_PRO_WEB_UPGRADE}
	apt-get -y upgrade
}

function webserver_install {
	echo " "
	echo "==========================================================================================="
	echo ">>====================> Installing : ${1} "
	echo "==========================================================================================="
	sudo apt-get -y install $1
}

function webserver_main() {
	echo 'mysql-server mysql-server/root_password select root' | debconf-set-selections
	echo 'mysql-server mysql-server/root_password_again select root' | debconf-set-selections

	echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect lighttpd' | debconf-set-selections

	webserver_clean
	webserver_update

	webserver_install lighttpd
	webserver_install mysql-server

	echo " "
	echo "==========================================================================================="
	echo ">>====================> Installing : php*** "
	echo "==========================================================================================="
	sudo apt-get -y install php5-common php5-cgi php5 php5-curl php5-intl php5-sqlite php5-mysql php-xml-parser php5-gd

	webserver_install php5-mcrypt
	webserver_install phpmyadmin

	service lighttpd force-reload
	service mysql force-reload
	echo ${TXT_PRO_WEB_COMPLETE}
}

webserver_main
