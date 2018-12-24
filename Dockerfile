FROM php:7.1.25-fpm-jessie

LABEL maintainer='Benjamin Vison <benjamin@syneteksolutions.com>'

COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./php.custom.ini /usr/local/etc/php/conf.d/php.custom.ini

CMD [ "php-fpm", "-R" ]
