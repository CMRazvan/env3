FROM php:5.6-fpm
MAINTAINER Magarusu

# Install php required libraries.
RUN requirements="git libpng12-dev libfreetype6-dev libjpeg-dev libjpeg62-turbo libmcrypt4 libmcrypt-dev libcurl3-dev libxml2-dev libxslt-dev libicu-dev libicu52 zlib1g-dev" \
    && apt-get update && apt-get install -y $requirements && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install soap \
    && docker-php-ext-install intl \
    && docker-php-ext-install zip \
    && requirementsToRemove="libpng12-dev libjpeg-dev libmcrypt-dev libcurl3-dev libxml2-dev libxslt-dev libicu-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove

# Add additional ini settings.
COPY ./configurations/additional.ini /root/additional.ini
RUN additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
    && cp ~/additional.ini $additionalDir

RUN usermod -u 1000 www-data \
    && chown -R www-data:www-data /var/www/html
