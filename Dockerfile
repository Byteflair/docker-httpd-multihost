FROM ubuntu:15.10

RUN  apt-get update \
  && apt-get upgrade -y --no-install-recommends

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    apache2

ADD apache2 /etc/apache2

EXPOSE 80 443

VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"]

CMD ["-d /etc/apache2"]

ENTRYPOINT ["apache2ctl","-DFOREGROUND"]