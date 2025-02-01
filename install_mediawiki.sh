#!/bin/bash

# Update the system
sudo apt update && sudo apt upgrade -y

# Install Apache
sudo apt install -y apache2

# Install MariaDB
sudo apt install -y mariadb-server mariadb-client

# Install PHP 8.1 and required extensions from Ubuntu 22.04 default repositories
sudo apt install -y php8.1 \
    php8.1-cli \
    php8.1-common \
    php8.1-mysql \
    php8.1-xml \
    php8.1-mbstring \
    php8.1-intl \
    php8.1-curl \
    php8.1-zip \
    libapache2-mod-php8.1

# Securely configure Maria db
mysql -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE User='root';"
mysql_secure_installation <<EOF
n
y
N
y
y
EOF

# Create a database and user for MediaWiki
DB_NAME="mediawiki"
DB_USER="mediawiki_user"
DB_PASS=$(openssl rand -base64 12)

# Log into MariaDB and execute commands to create the database and user
sudo mariadb -e "CREATE DATABASE ${DB_NAME};"
sudo mariadb -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
sudo mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mariadb -e "FLUSH PRIVILEGES;"

# Download and install MediaWiki
MEDIAWIKI_VERSION="1.39.3"
MEDIAWIKI_URL="https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_VERSION%.*}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz"

# Download MediaWiki tarball
cd /tmp
wget ${MEDIAWIKI_URL}

# Extract the tarball and move it to the web directory
tar -xvzf mediawiki-${MEDIAWIKI_VERSION}.tar.gz
sudo mv mediawiki-${MEDIAWIKI_VERSION} /var/www/html/mediawiki

# Set proper permissions for the MediaWiki directory
sudo chown -R www-data:www-data /var/www/html/mediawiki
sudo chmod -R 755 /var/www/html/mediawiki

# Configure Apache for MediaWiki
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

# Enable the MediaWiki site and disable the default Apache site
sudo a2ensite mediawiki.conf
sudo a2dissite 000-default.conf

# Enable Apache's rewrite module for clean URLs
sudo a2enmod rewrite

# Configure PHP settings for MediaWiki
sudo tee -a /etc/php/8.1/apache2/php.ini > /dev/null <<EOL

; MediaWiki recommended settings
upload_max_filesize = 20M
post_max_size = 20M
memory_limit = 128M
max_execution_time = 200
EOL

# Restart Apache to apply all changes
sudo systemctl restart apache2

# Add entry to hosts file
sudo sed -i '/wiki.localhost/d' /etc/hosts
echo "127.0.0.1 wiki.localhost" | sudo tee -a /etc/hosts

# Create a backup directory
sudo mkdir -p /var/www/html/mediawiki/backups
sudo chown -R www-data:www-data /var/www/html/mediawiki/backups

# Display final instructions
echo "============================================"
echo "MediaWiki Installation Complete!"
echo "============================================"
echo "Access your wiki at: http://wiki.localhost"
echo ""
echo "Database Information:"
echo "Database Name: ${DB_NAME}"
echo "Database User: ${DB_USER}"
echo "Database Password: ${DB_PASS}"
echo ""
echo "Important Next Steps:"
echo "1. Visit http://wiki.localhost in your browser"
echo "2. Follow the MediaWiki setup wizard"
echo "3. Use the database credentials above during setup"
echo "4. Save the LocalSettings.php file to /var/www/html/mediawiki/"
echo ""
echo "Save these credentials in a secure location!"
echo "============================================"
