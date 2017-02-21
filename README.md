# Installation Guide

Create an EC2 instance using ami-6edd3078 (Ubuntu 16.04 LTS x64) and enter the following in the bootstrap script section upon instance launch:

```bash
#!/bin/bash
apt-get update
apt-get install apache2 php libapache2-mod-php php-mcrypt php-mysql wget tar curl -y 
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
apt-get install mysql-server -y 
wget http://sourceforge.net/projects/vtigercrm/files/vtiger%20CRM%206.5.0/Core%20Product/vtigercrm6.5.0.tar.gz
tar -xvzf vtigercrm6.5.0.tar.gz
cp -r vtigercrm/* /var/www/html/
rm -f vtigercrm6.5.0.tar.gz
rm -rf vtigercrm
a2enmod ssl
mkdir /etc/apache2/ssl
mkdir /git
git clone https://github.com/stomplee/app01 /git/app01
chmod +X /git/app01/createdb.sh
/git/app01/createdb.sh test user password
cp /git/app01/apache.key /etc/apache2/ssl/
cp /git/app01/apache.crt /etc/apache2/ssl/
cp /git/app01/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
cp /git/app01/dir.conf /etc/apache2/mods-enabled/dir.conf
chown -R www-data:www-data /etc/apache2
chown -R www-data:www-data /var/www/html
a2ensite default-ssl.conf
service apache2 restart
```
