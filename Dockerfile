FROM php:8.1-apache

# تثبيت الامتدادات اللازمة لـ CodeIgniter
RUN docker-php-ext-install pdo pdo_mysql

# نسخ الملفات داخل الحاوية
COPY . /var/www/html/

# إعداد صلاحيات مجلد writable
RUN chown -R www-data:www-data /var/www/html/writable \
    && chmod -R 0777 /var/www/html/writable

# تفعيل mod_rewrite لـ CodeIgniter
RUN a2enmod rewrite

# إعداد Apache لاستقبال الطلبات
RUN echo '<Directory /var/www/html/public>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf

# تحديد مجلد التشغيل
WORKDIR /var/www/html/public

EXPOSE 80

CMD ["apache2-foreground"]
