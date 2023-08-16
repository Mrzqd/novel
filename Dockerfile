# 使用官方 PHP 7.3 基础镜像
FROM php:7.3-fpm

# 安装 Nginx 和其他必要的软件包
RUN apt-get update && apt-get install -y \
    nginx \
    libmemcached-dev \
    zlib1g-dev \
    unzip \
    libwebp-dev libjpeg-dev libpng-dev libfreetype6-dev \
    && pecl install memcached-3.1.3 \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install fileinfo \
    && pecl install swoole-4.5.2 \
    && docker-php-ext-enable swoole
RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install gd \
   && docker-php-ext-enable gd

# 复制并解压 ZIP 压缩包到容器中
COPY ./PTCMS.zip /var/www/html/
RUN unzip /var/www/html/PTCMS.zip -d /var/www/tmp_html/ && rm -r /var/www/html/*

# 将自定义的 php 配置添加到容器中

# 复制 Nginx 配置
COPY default.conf /etc/nginx/sites-available/default
COPY php.ini /usr/local/etc/php.ini
COPY rewrite.conf /rewrite.conf


# 设置 Nginx 和 PHP-FPM 启动脚本
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
