# MediaWiki Automated Installation Script

This bash script automates the installation and initial configuration of MediaWiki on Ubuntu 22.04 LTS with Apache, MariaDB, and PHP 8.1.

## Features

- Automatic installation of all required dependencies
- MariaDB database creation and secure configuration
- Apache virtual host configuration
- PHP optimization for MediaWiki
- Automatic security settings
- Local development environment setup
- Backup directory creation
- Detailed post-installation instructions

## Prerequisites

- Ubuntu 22.04 LTS
- Root or sudo privileges
- Internet connection
- At least 1GB of free disk space
- Basic knowledge of server administration

## Installation

1. Download the installation script:
```bash
wget https://raw.githubusercontent.com/yourusername/mediawiki-installer/main/install_mediawiki.sh
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

1. Updates the system packages
2. Installs Apache web server
3. Installs MariaDB database server
4. Installs PHP 8.1 and required extensions
5. Secures the MariaDB installation
6. Creates a database and user for MediaWiki
7. Downloads and installs MediaWiki 1.39.3
8. Configures Apache virtual host
9. Sets up proper file permissions
10. Configures PHP settings for optimal performance
11. Creates a backup directory
12. Adds local domain to hosts file

## Post-Installation

After the script completes, you will need to:

1. Visit http://wiki.localhost in your web browser
2. Complete the MediaWiki web-based configuration
3. Use the database credentials displayed at the end of the installation
4. Download and place the generated LocalSettings.php file in /var/www/html/mediawiki/

## Security Considerations

- The script generates a random database password
- MariaDB is secured using mysql_secure_installation
- Appropriate file permissions are set
- Apache is configured with secure defaults

## Customization

You can modify the following variables in the script:
- `DB_NAME`: Database name
- `DB_USER`: Database username
- `MEDIAWIKI_VERSION`: MediaWiki version to install
- PHP settings in the php.ini configuration section

## Troubleshooting

Common issues and solutions:

1. If Apache fails to start, check:
   ```bash
   sudo systemctl status apache2
   sudo journalctl -u apache2
   ```

2. If database connection fails:
   ```bash
   sudo systemctl status mariadb
   ```

3. Check Apache error logs:
   ```bash
   sudo tail -f /var/log/apache2/mediawiki_error.log
   ```

## Backup

The script creates a backup directory at `/var/www/html/mediawiki/backups`. It's recommended to:
- Regularly backup your database
- Keep copies of your LocalSettings.php
- Backup any uploaded files

## Contributing

Feel free to submit issues and enhancement requests!

## License

This script is released under the MIT License. See the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository or consult the [MediaWiki documentation](https://www.mediawiki.org/wiki/Documentation).

## Disclaimer

This script is provided as-is without any warranty. Always test in a development environment before using in production.
