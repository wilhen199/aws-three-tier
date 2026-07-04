#!/bin/bash
dnf update -y
dnf install -y nginx
systemctl start nginx
systemctl enable nginx

# Test Website
echo "<h1> Nginx Server  $(hostname -f) </h1>" > /var/www/html/index.html
echo "<h2> Deployed via Terraform </h2>" >> /var/www/html/index.html