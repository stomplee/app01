# Installation Guide

1. Create security group as per earlier documentation
2. Create an EC2 instance using ami-6edd3078 (Ubuntu 16.04 LTS x64) in the first AZ and enter the following in the Advanced section upon instance launch:

```bash
#!/bin/bash
apt-get update
apt-get install apache2 php libapache2-mod-php php-mcrypt php-mysql git -y
echo "mysql-server mysql-server/root_password password password" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password password" | debconf-set-selections
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
```
3. Create another EC2 instance using the same AMI as in step 2 and assign it to the second AZ and enter in the same bash script in the Advanced section upon launcha

Tested this and it works.  It does take up to 5 minutes after the instance has been provisioned for the post-deployment script to run and allow https access

Now to create an ELB..
classic one
for now will just try http
called it test-elb
verified that it worked just fine by tailing logs.

now to make ssl work on the load balancer

added new cert and used the into in apache.key and apache.crt, let's see if this works..

didn't work right away, played with some health check settings, still saying out of service

shit no wonder, i had it set to try https port 80 *facepalm*

changed it to https:443/index.html

ahh there we go

still doesn't work though, but it doesn;t look like a load balancer issue

looks like i need to set apache to do a http to https redirect

ahh, nope, just had the elb instance protocol set to http and not https

fuck yeah that worked!  i now have a multi-az load balanced setup with the db.  it's not the same db (though maybe could try that one too via RDS for extra points later

