FROM php:7.4.6-fpm-buster

LABEL maintainer='Benjamin Vison <benjamin@syneteksolutions.com>'

ENV DEBIAN_FRONTEND noninteractive

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
         wget \
         libonig-dev \
         libzip-dev \
         sox \
         libtiff-tools \
         ghostscript \
         ffmpeg \
    # wkhtmltox installation
    && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb -P /var/www \    
    && dpkg --configure -a \
    && apt-get install -y xvfb libfontconfig fontconfig libpng16-16 libxrender1 xfonts-75dpi build-essential xorg \
    && dpkg -i /var/www/wkhtmltox_0.12.5-1.buster_amd64.deb \  
    && cp /usr/local/bin/wkhtmlto* /usr/bin \
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
