FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends vsftpd && \
    apt-get clean && rm -rf /var/lib/apt/lists/

COPY vsftpd.conf /etc/vsftpd.conf


RUN mkdir -p /srv/vsftp/root/public \
    && mkdir -p /var/run/vsftpd/empty \  
    && chown -R ftp:ftp /srv/vsftp/root/public \
    && chmod -R 755 /srv/vsftp/root/public

EXPOSE 20 21 30000-30100

CMD ["vsftpd", "-obackground=NO", "/etc/vsftpd.conf"]

