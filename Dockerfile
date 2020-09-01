FROM php:7.4.6-fpm-buster

LABEL maintainer='Benjamin Vison <benjamin@syneteksolutions.com>'

# Install dependencies
RUN apt-get update && apt-get install -y \
         libfreetype6-dev \
         libjpeg62-turbo-dev \
         gcc \
         make \
         autoconf \
         libc-dev \
         pkg-config \
         libmcrypt-dev \
         libpng-dev \
         zlib1g-dev \
         libicu-dev \
         libxml2-dev \
         g++ \
         wkhtmltopdf \
         xvfb \
         libonig-dev \
         libzip-dev \
    && pecl config-set php_ini "${PHP_INI_DIR}/php.ini" \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install -j$(nproc) bcmath iconv mbstring pdo pdo_mysql mysqli opcache zip xml xmlrpc xmlwriter opcache exif \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl \
    && apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./php.custom.ini /usr/local/etc/php/conf.d/php.custom.ini

CMD [ "php-fpm", "-R" ]
