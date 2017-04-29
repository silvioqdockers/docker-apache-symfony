docker-apache-symfony
=====================

Docker image with fairly minimal requirements for running Symfony 2.

Based on/provides:

* Debian Jessie
* Apache 2.4
* PHP 7.0 (mod_php and cli)
* php7-intl
* php7-curl

Why?
----

I needed an image based on Debian, and I believe the image should include as few additional components as
possible (you can base an image off this with your additional requirements).


Example usage
-------------

You can build and run a Symfony 3.2 demo application from scratch with the following steps.

Create a Symfony project on the host system:

    mkdir ~/hello && cd ~/hello
    docker run --rm -v $(pwd):/app composer/composer create-project symfony/framework-standard-edition:3.2 --no-interaction .

Create the `Dockerfile`:

    echo "FROM fazy/apache-symfony" > Dockerfile
    echo "ADD . /app" >> Dockerfile

Build and run the Docker image:

    docker build -t symfony/hello .
    docker run -d -p 8000:80 --name hello symfony/hello

Visit your new website:

    curl -v http://localhost:8000


Containerising your own app
---------------------------

To build a container including an existing Symfony app:

Create a `Dockerfile` in the root of your application (e.g. /my-app):

    FROM fazy/apache-symfony
    ADD . /app

You might want to replace the above ADD line with something more specific:

    ADD vendor /app/vendor
    ADD bin /app/bin
    ADD app /app/app
    ADD src /app/src
    ADD web /app/web

Adding `vendor` first *might* help a little with caching, assuming vendor changes less frequently than the others.

Build your container and commit:

    cd /app
    docker build -t myname/myapp .
    docker commit

You can then [pull](http://docs.docker.com/reference/commandline/cli/#pull) and
[run](https://docs.docker.com/reference/run/) your Docker image anywhere.


Extending the app
-----------------

To install more packages, add this to your `Dockerfile`:

    RUN    apt-get update \
        && apt-get -yq install \
            <package-1> \
            <package-2> \
        && rm -rf /var/lib/apt/lists/*

Replace `<package-1>`, `<package-2>` with a list of packages to install.

To use your own Apache config, you can create your own version of the `vhost.conf` in this project, then
ADD it in your Dockerfile:

    ADD vhost.conf /etc/apache2/sites-available/000-default.conf

