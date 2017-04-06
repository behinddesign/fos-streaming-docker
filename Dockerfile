FROM phusion/baseimage:0.9.19
ENV DEBIAN_FRONTEND=noninteractive

ENV FOS_HOME_DIR=${FOS_HOME_DIR:-/home/fos-streaming}
ENV FOS_INSTALL_DIR=${FOS_INSTALL_DIR:-/www}
ENV FOS_USER=${FOS_USER:-fosstreaming}
ENV FOS_HLS_CACHE=${FOS_HLS_CACHE:-/hls-cache}

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# User
RUN useradd -s /sbin/nologin -U -d $FOS_HOME_DIR -m $FOS_USER
RUN sh -c 'echo "nameserver 8.8.8.8" >> /etc/resolv.conf'

# Installing Packages
RUN apt-get update
RUN apt-get install -y nginx php-fpm
RUN apt-get install -y wget curl git make build-essential unzip openssl librtmp-dev libjpeg8
RUN apt-get install -y ffmpeg

# Services

# CronJob
RUN FOS_INSTALL_DIR=$FOS_INSTALL_DIR sh -c 'echo "*/2 * * * * fosstreaming php $FOS_INSTALL_DIR/cron.php" >> /etc/crontab'

VOLUME $FOS_HLS_CACHE
EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Source from GIT
