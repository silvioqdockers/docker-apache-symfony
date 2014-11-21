docker-symfony
==============

**Work in progress, not finished/tested yet, not yet pushed image to Docker Hub**

Docker (base? tbc) image with fairly minimal requirements for running Symfony 2.

Based on:

* Debian Jessie
* Apache 2.4
* PHP 5.6


Why?
----

There are several Symfony Docker images to choose from. I created this one because I needed one based on Debian,
and because I believe the image should only include the core requirements. It's easier to add than to remove things
when extending an image.

Note, this is not an image for building Symfony applications. You will need a separate image (TODO) to run tools
like Composer etc.


Getting started
---------------

This section shows how to build and run a Symfony 2 application from scratch.

Prerequisites:

* Docker
* PHP
* Composer

First, build your Symfony project on the host system:

    mkdir /var/www/hello && cd /var/www/hello
    composer create-project symfony/framework-standard-edition --no-interaction .
    php app/console generate:bundle --namespace=Acme/Bundle/DemoBundle --no-interaction --dir src

Create the Dockerfile:

    echo "FROM fazy/symfony" > Dockerfile

Then, build and run the Docker image:

    docker build -t symfony/hello .
    docker run -d -p 8000:80 --name hello symfony/hello

Visit your new website:

    curl -sS http://localhost:8000/hello/Docker


Building a containterised app
-----------------------------

To build a container including your Symfony app:

Create a Dockerfile in the root of your application
(e.g. /var/www/my-app):

    FROM fazy/symfony

Build your container:

    cd /var/www/my-app
    docker build -t myname/myapp .

Then you probably want to commit it:

    docker commit

In the place where you want to deploy:

    docker pull myname/myapp
    docker run -d -p 8000:80 myname/myapp

Change port 8000 to any available local port, or use -P to automatically
assign the exposed internal port 80.

Obviously you're unlikely to want port 8000 in production, and might
need a Varnish cache or similar to manage the various install apps.

Extending the app
-----------------

There are no database drivers, so you probably need to apt-get install
the one(s) you need.

To run apt-get in an atomic way, add this to your Dockerfile:

    RUN    apt-get update \
        && apt-get -yq install \
            <package-1> \
            <package-2> \
        && rm -rf /var/lib/apt/lists/*

Replace `<packag-1>`, `<package-2>` with a list of packages to install.

This takes longer, because you must run the update, but it also keeps
the commit small.
