#
# Docker MySQL HTTPD
#
# Commands for examples:
#      docker search mariadb
#      docker pull mariadb:latest
#      docker images
#      docker ps -a
#      docker push mariadb:myset
#      docker build --tag mariadb:myset -f ./Dockerfile
#      docker run [-it] -p 33061:3306 --name mymariadb --hostname mymariadb mariadb:myset
#      docker run -e MARIADB_ROOT_PASSWORD=123456 -p 3306:3306 --name mymariadb --hostname mymariadb mariadb:latest
#      docker create -v /home/docker:/docker --name mymariadb --hostname mymariadb mariadb:myset
#      docker container start container_name  # mymariadb
#      docker container stop container_name   # mymariadb
#      docker container ls
#      docker exec -it mymariadb /bin/bash
#      docker rm 02s02d202    # docker rm mymariadb
#      docker rmi mariadb:latest
#      docker volume ls
#      docker logs 02s02d202  # docker logs mymariadb
#      docker container inspect mariadbmy
#      docker image inspect mariadb
#



FROM    fedora:latest
MAINTAINER MG <makgab@gmail.com>


RUN dnf -y update

RUN dnf -y install supervisor tar wget git mysql-server httpd pwgen python-setuptools vim php php-dom php-gd memcached php-pecl-memcache php-pear-Console-Table procps mc


# Make mysql listen on the outside
RUN sed -i "s/^bind-address/#bind-address/" /etc/my.cnf

# ADD
ADD supervisord /etc/supervisord.conf
ADD dbscript.sh /tmp/dbscript.sh 

# RUN
RUN chmod 775 /tmp/dbscript.sh
RUN mariadb-install-db
# RUN /tmp/dbscript.sh drupaldb drupal drupal
RUN mkdir /run/php-fpm; touch /run/php-fpm/www.sock; chmod 777 /run/php-fpm; chmod 666 /run/php-fpm/www.sock

# Expose port(s)
EXPOSE 80


# CMD, ENTRYPOINT
# /usr/sbin/mariadbd -u root
# /usr/sbin/httpd -DFOREGROUND
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf
