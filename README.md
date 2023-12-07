### Backup Homeserver Data to PC:

1. Download the [backup-homeserver.sh](./backup-homeserver.sh) script to PC.
2. Install Rsync and set up SSH key-based login from the root account, log in once for authentication.
3. Modify the information in the script according to your configuration.
4. Move the script to the /bin directory and grant execute permissions
5.  Run the script as root
6.  If the script runs successfully:
7.  Create a systemd service file [backup-homeserver.service](./backup-homeserver.service) in the /etc/systemd/system/ directory.
8.  Reload the systemd daemon:
      `systemctl daemon-reload`
9. Enable the servie to run at startup:
      `systemctl enable sync-nextcloud.service`
10. Now, every time your PC boots, the Nextcloud data from the homeserver will be automatically synced to PC.
