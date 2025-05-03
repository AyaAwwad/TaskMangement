# استخدمي صورة PHP مع Apache
FROM php:8.1-apache

# تثبيت الإضافات المطلوبة
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git libicu-dev \
    && docker-php-ext-install intl pdo pdo_mysql

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# نسخ ملفات المشروع إلى الحاوية
COPY . /var/www/html/

# إعداد Apache لاستخدام مجلد /public كـ DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# تفعيل mod_rewrite
RUN a2enmod rewrite

# الانتقال لمجلد المشروع
WORKDIR /var/www/html/

# تثبيت الحزم
RUN composer install

# ⚠️ إعداد صلاحيات مجلد writable
RUN chown -R www-data:www-data /var/www/html/writable && chmod -R 775 /var/www/html/writable

# فتح البورت
EXPOSE 80

# بدء Apache
CMD ["apache2-foreground"]
