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
DB_HOST='localhost'
DB_NAME='app-db'
DB_USER='app-user'
DB_PASSWD=$(gcloud secrets versions access 3 --secret="MYSQL_DB_PASSWD")
#
# Application and Dependences Installation
apt-get update -y
apt-get install apache2 php8.1 libapache2-mod-php php-mysql mysql-server mysql-client -y
#
# Create DB
echo "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWD';" > user.sql
echo "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION;" >> user.sql
echo "CREATE DATABASE" '`'"$DB_NAME"'`'";" >> user.sql
mysql -u root < user.sql
gsutil cp gs://bucket-dgc-arquitetura-tradicional/database.sql .
mysql -u root $DB_NAME < database.sql
rm -f *.sql
#
# Deploy WebSite by Git
cd /var/www/html
echo "healthy" > healthy.html
gcloud source repos clone github_paulorezende007_php-homepage-example --project=${PROJECT_ID}
mv github_paulorezende007_php-homepage-example/* .
rm -rf github_paulorezende007_php-homepage-example index.html
sed -i "s/DB_HOST/${DB_HOST}/g; s/DB_NAME/${DB_NAME}/g; s/DB_USER/${DB_USER}/g; s/DB_PASSWD/${DB_PASSWD}/g" includes/mysql.php
systemctl restart apache2
#
# Mark that the script has run before
touch /root/script_already_executed
#
echo "*****************************************************************"
echo "************************   END SCRIPT    ************************"
echo "*****************************************************************"
exit 0
fi