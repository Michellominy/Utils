#!/bin/bash
#

FTP_DATA_DIR="$(pwd)/ftpdata"
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
    --name "$IMG_NAME" \
    -p 20:20 \
       -p 21:21 \
        -p 30000-30100:30000-30100 \
          -v "$FTP_DATA_DIR":/srv/vsftp/root/public \
               --restart unless-stopped \
                   "$IMG_NAME"
