#!/bin/bash

add_user(){
	USERNAME=$1
	if [ id "$USERNAME" &>/dev/null ]; then
		echo "L'utilisateur exite déjà"
		return 1
	fi

	PASSWORD=$(openssl rand -base64 12)

	if sudo useradd -m "$USERNAME"; then
		echo "Utilisateur '$USERNAME' crée avec succès"
		echo "$USERNAME:$PASSWORD" | sudo chpasswd
		echo "Mot de passe : $PASSWORD"
	else
		echo "Erreur lors de la création de l'utilisateur '$USERNAME'"
		return 1
	fi
}

del_user(){
	USENAME=$1
	if [ ! id "$USERNAME" &>/dev/null/ ]; then
		echo "Erreur, l'utilisateur '$USERNAME' n'existe pas"
		return 1
	fi

	if sudo userdel -r "$USERNAME" ; then
		echo "Utilisateur $USERNAME à été supprimé"
	else
		echo "Erreur de suppression de l'utilisateur $USERNAME ."
		return 1
	fi
}

list_users(){
	echo "Liste des utilisateurs système"
	awk -F: '$3 >= 1000 && $1 != "nobody" {print$1}' /etc/passwd | sort
}


while test $# -gt 0; do
	case "$1" in
		-a|--add)
			OPERATION="add"
			shift
			USERNAME="$1"
			;;
		-d|--del)
			OPERATION="del"
			shift
			USERNAME="$1"
			;;
		-l|--list)
			OPERATION="list"
			;;
		*)
			echo "Vous devez utiliser un des arguments suivant:"
			echo "-a | --add : Pour ajouter un utilisateur"
			echo "-d | --del : Pour supprimer un utilisateur"
			echo "-l | --list : Pour lister les utilisateurs"
			exit 1
			;;
	esac
	shift
done
if [ -z "$OPERATION" ]; then 
	echo "Veuillez saisir une opération parmi les arguments suivants:"
	echo "-a | --add : Pour ajouter un utilisateur"
	echo "-d | --del : Pour supprimer un utilisateur"
	echo "-l | --list : Pour lister les utilisateurs"
	exit 1
fi

case "$OPERATION" in
	"add")
		if [ -z "$USERNAME" ]; then
			echo "Veuillez saisir un nom d'utilisateur"
			exit 1
		fi
		add_user "$USERNAME"
		;;
	"del")
		if [ -z "$USERNAME" ]; then
			echo "Veuillez saisir un nom d'utilisateur"
			exit 1
		fi
		del_user "$USERNAME"
		;;
	"list")
		list_users
		;;
	*)
		echo "Erreur, mauvais type d'opération"
		exit 1
esac

exit 0
