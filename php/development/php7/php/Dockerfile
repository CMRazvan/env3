FROM magarusu/php
MAINTAINER Magarusu

# Enable and configure xdebug
# sudo iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
COPY ./configurations/xdebug.ini /root/xdebug.ini
RUN pecl install xdebug && docker-php-ext-enable xdebug \
    && extensionDir=`php -i | grep extension_dir | head -n1 | cut -d' ' -f 5` \
    && additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
    && remoteHost=`/sbin/ip route|awk '/default/ { print $3 }'` \
    && echo [xdebug] > $additionalDir/xdebug.ini \
    && cat ~/xdebug.ini >> $additionalDir/xdebug.ini \
    && echo xdebug.remote_host=$remoteHost >> $additionalDir/xdebug.ini \
    && rm -rf ~/xdebug.ini
