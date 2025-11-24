Fichiers nécessaires :

- update.system.sh
- backup_logs.sh
- network_diag.sh
- admin_auto.sh
- config.cfg
- user_manager.sh

Les scripts peuvent être exécutés séparément mais "admin_auto.sh" permet de les exécuter (sauf "user_manager.sh") depuis un menu.

Le fichier "config.cfg" est modifiable à condition de respecter la mise en forme originale.

Pour exécuter les scripts il est conseillé d'utiliser "sudo" ou d'être l'utilisateur "root"

Utilisation 
- update.system.sh    :    Met à jours les paquets du système et retourne les erreurs
- backup_logs.sh      :    Fait une backup des logs présent dans /var/logs
- network_diag.sh     :    Analyse réseau
- admin_auto.sh       :    Permet l'execution des autres scripts
- config.cfg          :    Dossier de configuration des scripts
- user_manager.sh     :    Permet une gestion de la création et suppression des utilisateurs
