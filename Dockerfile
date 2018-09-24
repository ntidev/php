FROM php:7.1.14-fpm-jessie

LABEL maintainer='Benjamin Vison <benjamin@syneteksolutions.com>'

# Install dependencies
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        libxml2-dev \
        g++ \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring pdo pdo_mysql mysqli opcache zip xml xmlrpc xmlwriter \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd intl

WORKDIR /var/www/html
USER www-data
