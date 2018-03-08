FROM combro2k/alpine-nginx-php5

# install dependencies and build the project
RUN apk --no-cache add php5 php5-fpm php5-mysqli php5-json php5-openssl php5-curl \
        php5-zlib php5-xml php5-phar php5-intl php5-dom php5-xmlreader php5-ctype \
        php5-gd php5-mcrypt php5-pdo php5-pdo_sqlite
#
# copy sources
WORKDIR /data/web
ADD . /data/web

# build the project
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=. --filename=composer && \
    ./composer install -o && \
    rm -rf composer-setup.php composer

# setup php and application
RUN echo -e "#!/usr/bin/with-contenv sh\nenv > /data/web/.env" > /etc/cont-init.d/app-env && \
    chmod 0755 /etc/cont-init.d/app-env && \
    sed -i 's/^short_open_tag = Off/short_open_tag = On/' /etc/php5/php.ini

ENV APP_ENV=local \
    APP_DEBUG=true \
    APP_KEY=4pedijLQD6AJHYaJTgqcKiK0UaqVu0T6 \
    DB_CONNECTION=sqlite \
    DB_HOST= \
    DB_DATABASE= \
    DB_USERNAME= \
    DB_PASSWORD=\
    DB_PORT= \
    VIEW_CACHE=false \
    CACHE_DRIVER=file \
    SESSION_DRIVER=file
