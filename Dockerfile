FROM centos:7
LABEL vendor="True Voice"
MAINTAINER Warawich Sureepitak <warawich@gmail.com>

# Add install scripts needed by the next RUN command
COPY container-files/etc/yum.repos.d/* /etc/yum.repos.d/
COPY container-files/etc/pki/rpm-gpg/* /etc/pki/rpm-gpg/
 

RUN yum update -y 
#RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
RUN yum install -y  git curl vim
RUN cd ~
RUN curl 'https://setup.ius.io/' -o setup-ius.sh 
RUN bash setup-ius.sh
RUN yum install -y php71u-fpm php71u-fpm-nginx php71u-mysqlnd php71u-common php71u-cli nginx mariadb   

#Php-fpm edit config 	
RUN sed -i -e"s/user = php-fpm/user = nginx/g" /etc/php-fpm.d/www.conf
RUN sed -i -e"s/group = php-fpm/group = nginx/g" /etc/php-fpm.d/www.conf
# Get prefix path and path to scripts rather than hard-code them in scripts
#ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/nginx \
#ENABLED_COLLECTIONS=rh-nginx18

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
#ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
#    ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
#    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/scl_enable"

ADD root /

COPY container-files/etc/nginx/conf.d/virtualhost.conf /etc/nginx/conf.d/virtualhost.conf
RUN mv -v /etc/nginx/conf.d/default.conf  /etc/nginx/conf.d/default.conf_

#VOLUME /var/log/ 
#VOLUME /var/www/html
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html", "/var/log/php-fpm"]

# Expose ports
EXPOSE 80
EXPOSE 443

CMD ["/run.sh"]
#CMD ["nginx", "-g", "daemon off;"]
#CMD ["php-fpm", "-D", "-R"]

#Clean docker images size
RUN yum clean all && rm -rf /tmp/yum*
#CMD systemctl start php-fpm
#CMD systemctl start nginx


