#!/bin/bash
#Accepts a --no-cache argument to build image from scratch
#Stop and clean
( docker stop apache )
( docker rm -v apache )
#Build and run
( docker build $1 -t byteflair/httpd-multihost . \
&& docker run --name apache -p 80:80 -p 443:443 -v /etc/apache2 -v /var/www -v /var/log/apache2 -tid byteflair/httpd-multihost )
#Extract location of volumes
echo VOL_SERVER_ROOT=$(docker inspect -f '{{range $a := .Mounts}}{{if eq .Destination "/etc/apache2"}}{{.Source}}{{end}}{{end}}' apache)
echo VOL_DOC_ROOT=$(docker inspect -f '{{range $a := .Mounts}}{{if eq .Destination "/var/www"}}{{.Source}}{{end}}{{end}}' apache)
echo VOL_LOG=$(docker inspect -f '{{range $a := .Mounts}}{{if eq .Destination "/var/log/apache2"}}{{.Source}}{{end}}{{end}}' apache)