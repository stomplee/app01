#!/bin/bash
apt-get update
apt-get install apache2 php libapache2-mod-php php-mcrypt php-mysql wget tar -y
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
apt-get install mysql-server -y
a2enmod ssl
mkdir -p /etc/apache2/ssl
sh ~/app01/createdb.sh testdb user password
cp ~/app01/apache.key /etc/apache2/ssl/
cp ~/app01/apache.crt /etc/apache2/ssl/
cp ~/app01/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
cp ~/app01/dir.conf /etc/apache2/mods-enabled/dir.conf
chown -R www-data:www-data /etc/apache2
chown -R www-data:www-data /var/www/html
a2ensite default-ssl.conf
service apache2 restart
