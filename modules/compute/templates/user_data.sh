#!/bin/bash
dnf update -y
dnf install -y nginx
systemctl start nginx
systemctl enable nginx

# Test Website
echo "<h1> Nginx Server - Deployed on  $(hostname -f) </h1>" > /usr/share/nginx/html/index.html
echo "<h2> Deployed via Terraform </h2>" >> /usr/share/nginx/html/index.html