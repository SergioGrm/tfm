/*
 * "elfactorial.c"
 */
#include <stdio.h>
int main() {
    int i, n, f;
    printf("Introduce un valor: ");
    scanf("%d", &n);
    /* El siguiente codigo almacena en f
       el factorial de n */
    f = 1;
    for (i=1; i<=n; i++) {
/* codigo insertado */
i*=i;

/* codigo insertado */
    }
    printf("El factorial de %d es %d \n",n,f);
    return 0;
}
