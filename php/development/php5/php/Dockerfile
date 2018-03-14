FROM magarusu/php:production-php5
MAINTAINER Magarusu

# Enable and configure xdebug
# sudo iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
COPY ./configurations/xdebug.ini /root/xdebug.ini
RUN pecl install xdebug && docker-php-ext-enable xdebug \
    && extensionDir=`php -i | grep extension_dir | head -n1 | cut -d' ' -f 5` \
    && additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
    && remoteHost=`/sbin/ip route|awk '/default/ { print $3 }'` \
    && echo [xdebug] > $additionalDir/xdebug.ini \
    && echo zend_extension=$extensionDir/xdebug.so >> $additionalDir/xdebug.ini \
    && cat ~/xdebug.ini >> $additionalDir/xdebug.ini \
    && echo xdebug.remote_host=$remoteHost >> $additionalDir/xdebug.ini \
    && rm -rf ~/xdebug.ini

# Install PHPUnit
RUN apt-get update && apt-get install -y wget \
    && cd ~ && wget https://phar.phpunit.de/phpunit-4.8.0.phar \
    && chmod +x phpunit-4.8.0.phar \
    && mv phpunit-4.8.0.phar /usr/local/bin/phpunit

# Enable and configure ionCube
RUN phpVersion=`php --version | head -n1 | cut -d' ' -f 2 | cut -c -3` \
  && extensionDir=`php -i | grep extension_dir | head -n1 | cut -d' ' -f 5` \
  && additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
  && cd ~ && wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
  && tar xvf ioncube_loaders_lin_x86-64.tar.gz \
  && cp ~/ioncube/ioncube_loader_lin_$phpVersion.so $extensionDir \
  && echo zend_extension=$extensionDir/ioncube_loader_lin_$phpVersion.so > $additionalDir/000-ioncube.ini \
  && rm -rf ~/ioncube*

# Install sendmail for mailcatcher
RUN apt-get install -y ssmtp \
  && additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
  && echo "sendmail_path = /usr/sbin/ssmtp -t" > $additionalDir/sendmail.ini \
  && echo "mailhub=mailcatcher:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf
