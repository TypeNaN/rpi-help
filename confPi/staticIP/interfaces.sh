#!/bin/bash
###############################################################################
# Purpose: Config static IP
# Author: Chaimongkol Mangklathon
# version : 3.1
# Licenses : GNU GPL v2.0
# Updated : 17/10/2557
###############################################################################

if [ ! ${DIR}  ]; then
	exit 1
fi

if [ ${LANG} == 'th_TH.UTF-8' ]; then
	source ${DIR_STATICIP}/lang.th
else
	source ${DIR_STATICIP}/lang.en
fi

function interfaces_exit() {
	case ${RES} in
		1) confPi_main ;;
		255) confPi_main
	esac
}

function router_config() {
	ROUTER=$(whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_INROU_TITLE}" \
		--ok-button "${TXT_INROU_OK}" \
		--cancel-button "${TXT_INROU_CANCEL}" \
		--inputbox "${TXT_INROU_INBOX}" 8 40 "${TXT_INROU_INBOX_DEF}" 3>&1 1>&2 2>&3)
	RES=$?
	interfaces_exit ${RES}
}

function eth0_config() {
	ETH0=$(whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_INETH0_TITLE}" \
		--inputbox "${TXT_INETH0_INBOX}" 10 40 "${TXT_INETH0_INBOX_DEF}" 3>&1 1>&2 2>&3)
	RES=$?
	interfaces_exit ${RES}
}

function wlan0_config() {
	WLAN0=$(whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_INWLAN0_TITLE}" \
		--inputbox "${TXT_INWLAN0_INBOX}" 10 40 "${TXT_INWLAN0_INBOX_DEF}" 3>&1 1>&2 2>&3)
	RES=$?
	interfaces_exit ${RES}
}

function ssid_config() {
	SSID=$(whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_INSSID_TITLE}" \
		--inputbox "${TXT_INSSID_INBOX}" 10 40 "${TXT_INSSID_INBOX_DEF}" 3>&1 1>&2 2>&3)
	RES=$?
	interfaces_exit ${RES}
}

function wpa1_config() {
	WPA1=$(whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_INWPA1_TITLE}" \
		--inputbox "${TXT_INWPA1_INBOX}" 10 40 "${TXT_INWPA1_INBOX_DEF}" 3>&1 1>&2 2>&3)
	RES=$?
	interfaces_exit ${RES}
}

function wpa2_config() {
	WPA2=$(whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_INWPA2_TITLE}" \
		--inputbox "${TXT_INWPA2_INBOX}" 10 40 "${TXT_INWPA2_INBOX_DEF}" 3>&1 1>&2 2>&3)
	RES=$?
	interfaces_exit ${RES}
}

function interfaces_config() {
	echo ${TXT_INCNF_MSG}
	router_config
	eth0_config
	wlan0_config

	until [ "${ETH0}" != "${WLAN0}" ]; do
		whiptail \
			--backtitle "${TXT_BACKTITLE}" \
			--title "${TXT_INCNF_ETH_WLAN_ERR_TITLE}" \
			--msgbox "${TXT_INCNF_ETH_WLAN_ERR_MSG}" 8 50 \
			--ok-button "${TXT_INCNF_ETH_WLAN_ERR_OK}" \
			--clear
		eth0_config
		wlan0_config
	done

	ssid_config
	wpa1_config
	wpa2_config

	until [ ${WPA1} == ${WPA2} ]; do
		whiptail \
			--backtitle "${TXT_BACKTITLE}" \
			--title "${TXT_INCNF_WPAPWD1_ERR_TITLE}" \
			--msgbox "${TXT_INCNF_WPAPWD1_ERR_MSG}" 8 50 \
			--ok-button "${TXT_INCNF_WPAPWD1_ERR_OK}" \
			--clear

		wpa1_config
		wpa2_config
	done

}

function interfaces_backup() {
	echo ${TXT_INBCKUP_MSG1}
	if [ -f ${DIR_BACKUP}/etc/network/interfaces ]; then
		echo ${TXT_INBCKUP_F_MSG}
	else
		echo ${TXT_INBCKUP_NF_MSG}
		mkdir -p ${DIR_BACKUP}/etc/network
		cp /etc/network/interfaces ${DIR_BACKUP}/etc/network/interfaces
		if [ -f ${DIR_BACKUP}/etc/network/interfaces ]; then
			echo ${TXT_INBCKUP_MSG2}
		else
			echo ${TXT_INBCKUP_MSG3}
			exit 1
		fi
	fi
}

function interfaces_modify() {
	echo ${TXT_INMOD_MSG}
	cp ${DIR_STATICIP}/template ${DIR_STATICIP}/interfaces
	sed -i -e 's/gateway #address_gateway/gateway '${ROUTER}'/g' ${DIR_STATICIP}/interfaces
	sed -i -e 's/address #address_eth0/address '${ETH0}'/g' ${DIR_STATICIP}/interfaces
	sed -i -e 's/address #address_wlan0/address '${WLAN0}'/g' ${DIR_STATICIP}/interfaces
	sed -i -e 's/wpa-essid #your_ssid/wpa-essid '${SSID}'/g' ${DIR_STATICIP}/interfaces
	sed -i -e 's/wpa-psk #your_wpa_pass/wpa-psk '${WPA1}'/g' ${DIR_STATICIP}/interfaces
}

function interfaces_update() {
	echo ${TXT_INUPD_MSG}
	mv ${DIR_STATICIP}/interfaces /etc/network/interfaces
}

function interfaces_result() {
	whiptail \
		--backtitle "${TXT_BACKTITLE}" \
		--title "${TXT_INRLT_TITLE}" \
		--textbox "${TXT_INRLT_TEXTBOX}" 34 83 \
		--ok-button "${TXT_INRLT_OK}" \
		--scrolltext \
		--clear
}

interfaces_config
interfaces_backup
interfaces_modify
interfaces_update
interfaces_result
