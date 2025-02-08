

## Web Configuration Steps

![the result of the script](https://github.com/user-attachments/assets/a709279e-b7ce-4756-82ee-b49cbd361469)


![1](https://github.com/user-attachments/assets/325a8d5f-de6f-48ab-ae03-71b006190273)


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

![ksnip_20250208-153629](https://github.com/user-attachments/assets/054e22da-46a1-47fa-93de-22fd07b638bd)

   - Wiki configuration:
     * Wiki name
     * Admin username
     * Admin password
     * Language

![name_and-ETC](https://github.com/user-attachments/assets/b5417e65-8ea4-47c6-a1ed-31107e149fc5)


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

![php](https://github.com/user-attachments/assets/30699fe5-7380-4a63-b00e-9a55205639b6)

![final license](https://github.com/user-attachments/assets/359812fb-7801-470a-b9dd-a0c266a604bb)

![it's done](https://github.com/user-attachments/assets/99aece7c-af5b-4c98-853a-66bd82ca546c)





![here_we_go](https://github.com/user-attachments/assets/c5fad87a-0d80-49d6-9aa1-0ee8a6f309e3)

