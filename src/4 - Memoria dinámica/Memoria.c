#include "Memoria.h"

int32_t strCmp(char* a, char* b){
    if ((int) *a == 0 && (int) *b == 0){
        return 0;
    }
    else if ((int) *a < (int) *b){
        return -1;
    }
    else if ((int) *a > (int) *b){
        return 1;
    }
    else {
        a++;
        b++;
        strcmp(a, b);
    }
}

/* Pueden programar alguna rutina auxiliar acá */
