FROM centos:8

ENV WORK_SPACE=/var/www/web
ENV PORT=80

# Common
RUN yum update -y
RUN yum install -y \
    epel-release \
    yum-utils \
    python2 \
    python3 \
    zip

# Install Nginx 1.18
RUN yum module reset nginx -y && \
    yum module enable nginx:1.18 -y
RUN yum install -y nginx
ADD nginx.conf /etc/nginx/nginx.conf

# Install PHP 7.4
RUN yum module reset php -y && \
    yum module enable php:7.4 -y
RUN yum install -y \
    php \
    php-bcmath \
    php-pdo_mysql
ADD php-fpm.conf /etc/php-fpm.d/www.conf
RUN mkdir /run/php-fpm

# Install Composer 2.0.8
ADD composer.phar /usr/local/bin/composer

# Install Nodejs 14
RUN yum module reset nodejs -y && \
    yum module enable nodejs:14 -y
RUN yum install -y nodejs

# Install Supervisor 4.2.1
RUN pip2 install supervisor==4.2.1
ADD supervisord.conf /etc/supervisord.conf

# Clean all
RUN yum clean all

# Make work space
RUN mkdir $WORK_SPACE
WORKDIR $WORK_SPACE

EXPOSE $PORT

CMD ["/usr/bin/supervisord", "-n"]