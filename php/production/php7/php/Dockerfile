FROM php:7.0-fpm
MAINTAINER Magarusu

RUN apt-get update \
    && apt-get install -y cron \
    git \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev \
    mysql-client \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install xsl \
    && docker-php-ext-install soap \
    && docker-php-ext-install zip

# Add additional ini settings.
COPY ./configurations/additional.ini /root/additional.ini
RUN additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
    && cp ~/additional.ini $additionalDir

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer #--version=1.0.0-alpha11

# Install sendmail for postfix docker and mailcatcher @todo find better way to use it.
RUN apt-get install -y ssmtp \
  && additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
  && echo "sendmail_path = /usr/sbin/ssmtp -t" > $additionalDir/sendmail.ini \
  && echo "mailhub=sendmail:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

# Add sudo.
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

RUN useradd php --shell /bin/bash --groups www-data \
    && echo 'php ALL=(ALL)NOPASSWD:ALL' > /etc/sudoers.d/allow \
    && mkdir -p /home/php/.composer \
    && chown -R php:www-data /home/php \
    && chown -R php:www-data /var/www/html
