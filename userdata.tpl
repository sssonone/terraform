#!/bin/bash
# Use this for your user data script execution
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Welcome to Webpage on EC2 instance Created using Terraform thanku vishal</h1>" > /var/www/html/index.html