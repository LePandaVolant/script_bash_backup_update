#!/bin/bash

if [ ! -f "./config.cfg" ]; then
	echo "Pas de fichier config.cfg"
	echo "Création d'un fichier config.cfg"
	echo "BACKUP_DEFAULT_DIR=/backup/logs" > "./config.cfg"
fi

CONFIG="./config.cfg"
source "$CONFIG"
BAD_FILES="${FILES_TO_IGNORE[@]}"

if [ -n "$1" ]; then
	BACKUP_DIR="$1"
else
	BACKUP_DIR="$BACKUP_DEFAULT_DIR"
fi

BACKUP_DIR=${BACKUP_DIR%/}
echo "$BACKUP_DIR"

DATE=$(date +%Y%m%d)
NAME="logs_$DATE.tar.gz"
FREE_SPACE=$(df -BM |grep -oP "/dev/sda.*M" | grep -oP "[\d]*M$"|grep -oP "[\d]*")
ARRAY=()

if [ $FREE_SPACE -lt 1000 ]; then
	echo "Espace disque insuffisant"
	exit 1
fi

sudo mkdir -p "$BACKUP_DIR"

for f in $(find /var/log/ -type f -exec printf '%s\n' '{}' +);
do
	echo "$f"
	FILE_TYPE=$(file $f | awk '{print$2}')
	echo "$FILE_TYPE"
	IGNORE_FILE=0

	for type in $BAD_FILES;
	do
		if [ $FILE_TYPE = $type ]; then
			echo "mauvais type de fichier"
			IGNORE_FILE=1
			break
		fi
	done
	if [ $IGNORE_FILE = 0 ]; then
		ARRAY+=("$f")
		echo "fichier ajouté"
	fi
done

sudo tar -czpvf $BACKUP_DIR/$NAME ${ARRAY[@]} 2>/tmp/backup_tar_err.log  > /tmp/backup_tar.log
echo -e "\nListe des logs archivés :\n"
for log in ${ARRAY[@]};
do
	echo "- $log"
done
echo -e "\nTaille de l'archive (o) :"
gzip -l $BACKUP_DIR/$NAME | awk 'NR > 1 {print$1}'
echo -e "\nRatio de compréssion :"
gzip -l $BACKUP_DIR/$NAME | awk 'NR > 1 {print$3}'

echo -e "\nEmplacement des backups : $BACKUP_DIR"
find $BACKUP_DIR/* -mtime 7 -delete
DELETE_CODE=$(echo "$?")
if [ $DELETE_CODE != 0 ]; then
	echo "Erreur lors de la suppression des anciens logs"
fi
