FROM alpine:latest

RUN apk update && apk upgrade

RUN apk add nginx

RUN apk add --no-cache --upgrade bash

RUN apk add php php-fpm php-opcache

RUN apk add php-gd php-mysqli php-zlib php-curl php-mbstring php-intl php-xml php-phar icu-dev php-pdo php-gettext php-session php-pdo_mysql php-sqlite3 php-pdo_sqlite php-dom php-simplexml

RUN mkdir -p /run/nginx

COPY .docker/default.conf /etc/nginx/http.d/default.conf

COPY .docker/index.php /var/www/localhost/htdocs/index.php

COPY .docker/php-fpm.conf /etc/php81/php-fpm.conf

COPY .docker/nginx.conf /etc/nginx/nginx.conf

COPY .docker/default.conf /etc/nginx/http.d/default.conf

COPY .docker/dhparam.pem /etc/ssl/certs/dhparam.pem
COPY .docker/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY .docker/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

COPY .docker/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
COPY .docker/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key

RUN chown -R nginx:nginx /var/www/localhost/htdocs
RUN chmod 755 /var/www/localhost/htdocs

EXPOSE 443
EXPOSE 80

ADD .docker/start.sh /
RUN chown nginx:nginx /start.sh
CMD ["sh", "/start.sh"]