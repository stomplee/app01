#!/bin/bash
  
EXPECTED_ARGS=3
E_BADARGS=65
MYSQL=`which mysql`
  
Q1="CREATE DATABASE IF NOT EXISTS $1;"
Q2="GRANT USAGE ON *.* TO $2@localhost IDENTIFIED BY '$3';"
Q3="GRANT ALL PRIVILEGES ON $1.* TO $2@localhost;"
Q4="FLUSH PRIVILEGES;"
Q5="USE $1;"
Q6="CREATE TABLE IF NOT EXISTS contacts( name VARCHAR(50), email VARCHAR(50) );"
Q7="INSERT INTO contacts VALUES('John Smith', 'johnsmith@anywhere.com');"
Q8="INSERT INTO contacts VALUES('Jane Doe', 'janedoe@anywhere.com');"
SQL="${Q1}${Q2}${Q3}${Q4}${Q5}${Q6}${Q7}${Q8}"
  
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 dbname dbuser dbpass"
  exit $E_BADARGS
fi
  
$MYSQL -uroot -ppassword -e "$SQL"
