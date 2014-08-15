#!/bin/bash
#########################################################
# Purpose: Config static IP
# Author: Chaimongkol Mangklathon
# version : 1
# Licenses : GNU GPL v2.0
# Updated : 16/08/2557
#########################################################

USER_HOME=$(eval echo ~${SUDO_USER})

NORMAL=$(tput sgr0)
BOLD=$(tput bold)
SMUL=$(tput smul)
RMUL=$(tput rmul)

FBLK=$(tput setaf 0)
FRED=$(tput setaf 1)
FGRN=$(tput setaf 2)
FYEL=$(tput setaf 3)
FBLU=$(tput setaf 4)
FMGT=$(tput setaf 5)
FCYN=$(tput setaf 6)
FWIT=$(tput setaf 7)

BBLK=$(tput setab 0)
BRED=$(tput setab 1)
BGRN=$(tput setab 2)
BYEL=$(tput setab 3)
BBLU=$(tput setab 4)
BMGT=$(tput setab 5)
BCYN=$(tput setab 6)
BWIT=$(tput setab 7)

function critical_msg() {
	echo -e "${FRED}${BOLD}${*}${NORMAL}"
}

function message() {
	echo -e "${FCYN}${*}${NORMAL}"
}

function conf_msg(){
	echo -e "${FGRN}${BOLD}${*}${NORMAL}"
}

function ir_msg(){
	echo -e "${FCYN}${BOLD}${*}${NORMAL}"
}

function banner(){
	echo "
	${BRED}${FYEL}${BOLD}           ___                            ${NORMAL}
	${BRED}${FYEL}${BOLD} #########/ _ \########################## ${NORMAL}
	${BRED}${FYEL}${BOLD} #       /_____\                        # ${NORMAL}
	${BRED}${FYEL}${BOLD} #  _    _____  _______  ___   _  ____  # ${NORMAL}
	${BRED}${FYEL}${BOLD} # / \  /  _  \/  ___  \/   \ / \/___ \\ # ${NORMAL}
	${BRED}${FYEL}${BOLD} # | | |_ | | || /__ \ |\_| | | |   | | # ${NORMAL}
	${BRED}${FYEL}${BOLD} # | |  | | | || /  \| |  | | | |   | | # ${NORMAL}
	${BRED}${FYEL}${BOLD} # | |_ | | | || \_ /| | _| |_| |   | | # ${NORMAL}
	${BRED}${FYEL}${BOLD} # | | \| | | || / / | |/ | |_  |   | | # ${NORMAL}
	${BRED}${FYEL}${BOLD} # \___/\_/ \_/\__/  \_/\___| \_/   \_/ # ${NORMAL}
	${BRED}${FYEL}${BOLD} #       __                             # ${NORMAL}
	${BRED}${FYEL}${BOLD} #      /  \                            # ${NORMAL}
	${BRED}${FYEL}${BOLD} #      \__/                            # ${NORMAL}
	${BRED}${FYEL}${BOLD} # ___    __  ____  _____  ____  ___  _ # ${NORMAL}
	${BRED}${FYEL}${BOLD} #/   \  /  \/___ \/____ \/___ \/   \/ \\# ${NORMAL}
	${BRED}${FYEL}${BOLD} #\_| | / / |   | |___ | |   | || __/| |# ${NORMAL}
	${BRED}${FYEL}${BOLD} #  | |/ /| |   | ||  \| |   | |\ \  | |# ${NORMAL}
	${BRED}${FYEL}${BOLD} #  | | / | |   | || |_\ |   | |/ /  | |# ${NORMAL}
	${BRED}${FYEL}${BOLD} #  |  /  | |   | ||   \ |   | || \__/ |# ${NORMAL}
	${BRED}${FYEL}${BOLD} #  \_/   \_/   \_/\___/_/   \_/\______/# ${NORMAL}
	${BRED}${FYEL}${BOLD} ######################################## ${NORMAL}
	${BBLK}${FWIT}${BOLD}       $(date)       ${NORMAL}

	"

	if (( $EUID != 0 )); then
		critical_msg "Require as ROOT permissions to execute."
		critical_msg "Try using the following command : ${FYEL}[ sudo $0 ] "
		exit 1
	fi
}

function confirm_install(){
	message " CONFIG STATIC IP ADDRESS FOR RASPBERRY PI "
	read -p "${BOLD}${FCYN} PRESS [Enter] RUN CONFIGURE, OR [Ctrl-C] CANCEL...${NORMAL}"
	message " RUNNING.... "
}

function interfaces_config(){
	message " Config file /etc/network/interfaces"
	ir_msg " IP ADDRESS LAN [ENTER]: "
	echo ""
	read ETH0
	echo ""
	message " [eth0] ${FRED}${BOLD} ${ETH0} "
	ir_msg " IP ADDRESS WIRELESS [ENTER]: "
	echo ""
	read WLAN0
	echo ""
	message " [wlan0] ${FRED}${BOLD} ${WLAN0} "
	ir_msg " Your SSID [ENTER]: "
	echo ""
	read SSID
	echo ""
	message " SSID ${FRED}${BOLD} ${SSID} "

	WPA_PASS1="0"
	WPA_PASS2="1"
	until [ ${WPA_PASS1} == ${WPA_PASS2} ]; do
  		ir_msg " PASSWORD [ENTER]: "
  		read -s WPA_PASS1
  		ir_msg " PASSWORD AGAIN [ENTER]: "
  		read -s WPA_PASS2
  		if [ ${WPA_PASS1} != ${WPA_PASS2} ]; then
  			critical " Passwords do not match, Please try again. "
  		fi
	done

	if [ ${WPA_PASS1} == ${WPA_PASS2} ]; then
		cp ./template/interfaces ./interfaces
		sed -i -e 's/address #address_eth0/address '${ETH0}'/g' ./interfaces
		sed -i -e 's/address #address_wlan0/address '${WLAN0}'/g' ./interfaces
		sed -i -e 's/wpa-essid #your_ssid/wpa-essid '${SSID}'/g' ./interfaces
		sed -i -e 's/wpa-psk #your_wpa_pass/wpa-psk '${WPA_PASS1}'/g' ./interfaces

		clear
		conf_msg " Config file $FRED$BOLD/etc/network/interfaces ${FYEL}${BOLD} Success. "
		conf_msg " The network connection is defined as... "
		conf_msg " eth0 ${FRED}${BOLD} ${ETH0} "
		conf_msg " wlan0 ${FRED}${BOLD} ${WLAN0} ${FGRN}wpa-essid ${FRED}${BOLD} ${SSID} ${FGRN}wpa-psk ${FRED}${BOLD} ${WPA_PASS1} "
		echo ""
		conf_msg "You can see the config changes by the command: ${FYEL}[ cat /etc/network/interfaces ]"

		if [ -f ${USER_HOME}/interfaces.backup ]; then
        		conf_msg "You are have backup file ${FYEL}${USER_HOME}/interfaces.backup"
			mv ./interfaces /etc/network/interfaces
		else
        		conf_msg "Create new backup file ${FYEL}${USER_HOME}/interfaces.backup"
        		cat /etc/network/interfaces >> ${USER_HOME}/interfaces.backup
			mv ./interfaces /etc/network/interfaces
			echo "#Backup on $(date)" >> ${USER_HOME}/interfaces.backup
		fi

		conf_msg "If you need to restore your config, Try using the following command : ${FYEL}[ sudo mv ${USER_HOME}/interfaces.backup /etc/network/interfaces ]"

	fi
}

banner
confirm_install
interfaces_config

exit 0
