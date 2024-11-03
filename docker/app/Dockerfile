FROM php:8.3-fpm

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN apt-get update \
    && apt-get install -y libpq-dev libxslt1-dev librabbitmq-dev libssl-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql opcache xsl \
    && install-php-extensions xdebug zip amqp

ENV PHP_IDE_CONFIG 'serverName=symfony-sandbox'

COPY ./conf.d /usr/local/etc/php/conf.d

RUN groupadd -g 1000 app && useradd -u 1000 -ms /bin/bash -g app user

WORKDIR /app

USER user