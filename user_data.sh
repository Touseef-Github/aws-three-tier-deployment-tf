#!/bin/bash

# Update package list
sudo yum update -y

# Install Nginx
sudo yum install -y nginx

# Start Nginx service
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Create a sample HTML file for the frontend application
cat <<EOF | sudo tee /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Sample Frontend Application</title>
</head>
<body>
    <h1>Hello, this is a sample frontend application!</h1>
    <p>This content is served by Nginx.</p>
</body>
</html>
EOF

# Set proper permissions for the HTML file
sudo chown nginx:nginx /usr/share/nginx/html/index.html

# Restart Nginx to apply changes
sudo systemctl restart nginx

echo "Nginx installation and sample frontend application setup complete."
