
## Install Android Studio.

Para poner los paquetes que dicen, está mal en la página de android studio.

Hay que hacer:

```
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libbz2-1.0:i386
```

Otra cosa es que hay que poner una carpeta cuando vaya a descargar el
SDK. Otro problema es que Android descarga a /tmp y si no hay sitio 
pues no vale.

