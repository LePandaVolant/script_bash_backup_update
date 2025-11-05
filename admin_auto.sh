#!/bin/bash
TITRE="Options"


function Afficher_menu
{
echo "========$TITRE========="
echo "1: Mise a jour du système"
echo "2: Archivage des logs"
echo "3: Diagnostique Réseau"
echo "4: Tous"
echo "q: Quitter"

read -p "Choisissez une option " CHOIX

case $CHOIX in

	1)
		sudo ./update_system.sh
		Afficher_menu
		;;
	2)
		sudo ./backup_logs.sh
		Afficher_menu
		;;
	3)
		sudo ./network_diag.sh
		Afficher_menu
		;;
	4)
		sudo ./update_system.sh
		sudo ./backup_logs.sh
		sudo ./network_diag.sh
		Afficher_menu
		;;
	*)
		exit 0
		;;
esac
}

Afficher_menu
