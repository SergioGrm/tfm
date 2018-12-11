/*
 *  "fibo.c"
 *  Raquel Martinez - 30-03-2011
 */
#include<stdio.h>

int fibonacci(int n) {
    int t,t1,t2,i;
    t1= 1; t2=1;
     //##codigo usuario##

    //##codigo usuario##
     return t;
}

int fibonacci_OK(int n) {
    int t,t1,t2,i;
    t1= 1; t2=1;
    for (i=3; i<=n; i++) {
                t= t1+t2;
	   t1=t2;
	   t2=t;
    }
    return t;
}


int main(int argc, char** argv)
{
 int correcto = 1;
	int n;
	
n=3;

if  (fibonacci(n) != fibonacci_OK(n))
		{ 
		correcto=0;
		printf("El resultado es INCORRECTO");
		return(correcto);
		}

n=11;		
if  (fibonacci(n) != fibonacci_OK(n))
		{ 
		correcto=0;
		printf("El resultado es INCORRECTO");
		return (correcto);
		}
		
	printf("El programa esta CORRECTO");
    return 0;
}
