#!/bin/bash
# Update system
yum update -y

# Install Apache web server
yum install -y httpd

# Install MySQL client
yum install -y mysql

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple web page
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Multi-Tier Web Application</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f4f4; }
        .container { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .header { color: #333; text-align: center; }
        .info { background-color: #e8f4fd; padding: 15px; border-radius: 4px; margin: 20px 0; }
        .success { color: #28a745; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">🚀 Multi-Tier Web Application</h1>
        <div class="info">
            <h3>Server Information:</h3>
            <p><strong>Instance ID:</strong> <span id="instance-id">Loading...</span></p>
            <p><strong>Availability Zone:</strong> <span id="az">Loading...</span></p>
            <p><strong>Local IP:</strong> <span id="local-ip">Loading...</span></p>
        </div>
        <div class="success">
            ✅ Web server is running successfully!<br>
            ✅ Auto Scaling Group is active!<br>
            ✅ Load Balancer is distributing traffic!
        </div>
        <p><em>This page is served from an EC2 instance in a private subnet, behind an Application Load Balancer.</em></p>
    </div>

    <script>
        // Fetch EC2 metadata
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(response => response.text())
            .then(data => document.getElementById('instance-id').textContent = data)
            .catch(error => document.getElementById('instance-id').textContent = 'Unable to fetch');

        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(response => response.text())
            .then(data => document.getElementById('az').textContent = data)
            .catch(error => document.getElementById('az').textContent = 'Unable to fetch');

        fetch('http://169.254.169.254/latest/meta-data/local-ipv4')
            .then(response => response.text())
            .then(data => document.getElementById('local-ip').textContent = data)
            .catch(error => document.getElementById('local-ip').textContent = 'Unable to fetch');
    </script>
</body>
</html>
EOF

# Set proper permissions
chown apache:apache /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Create a health check endpoint
echo "OK" > /var/www/html/health

# Restart Apache to ensure everything is loaded
systemctl restart httpd