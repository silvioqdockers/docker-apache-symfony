FROM debian:jessie
MAINTAINER Lars Janssen <lars@fazy.net>

ENV DEBIAN_FRONTEND noninteractive
RUN    apt-get update \
    && apt-get -yq install \
        libapache2-mod-php5 \
        php5-intl \
        php5-curl \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP (CLI and Apache)
RUN sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php5/cli/php.ini \
    && sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php5/apache2/php.ini

# Configure Apache vhost
RUN rm -rf /var/www/*
RUN a2enmod rewrite
ADD vhost.conf /etc/apache2/sites-available/000-default.conf

# Add main start script for when image launches
ADD run.sh /run.sh
RUN chmod 0755 /run.sh

WORKDIR /app
EXPOSE 80
CMD ["/run.sh"]

