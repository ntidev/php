FROM php:8.2.17-fpm-bookworm

LABEL maintainer="Angel Bencosme, Wandy Hernandez <https://whernandez.github.io/my-portfolio/>"

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
         acl \
         procps \
         git \
         nano \
         zip \
         libwebp-dev \
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
    # wkhtmltox installation
    && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb -P /var/www \
    && dpkg --configure -a \
    && apt-get install -y xvfb libfontconfig fontconfig libpng16-16 libxrender1 xfonts-75dpi build-essential xorg \
    && dpkg -i /var/www/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && cp /usr/local/bin/wkhtmlto* /usr/bin \
    && pecl config-set php_ini "${PHP_INI_DIR}/php.ini" \
    && pecl install mcrypt-1.0.3 \
    # Docker extensions
    && docker-php-ext-install -j$(nproc) intl opcache pdo pdo_mysql zip gd xmlrpc xmlwriter opcache exif xml mysqli mbstring iconv bcmath \
    && docker-php-ext-enable mcrypt \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/


 COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
 COPY ./php.custom.ini /usr/local/etc/php/conf.d/php.custom.ini

COPY . .

CMD [ "php-fpm", "-R" ]
