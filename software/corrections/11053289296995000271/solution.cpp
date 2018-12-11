/*
 *  "celfactorial.c"
 *  Angel Garcia Beltran - 15/03/2011
 */
#include <stdio.h>

int devuelve_factorial(int n) {
    int i, f;
    f = 1;
    for (i=1; i<=n; i++) {
/* codigo insertado */
f*=i;


/* codigo insertado */
    }
    return f;
}

int devuelve_factorial_OK(int n) {
    int i, f;
    f = 1;
    for (i=1; i<=n; i++) {
       f = f*i;
    }
    return f;
}

int main() {
    int _error = 0;

    if (devuelve_factorial_OK(0)!=devuelve_factorial(0)) _error = 1;
    if (devuelve_factorial_OK(1)!=devuelve_factorial(1)) _error = 1;
    if (devuelve_factorial_OK(2)!=devuelve_factorial(2)) _error = 1;
    if (devuelve_factorial_OK(8)!=devuelve_factorial(8)) _error = 1;
    if (devuelve_factorial_OK(12)!=devuelve_factorial(12)) _error = 1;

    if (!_error) printf("El resultado es CORRECTO");
    else printf("El resultado es INCORRECTO");

    return 0;
}
