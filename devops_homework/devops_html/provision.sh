#!/bin/bash

# Install required packages
echo "Updating and upgrading packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Nginx
echo "Installing Nginx..."
sudo apt-get install -y nginx
sudo systemctl enable nginx

# Check Nginx version
nginx -v || { echo "Nginx is not installed"; exit 1; }

# Start Nginx
sudo systemctl start nginx

# Sử dụng cấu hình mặc định của Nginx
echo "Using default Nginx configuration..."
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# Check config Nginx
echo "Testing Nginx configuration..."
sudo nginx -t || { echo "Nginx is not configured correctly"; exit 1; }

# Restart Nginx
echo "Restarting Nginx..."
sudo systemctl restart nginx
echo "Vagrant provisioning complete!"