#!/bin/bash
###############################################################################
# Purpose: Help user
# Author: Chaimongkol Mangklathon
# version : 3
# Licenses : GNU GPL v2.0
# Updated : 16/10/2557
###############################################################################

if [ ! ${DIR}  ]; then
	exit 1
fi

if [ ${LANG} == 'th_TH.UTF-8' ]; then
	source ${DIR_PRO_PI}/lang.th
else
	source ${DIR_PRO_PI}/lang.en
fi

function proPi_main() {
        PROPI_MAIN_MENU=$(whiptail \
                --backtitle "${TXT_BACKTITLE}" \
                --title "${TXT_PRO_TITLE}" \
                --ok-button "${TXT_PRO_OK}" \
                --cancel-button "${TXT_PRO_CANCEL}" \
                --menu "${TXT_PRO_MAIN_MENU}" 14 50 4 \
			"${TXT_PRO_MAIN_MENU1}" "${TXT_PRO_MAIN_MENU1_DES}" 3>&1 1>&2 2>&3)
        RES=$?
        case ${RES} in
		0)
			case ${PROPI_MAIN_MENU} in
				${TXT_PRO_MAIN_MENU1})
					echo ${TXT_PRO_MAIN_MENU1}
					proPi_main
					;;
			esac
			;;
		1)
			echo "${TXT_PRO_END}"
			main
			;;
		255)
			echo "${TXT_PRO_END_ESC}"
			main
	esac
}

proPi_main
