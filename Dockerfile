FROM php:8.1-apache

# تثبيت Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# نسخ ملفات المشروع
COPY . /var/www/html/

# تشغيل composer install داخل الحاوية
WORKDIR /var/www/html/
RUN composer install

# صلاحيات مجلد writable
RUN chown -R www-data:www-data /var/www/html/writable \
    && chmod -R 0777 /var/www/html/writable

# تفعيل mod_rewrite
RUN a2enmod rewrite

# إعداد apache ليخدم من public
RUN echo "DocumentRoot /var/www/html/public" > /etc/apache2/sites-available/000-default.conf \
 && echo "<Directory /var/www/html/public>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" >> /etc/apache2/apache2.conf

WORKDIR /var/www/html/public

EXPOSE 80

CMD ["apache2-foreground"]
