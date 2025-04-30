FROM php:8.1-apache

RUN docker-php-ext-install pdo pdo_mysql

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html/writable \
    && chmod -R 0777 /var/www/html/writable

RUN a2enmod rewrite

# تعديل إعدادات apache لقراءة public كمجلد رئيسي
RUN echo "DocumentRoot /var/www/html/public" > /etc/apache2/sites-available/000-default.conf \
 && echo "<Directory /var/www/html/public>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" >> /etc/apache2/apache2.conf

WORKDIR /var/www/html/public

EXPOSE 80

CMD ["apache2-foreground"]
