#!/bin/bash

mkdir -p var/cache var/logs var/sessions app/cache app/logs
touch var/logs/prod.log app/logs/prod.log
chgrp -R www-data .
chmod -R g+w var/cache var/logs var/sessions app/cache app/logs

source /etc/apache2/envvars

tail -F /var/log/apache2/* app/logs/prod.log var/logs/prod.log &
exec apache2 -D FOREGROUND

