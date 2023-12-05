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


### Nextcloud Data Backup:

1. Download the [sync-nextcloud.sh](./sync-nextcloud.sh) script to PC.
2. Install Rsync and set up SSH key-based login from the root account, logging in once for authentication.
3. Modify the information in the script according to your configuration.
4. Move the script to the /bin directory and grant execute permissions
5.  Run the script as root
6.  If the script runs successfully:
7.  Create a systemd service file [sync-nextcloud.service](./sync-nextcloud.service) in the /etc/systemd/system/ directory.
8.  Reload the systemd daemon:
      `systemctl daemon-reload`
9. Enable the servie to run at startup:
      `systemctl enable sync-nextcloud.service`
10. Now, every time your PC boots, the Nextcloud data from the homeserver will be automatically synced to PC.

