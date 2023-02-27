FROM alpine:latest

RUN apk update && apk upgrade

RUN apk add nginx

RUN apk add --no-cache --upgrade bash

RUN apk add php php-fpm php-opcache

RUN apk add php-gd php-mysqli php-zlib php-curl php-mbstring php-intl php-xml

RUN mkdir -p /run/nginx

COPY .docker/default.conf /etc/nginx/http.d/default.conf

COPY .docker/index.php /var/www/localhost/htdocs/index.php

RUN chown -R nginx:nginx /var/www/localhost/htdocs
RUN chmod 755 /var/www/localhost/htdocs

EXPOSE 80

ADD .docker/start.sh /
RUN chown nginx:nginx /start.sh
CMD ["sh", "/start.sh"]
