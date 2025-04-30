# استخدام صورة PHP مع Apache
FROM php:8.1-apache

# تثبيت الامتدادات المطلوبة
RUN apt-get update && apt-get install -y \
    libicu-dev \
    zip \
    unzip \
    && docker-php-ext-install intl

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# تعيين مجلد العمل داخل الحاوية
WORKDIR /var/www/html

# نسخ ملفات المشروع إلى الحاوية
COPY . .

# تثبيت الاعتماديات (composer install)
RUN composer install --no-dev --optimize-autoloader

# إعداد صلاحيات مجلد writable
RUN chown -R www-data:www-data /var/www/html/writable

# تغيير DocumentRoot إلى مجلد public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# تفعيل mod_rewrite في Apache (مطلوب لـ CodeIgniter)
RUN a2enmod rewrite

# تعيين صلاحيات نهائية
RUN chmod -R 755 /var/www/html

# المنفذ الذي سيتم الاستماع عليه (Render تستخدمه تلقائيًا)
EXPOSE 80
