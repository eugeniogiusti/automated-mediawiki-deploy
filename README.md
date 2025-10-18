# MediaWiki Automated Installation Script

<img width="1200" height="720" alt="mediawiki_1606708641_1" src="https://github.com/user-attachments/assets/b1f9820f-c238-4445-ad50-9285ca5ddec9" />


![Status](https://img.shields.io/badge/status-stable-brightgreen)
![Last Commit](https://img.shields.io/github/last-commit/eugeniogiusti/automated-mediawiki-deploy)
![License](https://img.shields.io/github/license/eugeniogiusti/automated-mediawiki-deploy)
![Top Language](https://img.shields.io/github/languages/top/eugeniogiusti/automated-mediawiki-deploy)
![Platform](https://img.shields.io/badge/platform-Ubuntu-blue)
![Tool](https://img.shields.io/badge/tool-MediaWiki-lightgrey)
![Shell Script](https://img.shields.io/badge/made%20with-bash-1f425f.svg)


This bash script automates the installation and initial configuration of MediaWiki on Ubuntu 22.04 LTS with Apache, MariaDB, and PHP 8.1.

## Features

- Automatic installation of all required dependencies
- MariaDB database creation
- Apache virtual host configuration
- PHP optimization for MediaWiki
- Local development environment setup
- Backup directory creation
- Detailed post-installation instructions

## Prerequisites

- Ubuntu 22.04 LTS
- Root or sudo privileges
- Internet connection
- VM with dual core virtual cpu
- 2GB ram
- 20 gb of storage

## Installation

1. Download the installation script:
```bash
git clone https://github.com/eugeniogiusti/automated-mediawiki-deploy/
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
5. Creates a database and user for MediaWiki
6. Downloads and installs MediaWiki 1.39.3
7. Configures Apache virtual host
8. Sets up proper file permissions
9. Configures PHP settings for optimal performance
10. Creates a backup directory
11. Adds local domain to hosts file

## Post Installation

After the script completes, you will need to:

1. Visit http://your_local_ip in your web browser
2. Complete the MediaWiki web-based configuration
3. Use the database credentials displayed at the end of the installation
4. Download and place the generated LocalSettings.php file in /var/www/html/mediawiki/

## Security Considerations

- The script generates a random database password
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

## Notes

- This script is intended for fresh Ubuntu 22.04 installations.
- During the installation of some libraries, you might see a message like:
Daemons using outdated libraries. Which services should be restarted?(screenshoot below)"

This message indicates that some libraries have been updated, but the daemons using them
are still running with the previous version loaded in memory. It is not necessary to
restart the services immediately, as the system will continue to function normally with
the old libraries.
To proceed:
1. Press the TAB key to select "OK" and confirm.
2. Continue with the installation without restarting the services.
If you encounter any issues or instability later, try restarting the virtual machine to
ensure the services use the latest versions of the libraries.

![image](https://github.com/user-attachments/assets/afe683b8-2d5b-4327-b68d-29ed46a784c2)
