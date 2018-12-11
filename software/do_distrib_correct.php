<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
<code><pre>
<?php 

echo "-------------- Request Data --------------\n";

parse_str($_SERVER['QUERY_STRING']);

echo $pregunta;
echo "\n";

$respuesta=$_POST["respuesta"];
echo $respuesta;

echo "-------------- Creating context --------------\n";

// Create context
$context = new ZMQContext();

//  Socket to talk to server
echo "Connecting to correction server ... \n";
$requester = new ZMQSocket($context, ZMQ::SOCKET_REQ);
$requester->connect("tcp://localhost:5555");

$requester->send($pregunta, ZMQ::MODE_SNDMORE);
$requester->send($respuesta);

$reply = $requester->recv();
echo $reply;

echo "-------------- Fin --------------\n";
?>
</pre></code>
</body>
