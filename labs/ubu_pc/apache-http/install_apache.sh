#!/usr/bin/env bash

if [ -z "$SUDO_USER" ]; then
	echo "Run with sudo"
	exit 1
fi

apt install -y apache2
systemctl enable --now apache2

cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Lab Server</title></head>
<body>
  <h1>demo2 is alive</h1>
  <p>Secret: password123</p>
</body>
</html>
EOF


