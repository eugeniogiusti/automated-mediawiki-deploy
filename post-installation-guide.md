# MediaWiki Post-Installation Configuration Guide

This guide covers the steps after installing MediaWiki when you need to configure the database and import LocalSettings.php.

## Prerequisites
- MediaWiki installed on your server
- Database server (MySQL/MariaDB) running
- Web server (Apache/Nginx) configured
- PHP installed with required extensions

## Web Configuration Steps

1. Access your MediaWiki installation through your web browser:
```
http://your-domain/mediawiki
```

2. On the configuration page, you'll need to provide:
   - Database configuration:
     * Database name (e.g., `wikidb`)
     * Database username (e.g., `wikiuser`)
     * Database password
     * Database host (usually `localhost`)
     * Table prefix (optional, default: `wiki_`)

   - Wiki configuration:
     * Wiki name
     * Admin username
     * Admin password
     * Language

3. After submitting the configuration, MediaWiki will generate a `LocalSettings.php` file.

## Installing LocalSettings.php

1. Download the generated `LocalSettings.php` file from the web interface.

2. Upload the file to your MediaWiki root directory:
```bash
# Using SCP (from your local machine)
scp LocalSettings.php user@your-server:/path/to/mediawiki/

# Or using FTP/SFTP client
# Upload to /path/to/mediawiki/
```

3. Set proper permissions:
```bash
cd /path/to/mediawiki
chown www-data:www-data LocalSettings.php
chmod 644 LocalSettings.php
```

4. Verify installation by accessing your wiki:
```
http://your-domain/mediawiki
```

## Common Issues and Solutions

### Permission Denied
If you get permission errors:
```bash
# Fix directory permissions
chown -R www-data:www-data /path/to/mediawiki
find /path/to/mediawiki -type d -exec chmod 755 {} \;
find /path/to/mediawiki -type f -exec chmod 644 {} \;
```

### Database Connection Failed
If database connection fails:
1. Verify database credentials in `LocalSettings.php`
2. Ensure database server is running:
```bash
systemctl status mysql
# or
systemctl status mariadb
```
3. Check database user permissions:
```sql
GRANT ALL PRIVILEGES ON wikidb.* TO 'wikiuser'@'localhost';
FLUSH PRIVILEGES;
```

### Images Not Uploading
If image uploads fail:
1. Check `images` directory permissions:
```bash
chown -R www-data:www-data /path/to/mediawiki/images
chmod -R 755 /path/to/mediawiki/images
```
2. Verify PHP file upload settings in `php.ini`:
```ini
upload_max_filesize = 20M
post_max_size = 20M
```

## Security Recommendations

1. After successful installation:
   - Remove install.php:
   ```bash
   rm /path/to/mediawiki/mw-config/install.php
   ```
   
2. Secure LocalSettings.php:
   ```bash
   chmod 400 LocalSettings.php
   ```

3. Configure error reporting in LocalSettings.php:
   ```php
   error_reporting( E_ALL );
   ini_set( 'display_errors', 0 );
   $wgShowExceptionDetails = false;
   ```

## Maintenance

Regular maintenance tasks:
```bash
# Run update script after upgrades
php maintenance/update.php

# Clear cache if needed
php maintenance/rebuildall.php

# Update search index
php maintenance/rebuildtextindex.php
```

## Additional Resources

- [MediaWiki Configuration Settings](https://www.mediawiki.org/wiki/Manual:Configuration_settings)
- [MediaWiki Maintenance Scripts](https://www.mediawiki.org/wiki/Manual:Maintenance_scripts)
- [MediaWiki Security Guide](https://www.mediawiki.org/wiki/Manual:Security)

Remember to regularly backup both your database and LocalSettings.php file. Keep your MediaWiki installation updated with the latest security patches.
