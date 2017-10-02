#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PROJECTFOLDER='app'

# create project folder
#sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# update / upgrade
#sudo apt-get update
sudo apt-get install -y apache2

sudo mkdir "/var/www/html/${PROJECTFOLDER}"
# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf


# restart apache
sudo service apache2 restart

sudo a2enmod ssl
## Setup SSL 

country=IN
state=MH
locality=MU
organization=mylab
organizationalunit=IT
commonname=mylabtest
email=administrator@localhost

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/mylab.key -out /etc/ssl/certs/mylab.crt \
  -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"


sudo sed -i 's/private/certs/g'   /etc/apache2/sites-available/default-ssl.conf
sudo sed -i 's/\/private/ssl-cert-snakeoil.key/mylab.key/g'  /etc/apache2/sites-available/default-ssl.conf
sudo sed -i 's/ssl-cert-snakeoil.pem/mylab.crt/g'  /etc/apache2/sites-available/default-ssl.conf

sudo service apache2 restart

## Install memcached 
sudo apt-get -y install memcached
sudo systemctl restart memcached
