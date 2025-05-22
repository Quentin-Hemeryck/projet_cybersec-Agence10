#!/bin/bash
# Auteur : Lubanguku Esdras

set -eo pipefail

# Variables

IP="172.29.250.40"
HOSTNAME="ag10.heh.be"
LINE="$IP $HOSTNAME"
HOSTS_FILE="/etc/hosts"


# Installation de httpd
echo "❗ Installation du service httpd ❗"
dnf install -y  httpd lynx --quiet
systemctl enable httpd

echo "\nInstallation du service httpd terminé ✅"


# Règle de firewall
iptables -F
echo "\nRègles de pare-feu vidée ✅"

# Création du fichier de configuration du DMZ
echo "\nCréation du fichier de configuration du DMZ 🔄️"

touch /etc/httpd/conf.d/dmz.conf
tee /etc/httpd/conf.d/dmz.conf << EOF
<VirtualHost *:80>
        ServerAdmin ag10@heh.be
        DocumentRoot /var/www/dmz/html
        ServerName 172.29.250.40
</VirtualHost>
<Directory "/var/www/dmz/html">
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
        DirectoryIndex index.html
        ErrorDocument 404 /error/404.html
        ErrorDocument 500 /error/500.html
</Directory>
EOF

echo "\nModification de fichier de configuration DMZ terminée ✅"


chown apache:apache /etc/httpd/conf.d/dmz.conf

mkdir -p /var/www/dmz
mkdir -p /var/www/dmz/html
mkdir -p /var/www/dmz/html/error
touch /var/www/dmz/html/index.html
touch /var/www/dmz/html/style.css
touch /var/www/dmz/html/error/404.html
touch /var/www/dmz/html/error/500.html


tee /var/www/dmz/html/index.html << EOF1
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Agence 10 - DMZ</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <div class="container">
    <h1>Bienvenue dans la DMZ de l'Agence 10</h1>
    <p>Vous êtes actuellement dans une zone sécurisée accessible depuis l’extérieur.</p>
    <p>Merci de respecter les protocoles en vigueur.</p>
  </div>
</body>
</html>
EOF1

tee /var/www/dmz/html/style.css << EOF2
/* Style de base */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background: linear-gradient(to right, #2c3e50, #3498db);
  color: white;
  margin: 0;
  padding: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

/* Conteneur */
.container {
  background-color: rgba(0, 0, 0, 0.4);
  padding: 40px;
  border-radius: 20px;
  box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
  text-align: center;
  max-width: 600px;
}

/* Titres */
h1 {
  font-size: 2.5em;
  margin-bottom: 20px;
}

/* Texte */
p {
  font-size: 1.2em;
  line-height: 1.5;
}
EOF2

tee /var/www/dmz/html/error/404.html << EOF3
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Erreur 404 - Page non trouvée</title>
  <link rel="stylesheet" href="../style.css">
</head>
<body>
  <div class="container">
    <h1>Erreur 404</h1>
    <p>La page que vous cherchez n'existe pas.</p>
    <p>Veuillez vérifier l'URL ou revenir à la page d’accueil.</p>
  </div>
</body>
</html>

EOF3

tee /var/www/dmz/html/error/500.html << EOF4
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Erreur 500 - Problème interne</title>
  <link rel="stylesheet" href="../style.css">
</head>
<body>
  <div class="container">
    <h1>Erreur 500</h1>
    <p>Une erreur interne est survenue sur le serveur.</p>
    <p>Nos équipes ont été notifiées. Veuillez réessayer plus tard.</p>
  </div>
</body>
</html>

EOF4

echo "\nCréation des fichiers et dossiers du DMZ terminée ✅"

echo "\nVérification de la présence du server web dans le fichier hôtes ⚠️"
if ! grep -qF "$LINE" "$HOSTS_FILE"; then
    echo "Ajout de la ligne dans /etc/hosts ❗"
    echo "$LINE" | sudo tee -a "$HOSTS_FILE" > /dev/null
else
    echo "La ligne existe déjà dans /etc/hosts ⚠️"
fi


echo "\nRedémarrage du service httpd 🔄️"
systemctl restart httpd

echo "\n Time sleep de 2 secondes ❗"
sleep 2


echo "\nTest de la configuration avec apachectl 🌿"
apachectl configtest