FROM php:5.6-apache-jessie

ENV MAJOR_VERSION 6.5
ENV MINOR_VERSION 26
ENV SOURCEFORGE_MIRROR http://downloads.sourceforge.net
ENV WWW_FOLDER /var/www/html
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y libcurl4-gnutls-dev libpng-dev unzip cron re2c python curl libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*

WORKDIR /tmp

RUN curl -v -L -O "https://sourceforge.net/projects/sugarcrm/files/OldFiles/1%20-%20SugarCRM%20${MAJOR_VERSION}.X/SugarCommunityEdition-${MAJOR_VERSION}.X/SugarCE-${MAJOR_VERSION}.${MINOR_VERSION}.zip" &&\
      md5sum SugarCE-${MAJOR_VERSION}.${MINOR_VERSION}.zip >/dev/stderr && unzip SugarCE-${MAJOR_VERSION}.${MINOR_VERSION}.zip && \
	rm -rf ${WWW_FOLDER}/* && \
	cp -R /tmp/SugarCE-Full-${MAJOR_VERSION}.${MINOR_VERSION}/* ${WWW_FOLDER}/ && \
	chown -R www-data:www-data ${WWW_FOLDER}/* && \
	chown -R www-data:www-data ${WWW_FOLDER}

# RUN sed -i 's/^upload_max_filesize = 2M$/upload_max_filesize = 10M/' /usr/local/etc/php/php.ini

COPY docker-php-ext-filesize.ini /usr/local/etc/php/conf.d/docker-php-ext-filesize.ini

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap mysql zip gd

ADD config_override.php.pyt /usr/local/src/config_override.php.pyt
ADD envtemplate.py /usr/local/bin/envtemplate.py
ADD init.sh /usr/local/bin/init.sh

RUN chmod u+x /usr/local/bin/init.sh

ADD crons.conf /root/crons.conf
RUN crontab /root/crons.conf
EXPOSE 80
ENTRYPOINT ["/usr/local/bin/init.sh"]
