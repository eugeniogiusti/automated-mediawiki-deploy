#!/bin/bash

# Update the system
sudo apt update && sudo apt upgrade -y

# Install necessary packages: Apache, MySQL, PHP, and required PHP extensions
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql php-xml php-mbstring php-intl php-curl php-json php-zip

# Secure MySQL installation
sudo mysql_secure_installation

# Create a database and user for MediaWiki
DB_NAME="mediawiki"
DB_USER="mediawiki_user"
DB_PASS=$(openssl rand -base64 12) # Generate a random password

# Log into MySQL and execute commands to create the database and user
sudo mysql -u root -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -u root -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# Download and install MediaWiki
MEDIAWIKI_VERSION="1.39.3" # Specify the version of MediaWiki to install
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
    DocumentRoot /var/www/html/mediawiki
    <Directory /var/www/html/mediawiki/>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Enable the MediaWiki site and disable the default Apache site
sudo a2ensite mediawiki.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2

# Enable Apache's rewrite module for clean URLs
sudo a2enmod rewrite
sudo systemctl restart apache2

# Configure PHP settings (increase upload file size limits)
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php/8.1/apache2/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 20M/' /etc/php/8.1/apache2/php.ini
sudo systemctl restart apache2

# Display final instructions
echo "MediaWiki has been successfully installed!"
echo "You can access MediaWiki at: http://$(hostname -I | cut -d' ' -f1)/mediawiki"
echo "Database Name: ${DB_NAME}"
echo "Database User: ${DB_USER}"
echo "Database Password: ${DB_PASS}"
