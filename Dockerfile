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
        php8.3-fpm \
        php8.3-zip \
        unzip

    WORKDIR /tmp

    RUN curl -vvv --trace-config ssl,tcp https://dotnet.microsoft.com/

    # run a simple test trying to reproduce (unsuccessfully) the issue triggered below
    COPY files/test.php /tmp/test.php
    RUN php /tmp/test.php
    RUN cat /tmp/body.txt
    
    # install composer but extract it as well so we can patch it
    COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
    RUN cp /usr/bin/composer /composer.phar
    RUN mkdir /out/
    RUN php -r '$phar = new Phar("/composer.phar"); $phar->extractTo("/out/");'

    # patch 'CurlDownloader.php' so debug information is printed when downloading resources
    COPY files/CurlDownloader.php /out/src/Composer/Util/Http/CurlDownloader.php

    # load a standard set of dependencies that we want composore to install
    COPY files/composer.json /tmp/composer.json

    # configure
    RUN php /out/bin/composer config --no-interaction allow-plugins.composer/installers true
    RUN php /out/bin/composer config --no-interaction secure-http false

    # installl
    RUN php /out/bin/composer install -vvvvv --ignore-platform-reqs 

    # just an entrypoint in case the build succeeds
    ENTRYPOINT ["tail", "-f", "/dev/null"]
