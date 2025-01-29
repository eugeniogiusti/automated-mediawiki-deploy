# MediaWiki Automated Installation Script

This script automates the installation process of MediaWiki on Ubuntu/Debian systems. It handles the complete setup of Apache, MySQL, PHP, and MediaWiki with secure defaults.

## Prerequisites

- Tested on Ubuntu 22.04
- VM with 2 virtual cpu 2gb RAM and 40gb storage
- Root or sudo privileges
- Internet connection to update the machine and download the necessary packages

## Features

- Automated installation of all required packages
- Secure MySQL setup
- Automatic database creation with random secure password
- Apache configuration with optimal settings
- PHP configuration for MediaWiki
- Complete MediaWiki installation

## Installation

1. Download the installation script:
```bash
git clone https://github.com/eugeniogiusti/automated-mediawiki-deploy.git
cd automated-mediawiki-deploy.git
```

2. Make the script executable:
```bash
chmod +x install_mediawiki.sh
```

3. Run the script:
```bash
sudo ./install_mediawiki.sh
```

## What the Script Does

### 1. System Update
- Updates package list
- Upgrades installed packages

### 2. Package Installation
Installs the following packages:
- Apache2
- MySQL Server
- PHP and required extensions:
  - libapache2-mod-php
  - php-mysql
  - php-xml
  - php-mbstring
  - php-intl
  - php-curl
  - php-json
  - php-zip

### 3. Database Setup
- Creates a MediaWiki database
- Creates a dedicated MySQL user
- Generates a secure random password
- Sets appropriate database permissions

### 4. MediaWiki Installation
- Downloads MediaWiki version 1.39.3
- Extracts files to Apache web directory
- Sets proper file permissions
- Configures Apache virtual host

### 5. Server Configuration
- Enables Apache rewrite module
- Configures PHP settings for optimal MediaWiki performance
- Increases upload file size limits to 20MB

## Post-Installation

After the script completes, you will see:
- The URL to access your MediaWiki installation
- Database credentials (save these securely!)
- Instructions for completing web-based setup

Important: Complete the web-based setup by visiting:
```
http://YOUR_SERVER_IP/mediawiki
```

## Database Credentials

The script will display the following credentials at the end of installation:
- Database Name: mediawiki
- Database User: mediawiki_user
- Database Password: [automatically generated]

⚠️ **IMPORTANT**: Save these credentials immediately as they are required for the web-based setup!

## Security Considerations

1. The script generates a random database password using OpenSSL
2. Apache is configured with secure defaults
3. MySQL secure installation is automated
4. File permissions are set according to security best practices

## Customization

You can modify the following variables in the script:
- `MEDIAWIKI_VERSION`: Change the MediaWiki version
- `DB_NAME`: Change the database name
- `DB_USER`: Change the database username

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   sudo chmod +x install_mediawiki.sh
   ```

2. **MySQL Connection Issues**
   - Check MySQL service status:
   ```bash
   sudo systemctl status mysql
   ```

3. **Apache Not Starting**
   - Check Apache error logs:
   ```bash
   sudo tail -f /var/log/apache2/error.log
   ```

### Log Files

Important log locations:
- Apache: `/var/log/apache2/error.log`
- MySQL: `/var/log/mysql/error.log`
- PHP: `/var/log/apache2/error.log`

## Maintenance

### Backup Database
```bash
mysqldump -u [DB_USER] -p [DB_NAME] > backup.sql
```

### Update MediaWiki
The script installs MediaWiki 1.39.3. For updates:
1. Backup your database and files
2. Change `MEDIAWIKI_VERSION` in the script
3. Run the update script from MediaWiki's web interface

## Contributing

Feel free to submit issues and enhancement requests!

## License

This script is licensed under the GPL license - see the LICENSE file for details.
