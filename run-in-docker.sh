#!/bin/sh

case "$1" in
    "dev")
        docker build -t ez .
        docker rm -f ez || true
        docker run --name ez --rm -p 8888:80 -v `pwd`:/data/web ez &
        sleep 10
        docker exec ez php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        docker exec ez php composer-setup.php --install-dir=. --filename=composer
        docker exec ./composer install -o
        ;;
    "sh")
        docker exec -it $(docker ps | grep ez | cut -f 1 -d ' ') sh
        ;;
    "mysql")
        docker run -d --name mysql \
            -e MYSQL_ROOT_PASSWORD=secret123 \
            -e MYSQL_DATABASE=estatezilla \
            -e MYSQL_USER=estatezilla \
            -e MYSQL_PASSWORD=secret123 \
            -p 3306:3306 \
            mysql:5.7
        ;;
    *)
        docker build -t ez .
        docker run -it --rm -p 8888:80 -v `pwd`/storage/db:/data/web/storage/db ez
        ;;
esac
