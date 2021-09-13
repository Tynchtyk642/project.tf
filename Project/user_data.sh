#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install apache2
sudo apt-get -y install curl
myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
echo "<h2>Terraform WebServer with IP: $myip</h2><br>Build by Terraform" > /var/www/html/index.html
echo "<br><font color="blue">Hello world!!" >> /var/www/html/index.html
sudo service apache2 start
sudo systemctl enable apache2