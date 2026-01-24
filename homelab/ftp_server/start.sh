#!/bin/bash
#

FTP_DATA_DIR="/srv/ftp/keepass"
IMG_NAME="anon-lan-ftp"

mkdir -p "$FTP_DATA_DIR"/uploads

docker build -t "$IMG_NAME" .

read -r FTP_UID FTP_GID < <(
  docker run --rm "$IMG_NAME" sh -c 'id -u ftp; id -g ftp' | paste -sd ' ' -
)

echo "ftp user uid: $FTP_UID, gid: $FTP_GID"

sudo chown root:root "$FTP_DATA_DIR"
sudo chmod 755 "$FTP_DATA_DIR"

sudo chown "$FTP_UID":"$FTP_GID" "$FTP_DATA_DIR/uploads"
sudo chmod 755 "$FTP_DATA_DIR/uploads"

docker run -d \
	--network host \
	 --name "$IMG_NAME" \
	   -v "$FTP_DATA_DIR":/srv/vsftp/root/public \
             --restart unless-stopped \
                "$IMG_NAME"
