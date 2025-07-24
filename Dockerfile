FROM php:8.3-cli

WORKDIR /app

COPY --chown=www-data:www-data . /app

RUN apt update && apt install -y \
    zip \
    libzip-dev \
    libpq-dev \
    unzip \
    curl \
    git && \
    docker-php-ext-install zip pcntl pdo_pgsql pgsql && \
    docker-php-ext-enable zip

COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

RUN composer install && \
    composer require laravel/octane && \
    php artisan octane:install --server=frankenphp

EXPOSE 8000

CMD php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=8000