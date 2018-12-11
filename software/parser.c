
#include <stdio.h>
#include <string.h>

int procesar_hasta_marca(FILE *file, FILE *out)
{
    char linea[256];
    char parte1[256];
    char parte2[256];
    char *aux;

    aux = fgets(linea, 256, file);

    while ( aux != NULL )
    {
        if ( 2 == sscanf(linea, " %s %s", parte1, parte2) )
        {
            if ( 0 == strcmp(parte1, "/*##codigo") && 0 == strcmp(parte2, "usuario##*/") )
            {
                if ( out != NULL )
                {
                    fputs("/* codigo insertado */\n", out);
                }
                return 1;
            }
        }

        if ( out != NULL )
        {
            fputs(linea, out);
        }
        aux = fgets(linea, 256, file);
    }

    return 0;
}

int main(int argc, char *argv[])
{
    if ( argc == 4 )
    {
        FILE *pruebas   = fopen(argv[1],"r");
        FILE *corrector = fopen(argv[2],"r");
        FILE *out       = fopen(argv[3],"w");

        if ( pruebas != NULL && corrector != NULL && out != NULL )
        {
            int seguir = procesar_hasta_marca(corrector, out);

            while ( seguir )
            {
                procesar_hasta_marca(pruebas, NULL);
                procesar_hasta_marca(pruebas, out);
                procesar_hasta_marca(corrector, NULL);
                seguir = procesar_hasta_marca(corrector, out);
            }

            fclose(pruebas); fclose(corrector); fclose(out);
        }
        else
        {
            printf("No se han podido abrir todos los archivos\n");

            if ( pruebas != NULL )   fclose(pruebas);
            if ( corrector != NULL ) fclose(corrector);
            if ( out != NULL )       fclose(out);

            return 1;
        }
    }
    else
    {
        int i = 0;
        printf("usage: ./parser pruebas.c corrector.c output.c \n");
        printf("find: ");
        for ( i = 1; i < argc; ++i )
        {
            printf("'%s' ", argv[i]);
        }
        printf("\n");
        return 1;
    }
    return 0;
}
