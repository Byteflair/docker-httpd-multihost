# Intro

This image is an apache2 server prepared to serve multi domain environments. This is, hosts which serve multiple websites under different domain names.

This image exposes ports 80 and 443 to support both HTTP and HTTPS standard ports.

# Getting started

This image takes the following arguments:

* a server root volume
* a document root volume
* an environment variable indicating which modules to enable
* an environment variable indicating which sites to enable

The image comes pre-bundled with some configuration templates overriden from default apache2 configuration.

You can run the image an copy these files into the host machine. Then modify the configuration as needed and finally you can re-run the image using volumes pointing to the modified configuration in the host machine.

## Running the image without overriding configuration

```
    docker run --name apache -p 80:80 -p 443:443 -d byteflair/httpd-multihost
```

## Running the image without overriding configuration but with volumes

```
    docker run --name apache -p 80:80 -p 443:443 -v /etc/apache2 -v /var/www -v /var/log/apache2 -d byteflair/httpd-multihost
```

## Running the image overriding configuration

```
    docker run --name apache -p 80:80 -p 443:443 -v /route-to-your-config:/etc/apache2 -v /route-to-your-content:/var/www -v /route-to-your-logs:/var/log/apache2 -d byteflair/httpd-multihost
```

## Adding a new site

When following the instructions to add a new site, you will need to modify apache configuration files. Depending on how you run the container you will have to modify these files from within the container or from the host system via volumes.

In case you run the container without using volumes, files are not directly accessible from the host. We suggest you use `docker cp` to copy configuration files from the container to the host, make necessary modifications and copy them back to the container.

If you choose to run the image using volumes but without mapping them to specific host folders, you will need to locate where those volumes are hosted. For example, issue the following command to know where the `/etc/apache2` folder is hosted:

```
   docker inspect -f '{{range $a := .Mounts}}{{if eq .Destination "/etc/apache2"}}{{.Source}}{{end}}{{end}}' apache
```

If you run the image using explicitly mapped volumes, you can directly modify files from your mapped folders.

### Create a virtual host file to serve static content from a folder

To add `mysite.com` and serve content from '/var/www/mysite.com':

1. Copy `/etc/apache2/sites-available/000-default.conf` to `/etc/apache2/sites-available/mysite.com.conf`
2. Edit ServerName to match your desired domain name `mysite.com`.
3. Edit the DocumentRoot to match the folder `/var/www/mysite.com`.
4. Create the `/var/www/mysite.com` folder.
5. Add a sample HTML file on `/var/www/mysite.com`.
6. Enable de new site as explained below
7. Restart the container
8. In your host machine edit `/etc/hosts` and append your site to the line that mpas your loopback interface to localhost: `127.0.0.1 localhost mysite.com`
9. Open your browser and type: `http://mysite.com`. Your sample HTML page should be served.

### Create a virtual host file to serve dynamic content from an application server

In this context we consider an application server any software capable serving dynamic content over HTTP/HTTPS.

In this case, our container will act as a reverse proxy and it will be your responsibility to provide the application server container or component.

## Enabling a site

To enable a site  issue the following command:

```
	docker exec apache a2ensite <site-name>
```

Àfter enabling the site, you will need to restart the container for the changes to take effect.

```
   docker restart apache
```

## Disabling a site

To disable a site  issue the following command:

```
	docker exec apache a2dissite <site-name>
```

Àfter disabling the site, you will need to restart the container for the changes to take effect.

```
   docker restart apache
```