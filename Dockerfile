FROM php:8.1-apache

# 1. Install required packages and build tools for extensions
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    zip \
    libzip-dev \
    libonig-dev \
    libicu-dev \
    g++ \
    make \
    autoconf \
    pkg-config \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl pdo_mysql zip \
    && docker-php-source delete

# 2. Copy application code and set permissions
COPY . /var/www/html/
WORKDIR /var/www/html/
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# 3. Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Install PHP dependencies (excluding dev for faster build)
RUN composer install --no-dev --optimize-autoloader

# 5. Expose port 80
EXPOSE 80
