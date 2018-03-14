#!/bin/sh

# Add localhost to host for cURL functional tests.
/sbin/ip route|awk '/default/ { printf("%s\t'$MAGENTO_HOST_URL'\n", $3)}' | sudo tee -a /etc/hosts

sudo chown php:www-data -R /home/php

if [ -f $MAGENTO_FOLDER/app/etc/config.php ] || [ -f $MAGENTO_FOLDER/app/etc/env.php ]; then
  echo "Already installed? Either app/etc/config.php or app/etc/env.php exist, please remove both files to continue setup."
  # Start the php-fpm service
  /usr/local/sbin/php-fpm
  exit
fi

sudo chown php:www-data -R /var/www/html/magento2

composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition $MAGENTO_FOLDER

chmod +x $MAGENTO_FOLDER/bin/magento

if [ "$USE_SAMPLE_DATA" = true ]; then
  mkdir -p $MAGENTO_FOLDER/var/composer_home/ \
    && cp /home/php/.composer/auth.json $MAGENTO_FOLDER/var/composer_home/auth.json
  echo "Installing composer dependencies..."
  $MAGENTO_FOLDER/bin/magento sampledata:deploy

  echo "Ignore the above error (bug in Magento), fixing with 'composer update'..."
  cd $MAGENTO_FOLDER
  composer update

  USE_SAMPLE_DATA_STRING="--use-sample-data"
else
  USE_SAMPLE_DATA_STRING=""
fi

echo "Running Magento 2 setup script..."
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
  $USE_SAMPLE_DATA_STRING

echo "Reindexing all indexes..."
$MAGENTO_FOLDER/bin/magento indexer:reindex

#echo "Fix static content"
#$MAGENTO_FOLDER/bin/magento setup:static-content:deploy && $MAGENTO_FOLDER/bin/magento catalog:images:resize

echo "Install Magento Test Framework"
cd $MAGENTO_FOLDER/dev/tests/functional/
composer install
cd $MAGENTO_FOLDER/dev/tests/functional/utils
php generate.php

echo "Applying ownership & proper permissions..."
sed -i 's/0770/0775/g' $MAGENTO_FOLDER/vendor/magento/framework/Filesystem/DriverInterface.php
sed -i 's/0660/0664/g' $MAGENTO_FOLDER/vendor/magento/framework/Filesystem/DriverInterface.php
find $MAGENTO_FOLDER/pub -type f -exec chmod 664 {} \;
find $MAGENTO_FOLDER/pub -type d -exec chmod 775 {} \;
find $MAGENTO_FOLDER/var/generation -type d -exec chmod g+s {} \;

echo "The setup script has completed execution."

# Start the php-fpm service
/usr/local/sbin/php-fpm
