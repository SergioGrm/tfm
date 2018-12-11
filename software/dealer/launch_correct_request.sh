
curl -F respuesta="$(cat example1.txt)" http://localhost:8001/~stapia/aulac/do_distrib_correct.php?pregunta=FPTI00205PR0330_0 &

curl -F respuesta="$(cat example2.txt)" http://localhost:8001/~stapia/aulac/do_distrib_correct.php?pregunta=FPTI00205PR0330_0 &

curl -F respuesta="asfalshf ashfiwe" http://localhost:8001/~stapia/aulac/do_distrib_correct.php?pregunta=FPTI00205PR0330_0 &

curl -F respuesta="f = ashfiwe" http://localhost:8001/~stapia/aulac/do_distrib_correct.php?pregunta=FPTI00205PR0330_0 &

curl -F respuesta="f = i;" http://localhost:8001/~stapia/aulac/do_distrib_correct.php?pregunta=FPTI00205PR0330_0 &

curl -F respuesta="ultima ... " http://localhost:8001/~stapia/aulac/do_distrib_correct.php?pregunta=FPTI00205PR0330_0 
