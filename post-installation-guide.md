

## Web Configuration Steps

1. Access your MediaWiki installation through your web browser:
```
http://your_ip_address
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
