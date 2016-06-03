# Intro

This image is an apache2 server prepared to serve multi domain environments. This is, hosts which serve multiple websites under different domain names.

This image is intended to be deployed in front of other web sites, application servers or any other service provided over the web via HTTP/HTTPS that are running on the same (or different) host(s) but you want to serve under different domains or subdomains.

This image provides simple mechanisms to add new sites, enable and disable sites.

This image exposes ports 80 and 443 to support both HTTP and HTTPS standard ports.

# Getting started

This image takes the following arguments:

* a server root volume
* a document root volume
* an environment variable indicating which modules to enable
* an environment variable indicating which sites to enable

The image comes pre-bundled with some configuration templates overriden from default apache2 configuration.

You can run the image an copy these files into the host machine. Then modify the configuration as needed and finally you can re-run the image using volumes pointing to the modified configuration in the host machine.

All sample commands assume that the coontainer is run under the `apache` name.

## Running the image without overriding configuration

This mode is only intended for you to check the correct instalation of the image. It will serve you to test the working samples.

```bash
    docker run --name apache -p 80:80 -p 443:443 -d byteflair/httpd-multihost
```

## Running the image without overriding configuration but with volumes

Configuration (Server Root) and content (Content Root) volumes will be created and you will be able to manipulate configuration and content on the fly.

```bash
    docker run --name apache -p 80:80 -p 443:443 -v /etc/apache2 -v /var/www -v /var/log/apache2 -d byteflair/httpd-multihost
```

## Running the image overriding configuration

The preferred way to run this image. Configuration (Server Root) and content (Content Root) volumes will be created at your specifiec location. You can also override the content of these volumes by specifying non empty folders. Maximun flexibility and convenience.

```bash
    docker run --name apache -p 80:80 -p 443:443 -v /route-to-your-config:/etc/apache2 -v /route-to-your-content:/var/www -v /route-to-your-logs:/var/log/apache2 -d byteflair/httpd-multihost
```

## Adding a new site

When following the instructions to add a new site, you will need to modify apache configuration files. Depending on how you run the container you will have to modify these files from within the container or from the host system via volumes.

In case you run the container without using volumes, files are not directly accessible from the host. We suggest you use `docker cp` to copy configuration files from the container to the host, make necessary modifications and copy them back to the container. Or you can connect to the container and run a bash terminal `docker exec -ti apache bash` and then edit or create the necessary files with `vi`.

If you choose to run the image using volumes but without mapping them to specific host folders, you will need to locate where those volumes are hosted. For example, issue the following command to know where the `/etc/apache2` folder is hosted:

```bash
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

```bash
	docker exec apache a2ensite <site-name>
```

Àfter enabling the site, you will need to restart the container for the changes to take effect.

```bash
   docker restart apache
```

## Disabling a site

To disable a site  issue the following command:

```bash
	docker exec apache a2dissite <site-name>
```

Àfter disabling the site, you will need to restart the container for the changes to take effect.

```bash
   docker restart apache
```