#!/bin/sh

# Exit on non defined variables and on non zero exit codes
set -eu

SERVER_ADMIN="${SERVER_ADMIN:-you@example.com}"
HTTP_SERVER_NAME="${HTTP_SERVER_NAME:-www.example.com}"
HTTPS_SERVER_NAME="${HTTPS_SERVER_NAME:-www.example.com}"
LOG_LEVEL="${LOG_LEVEL:-info}"
TZ="${TZ:-UTC}"
PHP_MEMORY_LIMIT="${PHP_MEMORY_LIMIT:-256M}"
HOST_ENV="${HOST_ENV:-Full}"
MAILPIT="${MAILPIT:-enabled}"

echo 'Updating configurations'

# Change Server Admin, Name, Document Root
sed -i "s/ServerAdmin\ you@example.com/ServerAdmin\ ${SERVER_ADMIN}/" /etc/apache2/httpd.conf
sed -i "s/#ServerName\ www.example.com:80/ServerName\ ${HTTP_SERVER_NAME}/" /etc/apache2/httpd.conf
sed -i 's#^DocumentRoot ".*#DocumentRoot "/htdocs"#g' /etc/apache2/httpd.conf
sed -i 's#Directory "/var/www/localhost/htdocs"#Directory "/htdocs"#g' /etc/apache2/httpd.conf
sed -i 's#AllowOverride None#AllowOverride All#' /etc/apache2/httpd.conf

# Change TransferLog after ErrorLog
sed -i 's#^ErrorLog .*#ErrorLog "/dev/stderr"\nTransferLog "/dev/stdout"#g' /etc/apache2/httpd.conf
sed -i 's#CustomLog .* combined#CustomLog "/dev/stdout" combined#g' /etc/apache2/httpd.conf

# SSL DocumentRoot and Log locations
sed -i 's#^ErrorLog .*#ErrorLog "/dev/stderr"#g' /etc/apache2/conf.d/ssl.conf
sed -i 's#^TransferLog .*#TransferLog "/dev/stdout"#g' /etc/apache2/conf.d/ssl.conf
sed -i 's#^DocumentRoot ".*#DocumentRoot "/htdocs"#g' /etc/apache2/conf.d/ssl.conf
sed -i "s/ServerAdmin\ you@example.com/ServerAdmin\ ${SERVER_ADMIN}/" /etc/apache2/conf.d/ssl.conf
sed -i "s/ServerName\ www.example.com:443/ServerName\ ${HTTPS_SERVER_NAME}/" /etc/apache2/conf.d/ssl.conf

# Re-define LogLevel
sed -i "s#^LogLevel .*#LogLevel ${LOG_LEVEL}#g" /etc/apache2/httpd.conf

# Enable commonly used apache modules
sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ deflate_module/LoadModule\ deflate_module/' /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ expires_module/LoadModule\ expires_module/' /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/'   /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ deflate_module/LoadModule\ deflate_module/'   /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ expires_module/LoadModule\ expires_module/'   /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ brotli_module/LoadModule\ brotli_module/'     /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ request_module/LoadModule\ request_module/'   /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ remoteip_module/LoadModule\ remoteip_module/' /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ session_module/LoadModule\ session_module/'   /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ proxy_module/LoadModule\ proxy_module/'                     /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ proxy_http_module/LoadModule\ proxy_http_module/'           /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ proxy_balancer_module/LoadModule\ proxy_balancer_module/'   /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ proxy_wstunnel_module/LoadModule\ proxy_wstunnel_module/'   /etc/apache2/httpd.conf

# Modify php memory limit and timezone
sed -i "s/memory_limit = .*/memory_limit = ${PHP_MEMORY_LIMIT}/" /etc/php83/php.ini
sed -i "s#^;date.timezone =\$#date.timezone = \"${TZ}\"#" /etc/php83/php.ini

# Set HOST ENV
sed -i 's/^ServerTokens Full/ServerTokens ${HOST_ENV}/' /etc/apache2/httpd.conf
sed -i 's/^ServerSignature Off/ServerSignature On/' /etc/apache2/httpd.conf

echo 'mailpit is' ${MAILPIT}
# if [${MAILPIT} == "enabled" ]
# then
  service mailpit start
# else
#   echo 'mailpit is not enabled'
# fi

echo 'Running Apache'
httpd -D FOREGROUND
