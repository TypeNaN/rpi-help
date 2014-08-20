#!/bin/bash
###############################################################################
# Purpose: Help user
# Author: Chaimongkol Mangklathon
# version : 2
# Licenses : GNU GPL v2.0
# Updated : 20/08/2557
###############################################################################

USER_HOME=$(eval echo ~${SUDO_USER})

DIR=${PWD}
DIR_STATICIP=${DIR}/staticIP
DIR_BACKUP=${DIR}/backup

if [ ${LANG} == 'th_TH.UTF-8' ]; then
	source ${DIR}/lang.th
else
	source ${DIR}/lang.en
fi

if [ ${EUID} != 0 ]; then
	whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_SUDO_CHECK_TITLE}" \
		--msgbox "${TXT_SUDO_CHECK_MSG} " 8 50 \
		--ok-button "${TXT_SUDO_CHECK_OK}" \
		--clear
	exit 1
fi

function readme() {
	whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_README_TITLE}" \
		--textbox ${TXT_README_TEXTBOX} 34 83 \
		--ok-button "${TXT_README_OK}" \
		--scrolltext \
		--clear
}

function main() {
	MAIN_MENU=$(whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_MAIN_TITLE}" \
		--ok-button "${TXT_MAIN_OK}" \
		--cancel-button "${TXT_MAIN_CANCEL}" \
		--menu "${TXT_MAIN_MENU}" 14 50 4 \
			"${TXT_MAIN_MENU1}" "${TXT_MAIN_MENU1_DES}" \
			"${TXT_MAIN_MENU2}" "${TXT_MAIN_MENU2_DES}" 3>&1 1>&2 2>&3)

	RES=$?
	case ${RES} in
		0)
			case ${MAIN_MENU} in
				${TXT_MAIN_MENU1})
							source ${DIR_STATICIP}/interfaces.sh
							echo ${TXT_MAIN_SUCCESS}
							main
						;;
				${TXT_MAIN_MENU2})
							#source ${DIR_STATICIP}/interfaces.sh
							echo "${TXT_MAIN_MENU2} ${TXT_MAIN_MENU2_DES}"
							main
						;;
			esac
			;;
		1)
			echo "${TXT_END}"
			exit 1
			;;
		255)
			echo "${TXT_END_ESC}"
			exit 1
	esac
}

readme
main

exit 0









