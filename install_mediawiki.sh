#!/bin/bash
set -euo pipefail

# Logging function
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

# Function to check if a service is active; if not, try to start it
check_service() {
  local service_name=$1
  if systemctl is-active --quiet "$service_name"; then
    log "The service '$service_name' is active."
  else
    log "The service '$service_name' is not active. Attempting to start it..."
    sudo systemctl start "$service_name"
    sleep 2
    if systemctl is-active --quiet "$service_name"; then
      log "The service '$service_name' has started successfully."
    else
      log "Unable to start the service '$service_name'. Exiting."
      exit 1
    fi
  fi
}

log "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Installing Apache
log "Installing Apache..."
sudo apt install -y apache2

# Installing MariaDB
log "Installing MariaDB..."
sudo apt install -y mariadb-server mariadb-client

# Starting and enabling the MariaDB service
log "Starting and enabling MariaDB..."
sudo systemctl start mariadb
sudo systemctl enable mariadb
check_service "mariadb"

# Non-interactive configuration of MariaDB (security)
log "Securing MariaDB..."
ROOT_PASS="eD19m89Rbo!"

sudo mariadb <<EOF
-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';
-- Drop the test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
-- Set the root password and change the authentication method to mysql_native_password
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${ROOT_PASS}');
FLUSH PRIVILEGES;
EOF

log "MariaDB has been secured."

# Creating the MediaWiki database and user
log "Creating the MediaWiki database and user..."
DB_NAME="mediawiki"
DB_USER="mediawiki_user"
DB_PASS=$(openssl rand -base64 12)

sudo mariadb -uroot -p"${ROOT_PASS}" <<EOF
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

log "Database '${DB_NAME}' and user '${DB_USER}' created successfully."
log "MediaWiki user password generated: ${DB_PASS}"

# Installing PHP 8.1 and required extensions
log "Installing PHP 8.1 and required extensions..."
sudo apt install -y php8.1 php8.1-cli php8.1-common php8.1-mysql php8.1-xml php8.1-mbstring php8.1-intl php8.1-curl php8.1-zip libapache2-mod-php8.1

# Verify that Apache is active
check_service "apache2"

# Downloading and installing MediaWiki
MEDIAWIKI_VERSION="1.39.3"
log "Downloading MediaWiki version ${MEDIAWIKI_VERSION}..."
cd /tmp
wget -q https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_VERSION%.*}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz

if [ ! -f mediawiki-${MEDIAWIKI_VERSION}.tar.gz ]; then
  log "MediaWiki tarball download failed. Exiting."
  exit 1
fi

tar -xzf mediawiki-${MEDIAWIKI_VERSION}.tar.gz
sudo mv mediawiki-${MEDIAWIKI_VERSION} /var/www/html/mediawiki
log "MediaWiki has been extracted and moved to /var/www/html/mediawiki."

# Setting correct permissions
sudo chown -R www-data:www-data /var/www/html/mediawiki
sudo chmod -R 755 /var/www/html/mediawiki

# Configuring Apache for MediaWiki
log "Configuring Apache for MediaWiki..."
sudo tee /etc/apache2/sites-available/mediawiki.conf > /dev/null <<EOL
<VirtualHost *:80>
    ServerName wiki.localhost
    DocumentRoot /var/www/html/mediawiki
    <Directory /var/www/html/mediawiki/>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/mediawiki_error.log
    CustomLog \${APACHE_LOG_DIR}/mediawiki_access.log combined
</VirtualHost>
EOL

sudo a2ensite mediawiki.conf
sudo a2dissite 000-default.conf
sudo a2enmod rewrite
sudo systemctl reload apache2

# Configuring PHP settings for MediaWiki
log "Configuring PHP settings for MediaWiki..."
sudo tee -a /etc/php/8.1/apache2/php.ini > /dev/null <<EOL

; Recommended settings for MediaWiki
upload_max_filesize = 20M
post_max_size = 20M
memory_limit = 128M
max_execution_time = 200
EOL

sudo systemctl reload apache2

# Adding an entry for "wiki.localhost" in /etc/hosts
log "Updating /etc/hosts for wiki.localhost..."
sudo sed -i '/wiki.localhost/d' /etc/hosts
echo "127.0.0.1 wiki.localhost" | sudo tee -a /etc/hosts

# Creating a backup directory for MediaWiki
log "Creating backup directory in MediaWiki..."
sudo mkdir -p /var/www/html/mediawiki/backups
sudo chown -R www-data:www-data /var/www/html/mediawiki/backups

# Final message
log "MediaWiki installation completed!"
echo "============================================"
echo "MediaWiki Installation Complete!"
echo "Access your wiki at: http://wiki.localhost"
echo ""
echo "Database Information:"
echo "  Database Name: ${DB_NAME}"
echo "  Database User: ${DB_USER}"
echo "  Database Password: ${DB_PASS}"
echo ""
echo "MariaDB root password (if set): ${ROOT_PASS}"
echo ""
echo "Next Steps:"
echo "  1. Visit http://wiki.localhost in your browser"
echo "  2. Follow the MediaWiki setup wizard"
echo "  3. Enter the database credentials when prompted"
echo "  4. Save the LocalSettings.php file in /var/www/html/mediawiki/"
echo "============================================"
