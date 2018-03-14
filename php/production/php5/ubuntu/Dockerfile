FROM debian:wheezy-slim

RUN apt-get update \
  && apt-get install -y software-properties-common python-software-properties \
  && apt-get update \
  && apt-get install -y \
    wget \
    unzip \
    php5-fpm \
    php5-dev \
    php5-gd \
    php5-ldap \
    php5-mysql \
    php5-mcrypt \
    php5-curl \
    php5-intl \
    php-pear \
    build-essential \
    software-properties-common \
    tmux \
    libsqlite3-dev \
    ruby1.9.1-dev \
  && pear install Net_GeoIP

#Configure php-fpm
RUN sed -i '/daemonize /c \daemonize = no' /etc/php5/fpm/php-fpm.conf \
  && sed -i '/^listen /c \listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf \
  && sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf

# Add additional ini settings.
COPY ./configurations/additional.ini /root/additional.ini
RUN additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
    && cp ~/additional.ini $additionalDir

# Enable and configure ionCube
RUN phpVersion=`php --version | head -n1 | cut -d' ' -f 2 | cut -c -3` \
  && extensionDir=`php -i | grep extension_dir | head -n1 | cut -d' ' -f 5` \
  && additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
  && cd ~ && wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
  && tar xvf ioncube_loaders_lin_x86-64.tar.gz \
  && cp ~/ioncube/ioncube_loader_lin_$phpVersion.so $extensionDir \
  && echo zend_extension=$extensionDir/ioncube_loader_lin_$phpVersion.so > $additionalDir/000-ioncube.ini \
  && rm -rf ~/ioncube*

RUN usermod -u 1000 www-data

EXPOSE 9000

ENTRYPOINT ["php5-fpm"]
