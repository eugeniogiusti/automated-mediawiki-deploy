# How to Customize Your MediaWiki Logo

This guide will show you how to replace the default MediaWiki logo with your company's logo.

## Logo Requirements

Before starting, ensure your logo meets these requirements:
- Recommended format: PNG with transparent background
- Recommended dimensions: 160px × 160px
- File size: preferably under 1MB
- Filename: avoid spaces and special characters

## Method 1: Using LocalSettings.php

1. **Logo Preparation**
   - Prepare your logo file (example: `company-logo.png`)
   - Upload the file to `/var/www/html/mediawiki/resources/assets/`
   ```bash
   sudo cp company-logo.png /var/www/html/mediawiki/resources/assets/
   ```
   - Ensure correct permissions:
   ```bash
   sudo chown www-data:www-data /var/www/html/mediawiki/resources/assets/company-logo.png
   sudo chmod 644 /var/www/html/mediawiki/resources/assets/company-logo.png
   ```

2. **Modifying LocalSettings.php**
   - Open the configuration file:
   ```bash
   sudo nano /var/www/html/mediawiki/LocalSettings.php
   ```
   - Add or modify these lines:
   ```php
   # Logo configuration
   $wgLogos = [
       '1x' => "$wgResourceBasePath/resources/assets/company-logo.png",
       'icon' => "$wgResourceBasePath/resources/assets/company-logo.png",
   ];
   
   # Optional: Different logo for mobile devices
   $wgMobileLogos = [
       'default' => "$wgResourceBasePath/resources/assets/company-logo.png"
   ];
   ```
   - Save the file (in nano: Ctrl + X, then Y, then Enter)

3. **Cache Clearing**
   - Clear browser cache
   - Run MediaWiki's maintenance script:
   ```bash
   cd /var/www/html/mediawiki
   php maintenance/update.php
   ```

## Method 2: Using Web Interface (For Administrators)

1. **Login as Administrator**
   - Go to your wiki and log in with an administrator account

2. **Upload the Logo**
   - Navigate to `Special:Upload`
   - Upload your logo
   - Note the exact uploaded filename

3. **Configure the Logo**
   - Go to `MediaWiki:Common.css`
   - Add this CSS code:
   ```css
   #p-logo a {
       background-image: url("PATH_TO_YOUR_LOGO") !important;
       background-size: contain !important;
   }
   ```

## Additional Customization

### Logo Styling
You can further modify the logo appearance by adding custom CSS in `MediaWiki:Common.css`:

```css
#p-logo {
    /* Modify logo container size */
    width: 200px;
    height: 200px;
}

#p-logo a {
    /* Modify logo positioning */
    background-position: center center;
    /* Add hover transition */
    transition: opacity 0.3s ease;
}

#p-logo a:hover {
    /* Hover effect */
    opacity: 0.8;
}
```

### Dark Theme Logo
If your wiki supports a dark theme, you can configure an alternative logo:

```php
$wgLogos = [
    '1x' => [
        'light' => "$wgResourceBasePath/resources/assets/logo-light.png",
        'dark' => "$wgResourceBasePath/resources/assets/logo-dark.png"
    ]
];
```

## Troubleshooting

1. **Logo Doesn't Appear**
   - Verify file permissions
   - Check the path in LocalSettings.php
   - Clear browser and wiki cache
   - Check Apache logs:
   ```bash
   sudo tail -f /var/log/apache2/error.log
   ```

2. **Distorted Logo**
   - Verify original image dimensions
   - Check custom CSS
   - Try removing conflicting CSS rules

3. **Persistent Cache**
   - Run:
   ```bash
   php maintenance/rebuildImages.php
   ```
   - Add a version parameter to the logo URL:
   ```php
   $wgLogos = [
       '1x' => "$wgResourceBasePath/resources/assets/company-logo.png?v=1.0",
   ];
   ```

## Best Practices

1. **Logo Versioning**
   - Keep a backup of the original logo
   - Use version control for LocalSettings.php
   - Document changes in the wiki

2. **Image Optimization**
   - Compress PNG while maintaining quality
   - Consider providing multiple versions for different resolutions
   - Use tools like OptiPNG for optimization

3. **Security**
   - Limit upload permissions to trusted users
   - Always verify image files before uploading
   - Maintain regular configuration backups

## Performance Tips

1. **Image Optimization**
   - Use appropriate image compression
   - Consider using WebP format with PNG fallback
   - Optimize for different screen resolutions

2. **Caching Strategy**
   - Implement proper cache headers
   - Use browser caching effectively
   - Consider using a CDN for logo delivery

## Mobile Considerations

1. **Responsive Design**
   - Test logo appearance on different devices
   - Provide specific mobile versions if needed
   - Consider loading time on mobile networks

## Advanced Configuration

1. **Multiple Wiki Farms**
   - Share logos across wikis
   - Implement conditional logo loading
   - Use centralized configuration

2. **Custom Extensions**
   - Integrate with logo management extensions
   - Create custom logo rotation scripts
   - Implement A/B testing for logos

## Final Notes

- Always test changes in a staging environment before production
- Consider mobile experience when choosing logo dimensions and positioning
- Document changes for future reference
- Regular backup of both files and configurations
- Monitor performance impact after logo implementation

## Support and Resources

- MediaWiki Documentation
- Community Forums
- Professional Support Channels
- Related Extensions