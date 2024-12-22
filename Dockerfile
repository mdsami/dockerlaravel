FROM php:8.2-fpm-alpine

WORKDIR /var/www/html

# Update and install dependencies
# Update and install dependencies
RUN apk update && apk add --no-cache \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    icu-dev \
    gmp-dev \
    imap-dev \
    openssl-dev \
    libxslt-dev \
    gd-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    freetype-dev \
    libsodium-dev \
    oniguruma-dev  \
    linux-headers \
    zlib-dev \
    libzip-dev \
    pkgconfig \
    curl-dev \
    gettext-dev

# Configure and install GD separately
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo_mysql

#Install PHP extensions individually with verbose logging
# RUN docker-php-ext-install -j$(nproc) intl
# RUN docker-php-ext-install -j$(nproc) pdo_mysql
# RUN docker-php-ext-install -j$(nproc) sodium
# RUN docker-php-ext-install -j$(nproc) gmp
# RUN docker-php-ext-install -j$(nproc) mbstring
# RUN docker-php-ext-install -j$(nproc) soap
# RUN docker-php-ext-install -j$(nproc) sockets
# RUN docker-php-ext-install -j$(nproc) xsl
# RUN docker-php-ext-install -j$(nproc) zip
# RUN docker-php-ext-install -j$(nproc) curl
# RUN docker-php-ext-install -j$(nproc) gettext
# RUN docker-php-ext-install -j$(nproc) exif
# RUN docker-php-ext-install -j$(nproc) fileinfo
# RUN docker-php-ext-install -j$(nproc) opcache

# Install nodejs and npm
RUN apk --no-cache add nodejs npm

# Copy Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

USER root

# Ensure the vendor directory exists and set permissions
RUN chmod 777 -R /var/www/html

RUN chmod 777 -R /var/www/html/vendor

# Ensure proper permissions for the storage and bootstrap cache directories
#RUN chmod -R 777 storage bootstrap/cache

# Run Laravel migrations
CMD php artisan migrate --force && php-fpm