# Installation Guide

1. Create security group as per earlier documentation
2. Create an EC2 instance using ami-6edd3078 (Ubuntu 16.04 LTS x64) in the first AZ and enter the following in the Advanced section upon instance launch:

```bash
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
chown -R www-data:www-data /etc/apache2
chown -R www-data:www-data /var/www/html
a2ensite default-ssl.conf
service apache2 restart
```

3. Create another EC2 instance using the same AMI as in step 2 and assign it to the second AZ and enter in the same bash script in the Advanced section upon launcha

Tested this and it works.  It does take up to 5 minutes after the instance has been provisioned for the post-deployment script to run and allow https access
