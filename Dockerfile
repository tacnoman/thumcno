FROM php:7.0.12-fpm
MAINTAINER Tacnoman renatocassino@gmail.com

# Install wget and install/updates certificates
RUN apt-get update
RUN apt-get install -y wget build-essential
RUN apt-get install -y libfcgi-dev libfcgi0ldbl libjpeg62-turbo-dbg libmcrypt-dev libssl-dev libc-client2007e libc-client2007e-dev libxml2-dev libbz2-dev libcurl4-openssl-dev libjpeg-dev libpng12-dev libfreetype6-dev libkrb5-dev libpq-dev libxml2-dev libxslt1-dev libjpeg62-turbo-dev

# PHP-GD
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# Install Nginx
RUN apt-get install -y nginx
RUN service nginx start

# Install composer
RUN wget https://getcomposer.org/composer.phar
RUN mv ./composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# Install git
RUN apt-get install -y git

# Clone thumcno
RUN cd / && git clone https://github.com/tacnoman/thumcno app --branch tests

# Configuring thumcno
RUN cd /app && composer install
RUN mkdir -p /app/cache
RUN echo "PERMIT_ONLY_DOMAIN=0" >> /app/.env
WORKDIR /app

EXPOSE 8888

CMD ["php", "index.php", "-S", "0.0.0.0:8888"]
