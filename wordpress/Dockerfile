FROM php:apache-stretch

RUN apt-get update && \
	apt-get install -y libmariadbclient-dev && \
	rm -rf /var/lib/apt/lists/* && \
	docker-php-ext-install mysqli pdo pdo_mysql zip

COPY . .
RUN chown -R www-data:www-data /var/www/html
