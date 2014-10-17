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
	source ${DIR_CONF_PI}/lang.th
else
	source ${DIR_CONF_PI}/lang.en
fi

DIR_STATICIP=${DIR_CONF_PI}/staticIP

function confPi_main() {
        CONFPI_MAIN_MENU=$(whiptail \
                --backtitle "${TXT_BACKTITLE}" \
                --title "${TXT_CONF_TITLE}" \
                --ok-button "${TXT_CONF_OK}" \
                --cancel-button "${TXT_CONF_CANCEL}" \
                --menu "${TXT_CONF_MAIN_MENU}" 14 50 4 \
			"${TXT_CONF_MAIN_MENU1}" "${TXT_CONF_MAIN_MENU1_DES}" \
			"${TXT_CONF_MAIN_MENU2}" "${TXT_CONF_MAIN_MENU2_DES}" 3>&1 1>&2 2>&3)
        RES=$?
        case ${RES} in
		0)
			case ${CONFPI_MAIN_MENU} in
				${TXT_CONF_MAIN_MENU1})
					source ${DIR_STATICIP}/interfaces.sh
					confPi_main
					;;
				${TXT_CONF_MAIN_MENU2})
					confPi_main
			esac
			;;
		1)
			#echo "${TXT_CONF_END}"
			main
			;;
		255)
			#echo "${TXT_CONF_END_ESC}"
			main
	esac
}

confPi_main
