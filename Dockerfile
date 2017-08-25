FROM ubuntu:xenial
MAINTAINER pcxd

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        ssmtp \
        curl \
        apache2 \
        libapache2-mod-php7.0 \
        php7.0-mysql \
        php7.0-mcrypt \
        php7.0-gd \
        php7.0-curl \
        php-pear \
        php-apcu && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN /usr/sbin/phpenmod mcrypt
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php/7.0/apache2/php.ini

ENV ALLOW_OVERRIDE **False**

ADD ssmtp.conf /etc/ssmtp/ssmtp.conf
ADD php-smtp.ini /usr/local/etc/php/conf.d/php-smtp.ini

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
ADD sample/ /app

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
