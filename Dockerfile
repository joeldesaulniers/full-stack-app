FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    openssl \
    libssl-dev \
    pkg-config

WORKDIR /var/www/html

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY src/ /var/www/html

RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

RUN composer install

RUN composer dump-autoload

EXPOSE 80
