FROM ubuntu:15.10

RUN  apt-get update \
  && apt-get upgrade -y --no-install-recommends

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    apache2

RUN rm -Rf /var/www/html \
 && rm -f /apache2/sites-enabled/000-defualt.conf \
 && rm -f /apache2/sites-available/000-defualt.conf

ADD apache2 /etc/apache2
ADD www /var/www

RUN chmod -R 755 /var/www

EXPOSE 80 443

VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"]

CMD ["-d /etc/apache2"]

ENTRYPOINT ["apache2ctl","-DFOREGROUND"]