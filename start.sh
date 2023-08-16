#!/bin/sh


if [ ! "$(ls -A /var/www/html)" ]; then
    cp -r /var/www/tmp_html/* /var/www/html/
fi
rm -rf /var/www/tmp_html
chmod -R 777 /var/www/html/
# 启动 PHP-FPM
php-fpm -c /usr/local/etc/php.ini -D

# 启动 Nginx
nginx -g "daemon off;"
