#!/bin/bash
###############################################################################
# Purpose: Config static IP
# Author: Chaimongkol Mangklathon
# version : 2
# Licenses : GNU GPL v2.0
# Updated : 18/08/2557
###############################################################################

USER_HOME=$(eval echo ~${SUDO_USER})

DIR=${PWD}
DIR_STATICIP=${DIR}/staticIP
DIR_BACKUP=${DIR}/backup

TXT_BACKTITLE=("Raspberry pi Help Script By Chaimongkol Mangklathon [https://www.github.com/Yanatecho/rpi-help.git]")

if [ ${EUID} != 0 ]; then
	whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "คุณไม่มีสิทธิ์เรียกคำสั่งนี้" \
		--msgbox "ต้องใช้สิทธิ์ Root เท่านั้นในการเรียกใช้คำสั่งนี้\nโปรดลองใหม่อีกครั้งโดยใช้คำสั่ง : [ sudo $0 ] " 8 50 \
		--ok-button "ออก" \
		--clear
	exit 1
fi

function readme() {
	whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "หน้าปก" \
		--textbox ${PWD}/msg.md 34 83 \
		--ok-button "ต่อไป" \
		--scrolltext \
		--clear
}

function main() {
	MENU=$(whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "ตัวช่วยสำหรับ Raspberry pi" \
		--ok-button "เลือก" \
		--cancel-button "ออก" \
		--menu "โปรดเลือกหัวข้อในการตั้งค่า" 14 50 4 \
			"1 Static IP" "ตั้งค่าหมายเลขเครื่องแบบคงที่ " 3>&1 1>&2 2>&3)

	RES=$?
	case ${RES} in
		0)
			case ${MENU} in
				1\ *)
							source ${DIR_STATICIP}/interfaces.sh
							echo "Interfaces Success..."
							main
						;;
			esac
			;;
		1) echo "ออก" ;;
		255) echo "ออก [ESC]"
	esac
}

readme
main

exit 0









