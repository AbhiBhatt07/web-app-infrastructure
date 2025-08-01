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

# Wait a bit to make sure everything starts properly
sleep 10

# Create a simple web page with EC2 metadata info
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
        async function fetchMetadata(path, elementId) {
            try {
                const response = await fetch('http://169.254.169.254/latest/meta-data/' + path);
                const data = await response.text();
                document.getElementById(elementId).textContent = data;
            } catch (err) {
                document.getElementById(elementId).textContent = 'Unable to fetch';
            }
        }

        fetchMetadata('instance-id', 'instance-id');
        fetchMetadata('placement/availability-zone', 'az');
        fetchMetadata('local-ipv4', 'local-ip');
    </script>
</body>
</html>
EOF

# Create health check file
echo "OK" > /var/www/html/health

# Set correct permissions
chown apache:apache /var/www/html/index.html /var/www/html/health
chmod 644 /var/www/html/index.html /var/www/html/health

# Restart Apache again to make sure everything is loaded properly
systemctl restart httpd
