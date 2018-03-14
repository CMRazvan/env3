FROM magarusu/php:production-ubuntu

RUN apt-get update && pecl install xdebug-2.2.7

# Enable and configure xdebug
# sudo iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
COPY ./configurations/xdebug.ini /root/xdebug.ini
RUN extensionDir=`php -i | grep extension_dir | head -n1 | cut -d' ' -f 5` \
    && additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
    && remoteHost=`/sbin/ip route|awk '/default/ { print $3 }'` \
    && echo [xdebug] > $additionalDir/xdebug.ini \
    && echo zend_extension=$extensionDir/xdebug.so >> $additionalDir/xdebug.ini \
    && cat ~/xdebug.ini >> $additionalDir/xdebug.ini \
    && echo xdebug.remote_host=$remoteHost >> $additionalDir/xdebug.ini \
    && rm -rf ~/xdebug.ini

# Install PHPUnit
RUN cd ~ && wget https://phar.phpunit.de/phpunit-4.8.0.phar \
    && chmod +x phpunit-4.8.0.phar \
    && mv phpunit-4.8.0.phar /usr/local/bin/phpunit

# Install sendmail for mailcatcher
RUN apt-get install -y ssmtp \
  && additionalDir=`php -i | grep additional | head -n1 | cut -d' ' -f 9` \
  && echo "sendmail_path = /usr/sbin/ssmtp -t" > $additionalDir/sendmail.ini \
  && echo "mailhub=mailcatcher:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

ENTRYPOINT ["php5-fpm"]
