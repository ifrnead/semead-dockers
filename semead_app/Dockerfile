# Dockerfile
#
# Image for SEMEAD application layer container
#
# Build this with:
# $ docker build -t semead_app .
#

# Baseline image
FROM phusion/passenger-ruby22:0.9.18
MAINTAINER Allan Garcia <allan.garcia@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Environments
ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Configure timezone
RUN echo 'America/Recife' > /etc/timezone && dpkg-reconfigure tzdata

# Update the OS
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Copy SSH Keys
COPY aux_files/id_rsa /home/app/.ssh/id_rsa
COPY aux_files/id_rsa.pub /home/app/.ssh/id_rsa.pub

# Download the project
WORKDIR /home/app
RUN git clone https://github.com/ifrnead/semead.git semead
ADD aux_files/database.yml semead/config/database.yml
ADD aux_files/secrets.yml semead/config/secrets.yml
RUN chown -R app: /home/app

# Install required application's gems
RUN bundle install --without development test

# Initialize redmine database and load default data on first run
ADD aux_files/init_run.sh /etc/my_init.d/99_init_run.sh

# Enable nginx service
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD aux_files/semead_nginx.conf /etc/nginx/sites-enabled/semead.conf

# Expose application port
EXPOSE 80

# Configuring data volume
VOLUME /home/app/semead/public/system

# Cleaning up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
