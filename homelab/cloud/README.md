## What this setup does

The `backup-cloud.sh` script:

- Uses an external USB HDD for backups
- Creates **compressed, date-stamped archives**
- Backs up all cloud files
- Runs **every day at 3:00 AM**
- Automatically cleans backups older than **14 days**
- Works unattended after reboot


## Assumptions

- Cloud data directory: /srv/cloud/files
- File Browser database: /srv/cloud/filebrowser.db
- External HDD mount point: /mnt/backup-hdd

## HDD Setup for Recurrent Backups

### Get the disk UUID

Plug in the external HDD and run:

```bash
lsblk
sudo blkid
```

Copy the UUID of the external drive partition (e.g. /dev/sda1).

### Create the mount point
sudo mkdir -p /mnt/backup-hdd

### Enable auto-mount at boot
Edit /etc/fstab
Add line: UUID=<UUID>  /mnt/backup-hdd  ext4  defaults,nofail  0  2

### Create the backup directory on the HDD
mkdir -p /mnt/backup-hdd/cloud

### Schedule the Backup (Cron)
Edit the root crontab: sudo crontab -e
Add: 0 3 * * * /usr/local/bin/backup-cloud.sh

