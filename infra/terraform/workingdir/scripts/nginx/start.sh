#!/bin/bash

# Update the package list and install NGINX
yum update -y
amazon-linux-extras install nginx1 -y

# Enable and start NGINX service
systemctl enable nginx
systemctl start nginx

# Update permissions of NGINX public folder
chmod 2775 /usr/share/nginx/html
find /usr/share/nginx/html -type d -exec chmod 2775 {} \;
find /usr/share/nginx/html -type f -exec chmod 0664 {} \;

# Fetch the instance's private IP using the EC2 Metadata API
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

# Create a simple HTML file that prints the private IP
echo "<html>
<head>
    <title>EC2 Instance Private IP</title>
</head>
<body>
    <h1>$PRIVATE_IP</h1>
</body>
</html>" | tee /usr/share/nginx/html/index.html

# Restart NGINX to apply the changes
systemctl restart nginx
