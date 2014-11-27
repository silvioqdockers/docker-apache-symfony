#!/bin/bash

chown -R www-data: /var/www/main
chmod -R a+rX /var/www/main

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
