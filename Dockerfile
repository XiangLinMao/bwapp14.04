FROM ubuntu:14.04

MAINTAINER JackMao <j912944946@gmail.com>

ADD sources.list /etc/apt/

RUN apt-get -y update
RUN apt-get -y install php5 php5-mysqlnd mysql-server wget unzip curl supervisor

RUN /etc/init.d/mysql start &&\
    mysql -e "grant all privileges on *.* to 'root'@'localhost' identified by 'bug';"&&\
    mysql -u root -pbug -e "show databases;"

WORKDIR /var/www/html/

COPY ./bwapp.conf /etc/supervisor/conf.d/bwapp.conf

RUN wget http://jaist.dl.sourceforge.net/project/bwapp/bWAPP/bWAPP_latest.zip && unzip bWAPP_latest.zip &&\
    rm /var/www/html/index.html

RUN /etc/init.d/mysql restart && /etc/init.d/apache2 restart &&\
  curl http://127.0.0.1/bWAPP/install.php?install=yes 1>/dev/null

EXPOSE 80

CMD ["/usr/bin/supervisord"]