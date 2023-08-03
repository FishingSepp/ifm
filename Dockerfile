FROM php:7.4-apache
RUN a2enmod rewrite
COPY ./index.php /var/www/html
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

USER root
