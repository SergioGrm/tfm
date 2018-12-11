
# Instalar Alpine. #

- Es importante correr el script setup-alpine para que guarde la imagen
a disco. En caso contrario no guarda nada en disco.
- Ojo, para añaidir un usuario no hay que andar haciendo nada de acf, solo 
añadirlo desde la linea de comandos con adduser. Es posible que haya 
que ponerle luego la contraseña y habilitarla con passwd. Son dos pasos
distintos: cambiar contraseña y habilitarla.

## Instalar X11

Seguir las instrucciones de https://wiki.alpinelinux.org/wiki/XFCE_Setup

Con los siguientes matices:

- Para encontrar el chipset se puede hacer: lspci | grep VGA. Si es un intel no
hay que meter el número de versión, sencillamente se pone apk add xf86-video-intel,
para el ratón y el mouse: apk add xf86-input-mouse xf86-input-keyboard
- Hay que configurar de nuevo el teclado (idioma, todavía no he probado).
- Para habilitar X11 forwarding hay que tocar en /etc/ssh/sshd_config y poner
X11Forwarding yes
X11UseLocalhost no
y volver a arrancar el sshd: rc-service sshd restart
- Se pueden poner iconos, pero creo que no merece la pena...

## Instalar qemu y demás:

En principio seguir instrucciones en: https://wiki.alpinelinux.org/wiki/KVM

No he conseguido lanzar el virt-manager en remoto. Por cierto que el virt-manager ocupa alrededor de 200 Mb de disco



