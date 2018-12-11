
# Guia de pasos en la instalación de Darwin 

Aunque en realidad lo hemos hecho en "Instalación Aula"

## Instalación Alpine 

Utilizar la ISO para grabar un CD (no se puede desde USB) y arrancar la ISO.

Después hay que ejecutar alpine-setup para meter las distintas opciones iniciales e
instalar en disco duro. El script te guia en el proceso de instalación.

Finalmente, por si acaso hacer update y upgrade:

apk update
apk upgrade

## Instalar X11

Seguir el manual de https://wiki.alpinelinux.org/wiki/XFCE_Setup. Los pasos que son distintos o tienen
algún matiz son los que he anotado el resto es igual y no lo repito. 

Para encontrar el driver para la tarjeta gráfica he buscado en un ubuntu del mismo ordenador con

```
lspci | grep VGA
```

y el resultado es:

Intel Corporation Sky Lake Integrated Graphics (rev 06)

Por lo tanto busco el driver disponible en Alpine y pongo:

```
apk add xf86-video-intel
```

Hay que poner también los dos drivers para el teclado y el ratón:

```
apk add xf86-input-mouse xf86-input-keyboard
```

La llamada opcional a Xorg -configure da un error de salida, pero no sé si tiene alguna consecuencia.

Para meter la configuración de teclado hay que poner en un archivo 30-input.conf las siguientes lineas:

```
Section "InputClass" 
    Identifier "Keyboard Default" 
    MatchIsKeyboard "yes" 
    Option "XkbLayout" "es,es" 
EndSection
```

Probar ejecutando (desde la terminal):

```
startx 
```

## Instalar KVM/qemu

En principio seguir instrucciones en: https://wiki.alpinelinux.org/wiki/KVM

Hay un tema a tener en cuenta, si se añade un usuario para ejecutar máquinas virtuales, 
hay que añadir ese usuario a los grupos qemu y kvm. Al usar libvirt también hay 
que añadirlo al grupo libvirt.

Dentro de las instrucciones de la wiki de alpine sobra instalar el dbus y activarlo
porque ya lo tenemos de antes. 

Pero lo que falta es intalar el virt-manager (que es el gestor grafico), para ello
hay que poner: 

```
apk add virt-manager
```

y para el visualizador (para luego conectar con las máquinas virtuales a través
de spice): 

```
apk add virt-viewer
```

Ojo con este paquete porque en otros linux instala virt-viewer pero aquí instala: remote-viewer.

Es posible que poner el servicio libvirtd en el run level no baste para que 
se arranque solo la primera vez. Simplemente se puede arrancar a mano con:

```
rc-service libvirtd start
```

Y después arrancar el gestor gráfico (sale en el menu de aplicaciones en el submenu sistema).

## Instalar Firefox

Para poder navegar comodamente es mejor tener un Web Browser, este es ligero y está en
los repositorios que ya tenemos añadidos:

```
apk add midori
```

Nota: midori no reconoce el qnap por el tema de los certificados. Es mejor poner directamente
el firefox, para eso hay añadir los repositorios de tipo edge en todas sus variantes. 
Se hace descomentando unas líneas con el nombre en el archivo de configuración correspondiente.

## Añadir discos a una máquina virtual

Dado que es muy facil añadir discos virtuales (ISOs en CD) o discos completos, eso haremos.

Pongo aquí los pasos que hay que dar después de añadir el disco virtual y rebotar la VM
(todo como root):

```
fdisk -l 
mkfs.ext4 /dev/vdb
```
Con eso ya se puede montar el disco. 

Cuidado: Puede ser que el disco se monte como root. Hay que comprobar los permisos que
lleva. 

Para montar el disco automáticamente en el arranque hay que tocar el archivo /etc/fstab,
para ello, hay que:

```
sudo cp /etc/fstab /etc/fstab.old
```

Por si acaso rompemos algo. Luego conseguir el uuid de los discos con:

```
sudo blkid
```

Luego editar el /etc/fstab metiendo una línea más con el punto de montaje. 












