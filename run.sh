#!/bin/bash
chown bin:bin /app -R

if [ "$ALLOW_OVERRIDE" = "**False**" ]; then
    unset ALLOW_OVERRIDE
else
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    sed -i -e '/export APACHE_RUN_USER=/ s/=.*/=bin/' /etc/apache2/envvars
    sed -i -e '/export APACHE_RUN_GROUP=/ s/=.*/=bin/' /etc/apache2/envvars
    a2enmod rewrite
    a2enmod headers
fi

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
