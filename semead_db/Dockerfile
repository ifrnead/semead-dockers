# Dockerfile
#
# Image for SEMEAD database layer container
#
# Build this with:
# $ docker build -t semead_db .
#

# Baseline image
FROM phusion/baseimage:0.9.18
MAINTAINER Allan Garcia <allan.garcia@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Environments
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Configure timezone
RUN echo 'America/Recife' > /etc/timezone && dpkg-reconfigure tzdata

# Update the OS
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install needed extra packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    mysql-server-5.5 \
    mysql-client-5.5

# Install mysql service
RUN mkdir /etc/service/mysql
ADD aux_files/mysql-service.sh /etc/service/mysql/run

# Configure mysql access
RUN sed -i '/bind-address/s/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf

# Configure mysql database and user on first run
ADD aux_files/init_run.sh /etc/my_init.d/99_init_run.sh

# Expose application port
EXPOSE 3306

# Configuring data volume
VOLUME /var/lib/mysql

# Cleaning up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
