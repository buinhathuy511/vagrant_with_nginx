#!/bin/bash

echo "Update system..."
sudo apt-get update -y && sudo apt-get upgrade -y

echo "Install Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Install Nginx..."
sudo apt-get install -y nginx

echo "Start Node.js app..."
cd /home/vagrant/app
nohup node server.js > /home/vagrant/app/log.txt 2>&1 &

echo "Configure Nginx to proxy to Node.js..."
sudo bash -c 'cat > /etc/nginx/sites-available/default' << "EOF"
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

echo "Check Nginx configuration..."
sudo nginx -t || { echo "Nginx config error"; exit 1; }

echo "Restart Nginx..."
sudo systemctl enable nginx
sudo systemctl restart nginx

echo "Provisioning complete!"