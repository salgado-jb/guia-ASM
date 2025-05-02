Cuando lo corro termina, por lo que tengo que poner un breakpoint

Busco los simbolos de debug:
    info functions

    Esto me va a listar todas las funcionse conocidas gracias a los simbolos de debug.
    ejemplos que tira: _init, strcmp@plt, _start frame_dummy, do_some_more_stuff, getrandom, y muchisimas mas.

Voy a investigar main, do_some_stuff, y do_some_more_stuff
    break main
    break do_some_stuff
    break do_some_more_stuff

Creo todos esos breakpoints y despues:
    run ABC123

Una vez que frena:
    backtrace
    Esto me muestra todos los frames (solo esta el #0)
    (Un frame es un bloque de informacion asociado a una llamada a una funcion que todavia no termino.
    Representa el contexto de esa funcion: sus variables locales, argumentos y el lugar al que debe volver cuando termine)

    pongo:
    c
    c
    y llego al tercer breakpoint (do_some_more_stuff)

Ahora, cuando hago backtrace y me aparecen 3 frames (#0 do_some_more_stuf, #1 do_some_stuff, #2 main)

Elijo el frame con:
    frame N

En cada frame voy chequeando los valores de los registros
    x/s $rax (devuelve lo que hay en rax convertido en string)
    x/40x $rsp (examina la memoria en hexadecimal)
    x/40s $rsp (en string)
        x = examine memory
        /40x = mostrar 40 palabras (por default, de 8 bytes) en formato string (s)
        $rsp = empezar desde direccion actual del stack

    en el frame 1, en rbx encuentro "ABC123" y en rdi encuentro "enp0s3" (no funciona)

    en el frame 0 (do_some_more_stuff), en RDI encuentro: "clave_10.0.2.15"
    ES ESTA! (lo verifico con: run clave_10.0.2.15)




Puedo crear un macro para probar varios registros:

define checkregs
echo \n--- Registros con posibles strings --\n
x/s $rdi
x/s $rsi
x/s $rdx
x/s $rcx
x/s $r8
x/s $r9
echo \n--------------------------------------\n
end