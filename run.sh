#!/bin/bash

mkdir -p app/cache app/logs
chown -R www-data: .
source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND

