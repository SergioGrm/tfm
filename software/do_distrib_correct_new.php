<?php 


if(isset($_POST["respuesta"])&&isset($_POST["pregunta"])){
parse_str($_SERVER['QUERY_STRING']);

$respuesta=$_POST["respuesta"];
$pregunta=$_POST["pregunta"];

// Create context
$context = new ZMQContext();

//  Socket to talk to server
$requester = new ZMQSocket($context, ZMQ::SOCKET_REQ);
$requester->connect("tcp://127.0.0.1:5555");

$requester->send($pregunta, ZMQ::MODE_SNDMORE);
$requester->send($respuesta);

$reply = $requester->recv();
echo $reply;
}else{
	echo "Petición incorrecta";
	}
?>

