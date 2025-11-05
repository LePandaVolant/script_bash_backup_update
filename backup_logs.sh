#!/bin/bash

DATE=$(date +%Y%m%d)
NAME="logs_$DATE.tar.gz"
FREE_SPACE=$(df -h |grep -oP "/dev/sda.*G" | grep -oP "[\d]*G$"|grep -oP "[\d]*")
ARRAY=()
if [ $FREE_SPACE -lt 1 ]; then
	echo "Espace disque insuffisant"
	exit 1
fi

sudo mkdir -p /backup/logs/

for f in $(find /var/log/ -type f -exec printf '%s\n' '{}' +);
do
	echo "$f"
	FILE_TYPE=$(file $f | awk '{print$2}')
	echo "$FILE_TYPE"
	if [ $FILE_TYPE = "gzip" ]; then
		echo "mauvais type de fichier"
	elif [ $FILE_TYPE = "symbolic" ]; then
		echo "mauvais type de fichier"
	else
		ARRAY+=("$f")
		echo "fichier ajouté"
	fi
done

sudo tar -czpvf /backup/logs/$NAME ${ARRAY[@]}
echo -e "\nListe des logs archivés :\n${ARRAY[@]}"
echo -e "\nTaille de l'archive (o) :"
gzip -l /backup/logs/$NAME | awk 'NR > 1 {print$1}'
echo -e "\nRatio de compréssion :"
gzip -l /backup/logs/$NAME | awk 'NR > 1 {print$3}'

find /backup/logs/* -mtime 7 -delete
DELETE_CODE=$(echo "$?")
if [ $DELETE_CODE != 0 ]; then
	echo "Erreur lors de la suppression des anciens logs"
fi
