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

# Permission for web directory
echo "Setting permissions for web directory..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Start Nginx
sudo systemctl start nginx

# Configure Nginx site
echo "Configuring Nginx site..."
cat <<EOL > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

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