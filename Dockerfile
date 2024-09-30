FROM alpine:3.20
LABEL maintainer="xaryna@gmail.com"
LABEL description="Alpine based image with apache2 and php8.3 based on eriksoderblom/alpine-apache-php"

# Setup apache and php
RUN apk --no-cache --update \
    add apache2 apache2-ssl apache2-brotli apache2-proxy apache2-proxy-html \
        curl openrc nano \
        php83-apache2 php83-bcmath php83-bz2 php83-calendar php83-common php83-ctype php83-curl php83-dom php83-fileinfo php83-gd php83-gmp php83-iconv php83-mbstring php83-mysqli php83-mysqlnd php83-openssl php83-pdo php83-pdo_odbc php83-pdo_mysql php83-pdo_pgsql php83-pdo_sqlite php83-phar php83-session php83-sqlite3 php83-xml php83-tidy php83-zip php83-simplexml \    
    && mkdir /htdocs
RUN wget https://github.com/axllent/mailpit/releases/download/v1.20.5/mailpit-linux-amd64.tar.gz \
    && tar -xvzf mailpit-linux-amd64.tar.gz -C /usr/local/bin \
    && mkdir /var/lib/mailpit
RUN wget https://raw.githubusercontent.com/xaryna19/alpine-apache-php-mailpit/refs/heads/main/mailpit -P /etc/init.d/ \
    && wget https://raw.githubusercontent.com/xaryna19/alpine-apache-php-mailpit/refs/heads/main/mailpit.sh -P /usr/local/bin/ \
    && chmod +x /usr/local/bin/mailpit.sh \
    && chmod +x /etc/init.d/mailpit \
    && openrc default \
    && rc-update add mailpit default

EXPOSE 80 443 8025

ADD docker-entrypoint.sh /

HEALTHCHECK CMD wget -q --no-cache --spider localhost

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
