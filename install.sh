#!/bin/bash
apt-get update
apt-get install apache2 php libapache2-mod-php php-mcrypt php-mysql git -y
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
apt-get install mysql-server -y
a2enmod ssl
mkdir -p /etc/apache2/ssl
mkdir /git/
git clone https://github.com/stomplee/app01 /git
sh /git/createdb.sh testdb user password
cp /git/apache.key /etc/apache2/ssl/
cp /git/apache.crt /etc/apache2/ssl/
cp /git/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
cp /git/dir.conf /etc/apache2/mods-enabled/dir.conf
cp /git/test.php /var/www/html
cp /git/info.php /var/www/html
chown -R www-data:www-data /etc/apache2
chown -R www-data:www-data /var/www/html
chmod 644 /var/www/html/info.php
chmod 644 /var/www/html/test.php
a2ensite default-ssl.conf
service apache2 restart
