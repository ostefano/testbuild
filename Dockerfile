ARG DOCKER_HUB_PROXY=""

FROM "${DOCKER_HUB_PROXY}ubuntu:24.04" as composer-build
    ENV DEBIAN_FRONTEND noninteractive
    ENV COMPOSER_ALLOW_SUPERUSER 1
    ENV COMPOSER_IPRESOLVE 4

    RUN apt-get update; apt-get install -y --no-install-recommends \
        ca-certificates \
        php8.3 \
        php8.3-apcu \
        php8.3-curl \
        php8.3-xml \
        php8.3-intl \
        php8.3-bcmath \
        php8.3-mbstring \
        php8.3-mysql \
        php8.3-redis \
        php8.3-gd \
        php8.3-fpm \
        php8.3-zip \
        unzip

    WORKDIR /tmp
    
    COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
    RUN cp /usr/bin/composer /composer.phar
    RUN mkdir /out/
    RUN php -r '$phar = new Phar("/composer.phar"); $phar->extractTo("/out/");'

    COPY files/CurlDownloader.php /out/src/Composer/Util/Http/CurlDownloader.php
    COPY files/composer.json /tmp/composer.json

    RUN php /out/bin/composer config --no-interaction allow-plugins.composer/installers true
    RUN php /out/bin/composer config --no-interaction secure-http false
    RUN php /out/bin/composer install -vvvvv --ignore-platform-reqs 

    ENTRYPOINT ["tail", "-f", "/dev/null"]
