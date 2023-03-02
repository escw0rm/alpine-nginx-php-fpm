FROM alpine:latest

RUN set -x \
    && addgroup --system --gid 101 nginx \
    && adduser -S -G nginx -H -s /sbin/nologin -u 101 -h /nonexistent -g "nginx user" nginx

RUN apk update && apk upgrade \
    && apk add nginx \
    && apk add --no-cache --upgrade bash \
    && apk add php php-fpm php-opcache \
    && apk add php-gd php-mysqli php-zlib php-curl php-mbstring php-intl php-xml php-phar icu-dev php-pdo php-gettext php-session php-pdo_mysql php-sqlite3 php-pdo_sqlite php-dom php-simplexml \
    && mkdir -p /run/nginx

RUN mkdir -p /var/run/nginx /var/log/nginx /var/cache/nginx && \
        chown -R nginx:0 /var/run/nginx /var/log/nginx /var/cache/nginx /var/lib/nginx  && \
        chmod -R g=u /var/run/nginx /var/log/nginx /var/cache/nginx /var/lib/nginx

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

RUN chown -R nginx:nginx /var/www/localhost/htdocs \
    && chmod 755 /var/www/localhost/htdocs

RUN ln -s /dev/stdout /var/log/nginx/access.log \
    && ln -s /dev/stderr /var/log/nginx/error.log \
    && ln -s /dev/stderr /var/log/php81/error.log

EXPOSE 443
EXPOSE 80

ADD .docker/start.sh /
RUN chown nginx:nginx /start.sh

STOPSIGNAL SIGTERM

CMD ["sh", "/start.sh"]
