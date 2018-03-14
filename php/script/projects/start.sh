#!/bin/bash

if [ -d $PROJECT_FOLDER/.git ]; then
    cd $PROJECT_FOLDER && git pull \
        && chown www-data:www-data  -R * \
        && find . -type d -exec chmod 755 {} \; \
        && find . -type f -exec chmod 644 {} \;
    # Start the php-fpm service
    /usr/local/sbin/php-fpm
    exit
fi

git clone $GIT_REPO

# Apply backup.
echo
for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.tar)    echo "$0: running $f"; tar -xvf "$f"; echo ;;
        *.tar.gz)    echo "$0: running $f"; tar -xzvf "$f"; echo ;;
        *.tar.bz2)    echo "$0: running $f"; tar -xjvf "$f"; echo ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done

chown www-data:www-data  -R * \
    && find . -type d -exec chmod 755 {} \; \
    && find . -type f -exec chmod 644 {} \;

# Start the php-fpm service
/usr/local/sbin/php-fpm
