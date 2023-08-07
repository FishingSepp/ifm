FROM ubuntu:20.04

ENV HTTP_PROXY=http://sia-lb.telekom.de:8080
ENV HTTPS_PROXY=http://sia-lb.telekom.de:8080
ENV http_proxy=http://sia-lb.telekom.de:8080
ENV https_proxy=http://sia-lb.telekom.de:8080
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt-get update
RUN apt-get install curl -y
RUN ["curl", "https://archive.apache.org/dist/httpd/httpd-2.4.57.tar.gz", "--output", "httpd-2.4.57.tar.gz"]
RUN ["gzip", "-d", "httpd-2.4.57.tar.gz"]
RUN ["tar", "xvf", "httpd-2.4.57.tar"]
ENV CFLAGS="-DBIG_SECURITY_HOLE"
ENV DEB_CFLAGS_SET="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -DBIG_SECURITY_HOLE"
WORKDIR /httpd-2.4.57
RUN apt-get install build-essential -y
RUN apt-get install libapr1-dev libaprutil1-dev libpcre3-dev -y
RUN ./configure --prefix=/usr/bin/apache2 --with-mpm=prefork
RUN make
RUN make install
EXPOSE 80
RUN apt-get update
RUN apt install libapache2-mod-php7.4 -y
RUN chown -R root /var/www/
RUN chgrp -R root /var/www/
COPY ./index.php /var/www/html
COPY ./httpd.conf /usr/bin/apache2/conf
RUN cp /usr/lib/apache2/modules/libphp7.4.so /usr/bin/apache2/modules/
RUN cp /usr/lib/apache2/modules/mod_mpm_prefork.so /usr/bin/apache2/modules/
RUN /usr/bin/apache2/bin/apachectl -k graceful
CMD ["/usr/bin/apache2/bin/apachectl", "-D", "FOREGROUND"]


