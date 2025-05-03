FROM php:8.1-apache

# تثبيت الإضافات المطلوبة
RUN apt-get update && apt-get install -y \
    libicu-dev zip unzip git libzip-dev \
    && docker-php-ext-install intl zip \
    && a2enmod rewrite

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# إعداد مجلد التطبيق
WORKDIR /var/www/html/
COPY . .

# تثبيت الحزم
RUN composer install

# إعداد صلاحيات مجلد writable
RUN chown -R www-data:www-data /var/www/html/writable \
    && chmod -R 775 /var/www/html/writable

# تعديل DocumentRoot لـ public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# نسخ .htaccess
COPY public/.htaccess /var/www/html/public/.htaccess

# إعداد سكربت التشغيل
RUN echo '#!/bin/bash\n\
chown -R www-data:www-data /var/www/html/writable\n\
chmod -R 775 /var/www/html/writable\n\
ls -ld /var/www/html/writable/cache\n\
exec apache2-foreground' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
