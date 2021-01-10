FROM centos:8

RUN yum update -y
RUN yum install -y \
    epel-release \
    yum-utils \
    python2 \
    python3 \
    zip

#Install Nginx 1.18
RUN yum module reset nginx -y && \
    yum module enable nginx:1.18 -y
RUN yum install -y nginx
ADD nginx.conf /etc/nginx/nginx.conf

#Install Php 7.4
RUN yum module reset php -y && \
    yum module enable php:7.4 -y
RUN yum install -y \
    php \
    php-bcmath
ADD php-fpm.conf /etc/php-fpm.d/www.conf
RUN mkdir /run/php-fpm

#Install Composer 2.0.8
ADD composer.phar /usr/local/bin/composer

#Install Nodejs 14
RUN yum module reset nodejs -y && \
    yum module enable nodejs:14 -y
RUN yum install -y nodejs

#Install Supervisor 4.2.1
RUN pip2 install supervisor==4.2.1
ADD supervisord.conf /etc/supervisord.conf

#Clean
RUN yum clean all

#Make space work
RUN mkdir /var/www/web
WORKDIR /var/www/web

COPY index.php /var/www/web

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n"]