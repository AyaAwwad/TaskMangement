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

# 2. Copy application code
COPY . /var/www/html/
WORKDIR /var/www/html/

# 2.5. Configure Apache to use public/ as DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!DocumentRoot /var/www/html!DocumentRoot /var/www/html/public!g' \
    /etc/apache2/sites-available/000-default.conf \
 && sed -ri -e 's!<Directory /var/www/html>!<Directory /var/www/html/public>!g' \
    /etc/apache2/apache2.conf

# 2.6. Set permissions & enable mod_rewrite
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# 3. Install Composer binary
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Install PHP dependencies (excluding dev for faster build)
RUN composer install --no-dev --optimize-autoloader

# 5. Expose port 80
EXPOSE 80
