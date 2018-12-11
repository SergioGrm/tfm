
# Instalación/ejecución de los script de arranque.

## Ejecutar scripts en el arranque.

La mejor opción es usar el servicio local que ejecuta todo 
lo que hay en la carpeta /etc/local.d siempre qeu tenga extensión
start (para boot) o stop (para shutdown). 

Hay que:

```
rc-update add local defauld
rc-service local start
```

Los script se ponen en /etc/local.d y tienen que ser ejecutables. 


