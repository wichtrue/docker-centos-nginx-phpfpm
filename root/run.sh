#!/bin/bash
#. /opt/bitnami/base/functions
#. /opt/bitnami/base/helpers

DAEMON=php-fpm
EXEC=$(which $DAEMON)
ARGS="-F --pid /opt/php-fpm.pid --fpm-config /etc/php-fpm.conf --prefix /usr/lib64/php -c /etc/php.ini"

if [ -f composer.json  ]; then
  composer install
fi

#chown -R :daemon /usr/lib64/php || true

# redirect php logs to stdout
ln -sf /dev/stdout /var/log/php-fpm/error.log

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}

# Start the first process
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start php-fpm_process: $status"
  exit $status
fi

# Start the second process
./nginx -g "daemon off;"
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx_process: $status"
  exit $status
fi
