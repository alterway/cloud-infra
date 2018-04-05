#! /bin/bash

## Mise à jour du système
sudo apt-get update

## Prérequis systeme
sudo apt-get install apache2 -y
sudo apt-get install libapache2-mod-php mysql-client php php-mysql -y
sudo apt-get install nfs-common -y

## Installation de wordpress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -zxvf ./latest.tar.gz
sudo mv wordpress /var/www/html
sudo service apache2 restart