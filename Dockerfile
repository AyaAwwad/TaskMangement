FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    unzip \
    git \
    zip \
    libzip-dev \
    libonig-dev \
    libicu-dev \           # <-- أضفنا هذه المكتبة
    && docker-php-ext-install pdo pdo_mysql zip intl  \   # <-- شغّل intl مع بقية الامتدادات
    && docker-php-source delete

COPY . /var/www/html/
WORKDIR /var/www/html/
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer install --no-dev --optimize-autoloader

EXPOSE 80
