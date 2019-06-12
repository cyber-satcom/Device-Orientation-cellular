#!/bin/bash

# Activate HTTPS
	# Create key dir
	sudo mkdir /etc/apache2/ssl;

	# Generate 100 years certificate
	sudo openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -sha256 -out /etc/apache2/server.crt -keyout /etc/apache2/ssl/server.key;

	# Activate SSL
	sudo a2enmod ssl;
	sudo a2ensite default-ssl;

	# Install certificate
	sudo cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.back;
	cat /etc/apache2/sites-available/default-ssl.conf > ./default-ssl.conf.tmp;
	./infilesreplace -p ./default-ssl.conf.tmp 'SSLCertificateFile.*$' 'SSLCertificateFile /etc/apache2/server.crt';
	./infilesreplace -p ./default-ssl.conf.tmp 'SSLCertificateKeyFile.*$' 'SSLCertificateKeyFile /etc/apache2/ssl/server.key';
	sudo mv ./default-ssl.conf.tmp /etc/apache2/sites-available/default-ssl.conf;
	sudo chown root:root /etc/apache2/sites-available/default-ssl.conf;

	# Restart apache
	sudo service apache2 reload;
