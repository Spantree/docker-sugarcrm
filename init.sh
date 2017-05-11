#!/bin/bash

set -e

if [ -z "$DB_HOST_NAME" ]; then
	export DB_HOST_NAME=$DB_PORT_3306_TCP_ADDR
fi

if [ -z "$DB_TCP_PORT" ]; then
	export DB_TCP_PORT=$DB_PORT_3306_TCP_PORT
fi

if [ -z "$DB_USER_NAME" ]; then
	export DB_USER_NAME=$DB_ENV_MYSQL_USER
fi

if [ -z "$DB_PASSWORD" ]; then
	export DB_PASSWORD=$DB_ENV_MYSQL_PASSWORD
fi

if [ -z "$DATABASE_NAME" ]; then
	export DATABASE_NAME=$DB_ENV_MYSQL_DATABASE
fi

/usr/local/bin/envtemplate.py -i /usr/local/src/config_override.php.pyt -o /var/www/html/config_override.php
/usr/sbin/cron

# ULUin
if [ ! -d "$APACHE_RUN_DIR" ]; then
	mkdir "$APACHE_RUN_DIR"
	chown $APACHE_RUN_USER:$APACHE_RUN_GROUP "$APACHE_RUN_DIR"
fi
if [ -f "$APACHE_PID_FILE" ]; then
	rm "$APACHE_PID_FILE"
fi

apachectl -DFOREGROUND
