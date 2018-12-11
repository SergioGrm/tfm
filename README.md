# README #

Para instalar todo...:

1. Instalar apache2
1. Instalar el modulo de php para apache2: $ sudo apt install libapache2-mod-php (en principio es la 7.0)
1. Habilitar el modulo de acceso a userdir: $ sudo a2enmod userdir
1. Habilitar la ejecución de scripts editando el archivo: $ sudo nano /etc/apache2/mods-enabled/php7.0.conf y cambiando Off por On
1. Instalar ZMQ
  sudo apt install libzmq-dev
  sudo apt install php-pear
  sudo apt install php-dev
  sudo pecl install zmq-beta
  sudo nano /etc/php/7.0/apache2/php.ini
  y escribir extension=zmq.so (apartado dinamic extension)
1. Arrancar los programas de ZMQ:
  
1. Reinciar apache2: $ sudo service apache2 restart
1. Crear la carpeta de public_html y mover el contenido de todo a esa carpeta
1. Poner en URL: localhost/~usuario/aulac

### What is this repository for? ###

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact
