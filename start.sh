#!/bin/bash

chown -R www-data: /var/www/app
chmod -R a+rX /var/www/app

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
