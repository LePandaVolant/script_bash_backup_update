#!/bin/bash

DATE=$(date '+%Y-%m-%d %H:%M:%S')
OUTPUT=$(sudo apt update > /tmp/update.log 2> /tmp/update_error.log)
RETURN_CODE=$(echo $?)

> /tmp/update_tmp.log
> /tmp/update_error_tmp.log
TMP_FILE="/tmp/update_tmp.log"
ERROR_TMP="/tmp/update_error_tmp.log"

echo "UPDATE" | tee -a "$TMP_FILE"
grep "à jour" /tmp/update.log |tee -a "$TMP_FILE"
grep "ERROR" /tmp/update_error.log | tee -a "$ERROR_TMP"

if [ $RETURN_CODE != 0 ]; then
	echo "Erreur dans la commande apt update" | tee -a "$ERROR_TMP"
fi

OUTPUT=$(sudo apt upgrade -y >> /tmp/update.log 2>> /tmp/update_error.log)
RETURN_CODE=$(echo $?)

echo ""
echo "UPGRADE :" | tee -a "$TMP_FILE"
grep "Installation" /tmp/update.log| tee -a "$TMP_FILE"
grep "ERROR" /tmp/update_error.log| tee -a "$ERROR_TMP"

if [ $RETURN_CODE != 0 ]; then
	echo "Erreur dans la commande apt upgrade" | tee -a "$ERROR_TMP"
fi

OUTPUT=$(sudo apt autoremove -y  >> /tmp/update.log 2>> /tmp/update_error.log)
RETURN_CODE=$(echo $?)

echo ""
echo "AUTOREMOVE :" | tee -a "$TMP_FILE"
grep "Installation" /tmp/update.log| tee -a "$TMP_FILE"
grep "ERROR" /tmp/update_error.log| tee -a "$ERROR_TMP"

if [ $RETURN_CODE != 0 ]; then
	echo "Erreur dans la commande apt autoremove" | tee -a "$ERROR_TMP"
fi

sudo sed "s/^/$DATE /" "/tmp/update.log" > "/tmp/update.log.tmp" && mv "/tmp/update.log.tmp" "/tmp/update.log"
sudo sed "s/^/$DATE /" "/tmp/update_error.log" > "/tmp/update_error.log.tmp" && mv "/tmp/update_error.log.tmp" "/tmp/update_error.log"

DATE=$(date "+%Y-%m-%d %H:%M:%S")

sudo sed "s/^/$DATE /" "$TMP_FILE" > "$TMP_FILE.tmp" && mv "$TMP_FILE.tmp" "$TMP_FILE"
sudo sed "s/^/$DATE /" "$ERROR_TMP" > "$ERROR_TMP.tmp" && mv "$ERROR_TMP.tmp" "$ERROR_TMP"
cat "$TMP_FILE" >> /tmp/update.log
cat "$ERROR_TMP" >> /tmp/update_error.log
sudo rm -f "$TMP_FILE"
sudo rm -f "$ERROR_TMP"
