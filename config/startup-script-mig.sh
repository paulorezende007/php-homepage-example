#!/bin/bash
#
# Check if the virtual machine is booting for the first time
if [ -f /root/script_already_executed ]
then
  echo "*****************************************************************"
  echo "Execução Cancelada! Este script já foi executado nesta instância."
  echo "*****************************************************************"
  exit 0
else
#
echo "*****************************************************************"
echo "***********************   START SCRIPT    ***********************"
echo "*****************************************************************"
# Environment Variables
PROJECT_ID='migration-factory-375017'
DB_HOST='10.92.234.2'
DB_NAME='app-db'
DB_USER='app-user'
DB_PASSWD=$(gcloud secrets versions access 3 --secret="MYSQL_DB_PASSWD")
COMMIT=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/commit -H "Metadata-Flavor: Google")
#
# Application and Dependences Installation
apt-get update -y
apt-get install apache2 php8.1 libapache2-mod-php php-mysql mysql-client -y
#
# Alterando config do Apache
sed -i "s/MaxKeepAliveRequests 100/MaxKeepAliveRequests 500/g" /etc/apache2/apache2.conf
#
# Deploy WebSite by Git
cd /var/www/html
echo "healthy" > healthy.html
gcloud source repos clone github_paulorezende007_php-homepage-example --project=${PROJECT_ID}
cd github_paulorezende007_php-homepage-example/
git checkout $COMMIT
cd /var/www/html
mv github_paulorezende007_php-homepage-example/* .
rm -rf github_paulorezende007_php-homepage-example index.html
sed -i "s/DB_HOST/${DB_HOST}/g; s/DB_NAME/${DB_NAME}/g; s/DB_USER/${DB_USER}/g; s/DB_PASSWD/${DB_PASSWD}/g" includes/mysql.php
systemctl restart apache2
#
# Install Agente de Monitoramento
# curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
# bash add-google-cloud-ops-agent-repo.sh --also-install
#
# Mark that the script has run before
touch /root/script_already_executed
#
echo "*****************************************************************"
echo "************************   END SCRIPT    ************************"
echo "*****************************************************************"
exit 0
fi