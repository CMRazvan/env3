#!/bin/sh

sudo chown php:www-data -R /home/php

if [ -f $MAGENTO_FOLDER/app/etc/config.php ] || [ -f $MAGENTO_FOLDER/app/etc/env.php ]; then
    echo "Run Magento 2!"
    # Start the php-fpm service
    /usr/local/sbin/php-fpm
    exit
fi

sudo chown php:www-data -R /var/www/html/magento2
sudo chown php:www-data -R /var/www/html/magento2-sample-data

# @todo Add ability to set magento version fom yml.
git clone https://github.com/magento/magento2.git \
    && git clone https://github.com/magento/magento2-sample-data \
    && cd $MAGENTO_FOLDER && git checkout tags/2.1.0 -b 2.1.0 \
    && cd ../magento2-sample-data && git checkout tags/2.1.0 -b 2.1.0 \
    && php -f dev/tools/build-sample-data.php -- --ce-source="$MAGENTO_FOLDER" \
    && cd $MAGENTO_FOLDER && chmod u+x bin/magento && composer install

echo "Installing Magento 2..."
$MAGENTO_FOLDER/bin/magento setup:install \
  --db-host=mysql \
  --db-name=$MYSQL_DATABASE \
  --db-user=$MYSQL_USER \
  --db-password=$MYSQL_PASSWORD \
  --base-url=$MAGENTO_BASE_URL \
  --backend-frontname=$MAGENTO_ADMIN_URL \
  --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME \
  --admin-lastname=$MAGENTO_ADMIN_LASTNAME \
  --admin-email=$MAGENTO_ADMIN_EMAIL \
  --admin-user=$MAGENTO_ADMIN_USER \
  --admin-password=$MAGENTO_ADMIN_PASS \
  --use-sample-data

echo "Reindexing..."
$MAGENTO_FOLDER/bin/magento indexer:reindex

cd $MAGENTO_FOLDER \
    && find var vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; \
    && find var vendor pub/static pub/media app/etc -type d -exec chmod g+w {} \; \
    && rm -rf cache/* page_cache/* generation/* \
    && cd .. && find magento2-sample-data -type d -exec chmod g+ws {} \; \

# Start the php-fpm service
/usr/local/sbin/php-fpm
