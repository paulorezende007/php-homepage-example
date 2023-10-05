sudo apt-get update
sudo apt-get install apache2
sudo apt-get install mysql-server
sudo apt-get install php8.1 libapache2-mod-php php-mysql
sudo systemctl restart apache2





sudo nano /etc/apache2/sites-available/000-default.conf

ServerName your_domain_name
ServerAlias www.your_domain_name
DocumentRoot /var/www/html


MY_INSTANCE_NAME='my-app-instance'
ZONE=us-central1-a

gcloud compute instances create $MY_INSTANCE_NAME \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --machine-type=g1-small \
    --scopes userinfo-email,cloud-platform \
    --metadata-from-file startup-script=scripts/startup-script.sh \
    --zone $ZONE \
    --tags http-server

gcloud compute instances get-serial-port-output my-app-instance --zone us-central1-a


MY_INSTANCE_NAME='my-app-instance2'
ZONE=us-central1-a

gcloud compute instances create $MY_INSTANCE_NAME \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --machine-type=g1-small \
    --scopes userinfo-email,cloud-platform \
    --zone $ZONE \
    --tags http-server


set -e
export HOME=/root

# Install PHP and dependencies from apt
apt-get update
apt-get install -y git nginx php8.1 php8.1-fpm php8.1-mysql php8.1-dev \
    php8.1-mbstring php8.1-zip php-pear pkg-config

# Install Composer
curl -sS https://getcomposer.org/installer | \
    /usr/bin/php -- \
    --install-dir=/usr/local/bin \
    --filename=composer

# Get the application source code
git clone https://github.com/googlecloudplatform/getting-started-php /opt/src
ln -s /opt/src/gce /opt/app

# Run Composer
composer install -d /opt/app --no-ansi --no-progress --no-dev

# Disable the default NGINX configuration
rm /etc/nginx/sites-enabled/default

# Enable our NGINX configuration
cp /opt/app/config/nginx/helloworld.conf /etc/nginx/sites-available/helloworld.conf
ln -s /etc/nginx/sites-available/helloworld.conf /etc/nginx/sites-enabled/helloworld.conf
cp /opt/app/config/nginx/fastcgi_params /etc/nginx/fastcgi_params

# Start NGINX
systemctl restart nginx.service

# Install Fluentd
curl -s "https://storage.googleapis.com/signals-agents/logging/google-fluentd-install.sh" | bash

# Enable our Fluentd configuration
cp /opt/app/config/fluentd/helloworld.conf /etc/google-fluentd/config.d/helloworld.conf

# Start Fluentd
service google-fluentd restart &







apt-get update
apt-get install -y git nginx php8.1 php8.1-fpm php8.1-mysql php8.1-dev \
    php8.1-mbstring php8.1-zip php-pear pkg-config


apt-get update
apt-get install -y nginx php8.1 php8.1-fpm php8.1-mysql php8.1-dev \
    php8.1-mbstring php8.1-zip




curl "http://metadata.google.internal/computeMetadata/v1/instance/image" -H "Metadata-Flavor: Google"







CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` smallint(5) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `products` ADD PRIMARY KEY (`id`);

ALTER TABLE `products` MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `client` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `orders` ADD PRIMARY KEY (`id`);

ALTER TABLE `orders` MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

CREATE TABLE `order_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `order_products` ADD PRIMARY KEY (`id`);

ALTER TABLE `order_products` MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

INSERT INTO products (name, price) VALUES ('toothpaste', 5);
INSERT INTO products (name, price) VALUES ('icecream', 10);
INSERT INTO products (name, price) VALUES ('milk', 8);




#!/bin/bash
apt-get update -y
apt-get install apache2 php8.1 libapache2-mod-php php-mysql -y
cd /var/www/html
echo "healthy" > healthy.html
gcloud source repos clone github_paulorezende007_php-homepage-example --project=migration-factory-375017
mv github_paulorezende007_php-homepage-example/* .
rm -rf github_paulorezende007_php-homepage-example index.html
systemctl restart apache2


#!/bin/bash
apt-get update -y
apt-get install apache2 php8.1 libapache2-mod-php php-mysql -y
cd /var/www/html
echo "healthy" > healthy.html
gcloud source repos clone github_paulorezende007_php-homepage-example --project=migration-factory-375017
mv github_paulorezende007_php-homepage-example/* .
rm -rf github_paulorezende007_php-homepage-example index.html
MYSQL_DB_PASSWD=$(gcloud secrets versions access 2 --secret="MYSQL_DB_PASSWD")
echo $MYSQL_DB_PASSWD
sed -i "s/DB_PASSWD/${MYSQL_DB_PASSWD}/g" includes/mysql.php
cat includes/mysql.php
systemctl restart apache2


#!/bin/bash
#
#Environment Variables
PROJECT_ID='migration-factory-375017'
DB_HOST='10.35.35.3'
DB_NAME='website-db'
DB_USER='root'
DB_PASSWD=$(gcloud secrets versions access 2 --secret="MYSQL_DB_PASSWD")
#Application and Dependences Installation
apt-get update -y
apt-get install apache2 php8.1 libapache2-mod-php php-mysql -y
#Deploy WebSite by Git
cd /var/www/html
echo "healthy" > healthy.html
gcloud source repos clone github_paulorezende007_php-homepage-example --project=${PROJECT_ID}
mv github_paulorezende007_php-homepage-example/* .
rm -rf github_paulorezende007_php-homepage-example index.html
sed -i "s/DB_HOST/${DB_HOST}/g; s/DB_NAME/${DB_NAME}/g; s/DB_USER/${DB_USER}/g; s/DB_PASSWD/${DB_PASSWD}/g" includes/mysql.php
systemctl restart apache2


#!/bin/bash
#
# Check if the virtual machine is booting for the first time
if [ -f /root/script_already_executed ]
then
  echo "*****************************************************************"
  echo "Execução Cancelada! Este script já foi executado nesta instãncia."
  echo "*****************************************************************"
  exit 0
else
#
echo "*****************************************************************"
echo "***********************   START SCRIPT    ***********************"
echo "*****************************************************************"
# Environment Variables
PROJECT_ID='migration-factory-375017'
DB_HOST='10.35.35.3'
DB_NAME='website-db'
DB_USER='root'
DB_PASSWD=$(gcloud secrets versions access 2 --secret="MYSQL_DB_PASSWD")
#
# Application and Dependences Installation
apt-get update -y
apt-get install apache2 php8.1 libapache2-mod-php php-mysql -y
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