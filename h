[1mdiff --git a/Dockerfile b/Dockerfile[m
[1mindex e4a242f..75eed69 100644[m
[1m--- a/Dockerfile[m
[1m+++ b/Dockerfile[m
[36m@@ -1,22 +1,32 @@[m
 FROM php:8.1-apache[m
 [m
[32m+[m[32m# 1. Install required packages and build tools for extensions[m
 RUN apt-get update && apt-get install -y \[m
     unzip \[m
     git \[m
     zip \[m
     libzip-dev \[m
     libonig-dev \[m
[31m-    libicu-dev \           # <-- أضفنا هذه المكتبة[m
[31m-    && docker-php-ext-install pdo pdo_mysql zip intl  \   # <-- شغّل intl مع بقية الامتدادات[m
[32m+[m[32m    libicu-dev \[m
[32m+[m[32m    g++ \[m
[32m+[m[32m    make \[m
[32m+[m[32m    autoconf \[m
[32m+[m[32m    pkg-config \[m
[32m+[m[32m    && docker-php-ext-configure intl \[m
[32m+[m[32m    && docker-php-ext-install intl pdo_mysql zip \[m
     && docker-php-source delete[m
 [m
[32m+[m[32m# 2. Copy application code and set permissions[m
 COPY . /var/www/html/[m
 WORKDIR /var/www/html/[m
 RUN chown -R www-data:www-data /var/www/html \[m
     && a2enmod rewrite[m
 [m
[32m+[m[32m# 3. Install Composer[m
 COPY --from=composer:latest /usr/bin/composer /usr/bin/composer[m
 [m
[32m+[m[32m# 4. Install PHP dependencies (excluding dev for faster build)[m
 RUN composer install --no-dev --optimize-autoloader[m
 [m
[32m+[m[32m# 5. Expose port 80[m
 EXPOSE 80[m
