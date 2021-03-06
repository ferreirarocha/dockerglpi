FROM ubuntu:16.04
LABEL maintainer="marcos.fr.rocha@gmail.com"

ENV GLPI_VERSION 9.2.2
                                                      
ENV PATH="/opt/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
            
RUN apt update  && apt  install -y \
 	php7.0 	\
	php7.0-xml \
	php7.0-bcmath \ 
	php7.0-imap \ 
	php-soap \ 
	php7.0-cli \ 	
	php7.0-common \
	php7.0-snmp 	\
	php7.0-xmlrpc 	\
	php7.0-gd 	\
	php7.0-ldap 	\
	libapache2-mod-php7.0 	\
	php7.0-curl 	\
	php7.0-mbstring 	\
	php7.0-mysql 	\
	php-dev 	\
	php-pear 	\
	apache2 \
	unzip \
	curl \
	snmp \
	nano \
	wget \
	cron \
	vim   \
&& rm -rf /var/lib/apt/lists/*


RUN 	echo "no" | pecl install apcu_bc-beta  && 	echo "[apcu]\nextension=apcu.so\nextension=apc.so\n\napc.enabled=1" > /etc/php/7.0/apache2/php.ini  


RUN printf '<VirtualHost *:80>\n\
	DocumentRoot /var/www/html/glpi\n\
	<Directory /var/www/html/glpi>\n\
	AllowOverride All \n\
	Order Allow,Deny\n\
	Allow from all \n\
	</Directory> \n\
	ErrorLog /var/log/apache2/error-glpi.log\n\
	LogLevel warn \n\
	CustomLog /var/log/apache2/access-glpi.log combined \n\
</VirtualHost> '\
>> /etc/apache2/conf-available/glpi.conf



RUN	a2enconf glpi.conf
RUN	echo "*/5 * * * * /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null"  > /var/spool/cron/crontabs/root
##  Criando script para executar o apache, mariaDB e o bash no boot do container
RUN echo ' \n#!/bin/bash \n/etc/init.d/mysql start \n/etc/init.d/apache2 start \n/bin/bash' > /usr/bin/glpi
RUN chmod +x /usr/bin/glpi

## Definindo a porta de acesso ao serviço
EXPOSE 80


ADD  https://github.com/glpi-project/glpi/releases/download/9.2.2/glpi-9.2.2.tgz  ./
ADD  https://forge.glpi-project.org/attachments/download/2216/GLPI-dashboard_plugin-0.9.0_GLPI-9.2.x.tar.gz ./
RUN	tar -xzf  glpi-9.2.2.tgz -C /var/www/html  && 	tar xfz GLPI-dashboard_plugin-0.9.0_GLPI-9.2.x.tar.gz -C  /var/www/html/glpi/plugins/ 	&& chmod 775 -Rf /var/www/html/glpi  	&& chown www-data. -Rf /var/www/html/glpi



## Definindo o scrit para executar no boot do container
CMD /usr/bin/glpi
 
#CMD ["/usr/sbin/apachectl", "-DFOREGROUND"]

CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["apachectl"]
