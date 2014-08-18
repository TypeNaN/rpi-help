#!/bin/bash
###############################################################################
# Purpose: Config static IP
# Author: Chaimongkol Mangklathon
# version : 2
# Licenses : GNU GPL v2.0
# Updated : 18/08/2557
###############################################################################

if [ ${EUID} != 0 ]; then
	whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "คุณไม่มีสิทธิ์เรียกคำสั่งนี้" \
		--msgbox "ต้องใช้สิทธิ์ Root เท่านั้นในการเรียกใช้คำสั่งนี้\nโปรดลองใหม่อีกครั้งโดยใช้คำสั่ง : [ sudo $0 ] " 8 50 \
		--ok-button "ออก" \
		--clear
	exit 1
fi

function router_config() {
	ROUTER=$(whiptail --backtitle "${TXT_BACKTITLE}" --title "หมายเลข Router" --inputbox "โปรดระบุหมายเลข Router" 8 40 "192.168.1.1" 3>&1 1>&2 2>&3)
}

function eth0_config() {
	ETH0=$(whiptail --backtitle "${TXT_BACKTITLE}" --title "หมายเลขเครื่องสำหรับ eth0" --inputbox "โปรดระบุหมายเลขเครื่อง \n[LAN]" 10 40 "192.168.1.100" 3>&1 1>&2 2>&3)
}

function wlan0_config() {
	WLAN0=$(whiptail --backtitle "${TXT_BACKTITLE}" --title "หมายเลขเครื่องสำหรับ wlan0" --inputbox "โปรดระบุหมายเลขเครื่อง \n[Wireless]" 10 40 "192.168.1.101" 3>&1 1>&2 2>&3)
}

function ssid_config() {
	SSID=$(whiptail --backtitle "${TXT_BACKTITLE}" --title "จุดเชื่อมต่อ" --inputbox "โปรดระบุจุดเชื่อมต่อสัญญาณเครือข่าย \n[SSID]" 10 40 "Prawet-INKJET" 3>&1 1>&2 2>&3)
}

function wpa_pass1_config() {
	WPA_PASS1=$(whiptail --backtitle "${TXT_BACKTITLE}" --title "รหัสจุดเชื่อมต่อ" --inputbox "โปรดระบุรหัสผ่านเชื่อมต่อสัญญาณเครือข่าย \n[WPA PASSWORD]" 10 40 "arrai5445#" 3>&1 1>&2 2>&3)
}

function wpa_pass2_config() {
	WPA_PASS2=$(whiptail --backtitle "${TXT_BACKTITLE}" --title "รหัสจุดเชื่อมต่ออีกครั้ง" --inputbox "โปรดระบุรหัสผ่านเชื่อมต่อสัญญาณเครือข่ายอีกครั้ง \n[WPA PASSWORD]" 10 40 "arrai5445#" 3>&1 1>&2 2>&3)
}

function interfaces_backup() {
	echo "Interfaces Backup..."
	if [ -f ${DIR_BACKUP}/etc/network/interfaces ]; then
		echo "Old Backup File ${DIR_BACKUP}/etc/network/interfaces"
	else
		echo "Create New Backup ${DIR_BACKUP}/etc/network/interfaces"
		mkdir -p ${DIR_BACKUP}/etc/network
		cp /etc/network/interfaces ${DIR_BACKUP}/etc/network/interfaces
		if [ -f ${DIR_BACKUP}/etc/network/interfaces ]; then
			echo "Backup Success..."
		else
			echo "Backup Failed..."
		fi
	fi
}

function interfaces_modify() {
	echo "Interfaces Modify..."
	cp ${DIR_STATICIP}/template ${DIR_STATICIP}/interfaces
	sed -i -e 's/gateway #address_gateway/gateway '${ROUTER}'/g' ${DIR_STATICIP}/interfaces
	sed -i -e 's/address #address_eth0/address '${ETH0}'/g' ${DIR_STATICIP}/interfaces
	sed -i -e 's/address #address_wlan0/address '${WLAN0}'/g' ${DIR_STATICIP}/interfaces
	sed -i -e 's/wpa-essid #your_ssid/wpa-essid '${SSID}'/g' ${DIR_STATICIP}/interfaces
	sed -i -e 's/wpa-psk #your_wpa_pass/wpa-psk '${WPA_PASS1}'/g' ${DIR_STATICIP}/interfaces
}

function interfaces_update() {
	echo "Interfaces Update..."
	mv ${DIR_STATICIP}/interfaces /etc/network/interfaces
}

function interfaces_result() {
	whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "/etc/network/interfaces" \
		--textbox "/etc/network/interfaces" 34 83 \
		--ok-button "ต่อไป" \
		--scrolltext \
		--clear
}

function interfaces_config() {
	echo "Interfaces Config..."
	router_config
	eth0_config
	wlan0_config
						
	until [ "${ETH0}" != "${WLAN0}" ]; do
		whiptail \
			--backtitle "${TXT_BACKTITLE}" \
			--title "พบข้อผิดพลาด" \
			--msgbox "ระหว่าง eth0 และ wlan0 ต้องเป็นหมายเลขที่ไม่ซ้ำกัน " 8 50 \
			--ok-button "ตั้งค่าใหม่" \
			--clear
					
			eth0_config
			wlan0_config
	done
							
	ssid_config
	wpa_pass1_config
	wpa_pass2_config

	until [ ${WPA_PASS1} == ${WPA_PASS2} ]; do
		whiptail \
			--backtitle "${TXT_BACKTITLE}" \
			--title "พบข้อผิดพลาด" \
			--msgbox "รหัสผ่านต้องตรงกัน" 8 50 \
			--ok-button "ตั้งค่าใหม่" \
			--clear
									
		wpa_pass1_config
		wpa_pass2_config
	done

}

interfaces_backup
interfaces_config
interfaces_modify
interfaces_update
interfaces_result






