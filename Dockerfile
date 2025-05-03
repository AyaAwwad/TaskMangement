# استخدم صورة PHP مع Apache
FROM php:8.1-apache

# تثبيت الامتدادات المطلوبة
RUN apt-get update && apt-get install -y \
    libicu-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install intl pdo pdo_mysql

# نسخ ملفات المشروع إلى داخل الحاوية
COPY . /var/www/html/

# تحديد مجلد العمل
WORKDIR /var/www/html/

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# تثبيت الاعتمادات (vendor)
RUN composer install --no-interaction --no-dev --prefer-dist

# إعداد صلاحيات مجلد writable و logs
RUN chown -R www-data:www-data /var/www/html/writable \
    && chmod -R 775 /var/www/html/writable

# تفعيل إعادة كتابة العناوين
RUN a2enmod rewrite

# تغيير DocumentRoot ليكون مجلد public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# نسخ ملف .htaccess إلى مجلد public إن لم يكن موجودًا
COPY public/.htaccess /var/www/html/public/.htaccess

# سكريبت لتعديل الصلاحيات وقت التشغيل
RUN echo '#!/bin/bash\n\
chown -R www-data:www-data /var/www/html/writable\n\
chmod -R 775 /var/www/html/writable\n\
exec apache2-foreground' > /start.sh && chmod +x /start.sh

# الأمر الرئيسي عند تشغيل الحاوية
CMD ["/start.sh"]
