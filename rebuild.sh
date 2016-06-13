#!/bin/bash
#Accepts the name of the container (mandatory)  and --no-cache argument (optional) to build image from scratch
#Stop and clean
( docker stop $1 )
( docker rm -v $1 )
#Build and run
( docker build $2 -t byteflair/httpd-multihost . \
&& docker run --name $1 -p 80:80 -p 443:443 -v /etc/apache2 -v /var/www -v /var/log/apache2 -tid byteflair/httpd-multihost )
#Extract location of volumes
echo VOL_SERVER_ROOT=$(docker inspect -f '{{range $a := .Mounts}}{{if eq .Destination "/etc/apache2"}}{{.Source}}{{end}}{{end}}' $1)
echo VOL_DOC_ROOT=$(docker inspect -f '{{range $a := .Mounts}}{{if eq .Destination "/var/www"}}{{.Source}}{{end}}{{end}}' $1)
echo VOL_LOG=$(docker inspect -f '{{range $a := .Mounts}}{{if eq .Destination "/var/log/apache2"}}{{.Source}}{{end}}{{end}}' $1)

