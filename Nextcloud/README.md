## Nextcloud Tweaks:

### Configuring Cron Job:

1. Deploy Nextcloud using Docker Compose.
2. Configure the Cron Job on the host machine:
   - Log in to the host machine.
   - Edit the crontab using `crontab -e`.
   - Add the following line:
     ```
     */5 * * * * docker exec -u www-data nextcloud php cron.php
     ```
   - Reload Cron with `service cron reload`.
3. Enable the "Cron" option in the Nextcloud GUI under **Basic Settings > Background Jobs**.
4. You're all set!

### Resolving Auto Upload Conflicts on Android:

1. Edit the `.htaccess` file at `/storage/data/docker/nextcloud/nextcloudapp/`
2. Comment out the following lines:
   ```apache
   # Comment out the following lines
   # ErrorDocument 403 /index.php/error/403
   # ErrorDocument 404 /index.php/error/404
3. Done.
