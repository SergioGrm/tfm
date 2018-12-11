
<?php 

// Install zmq for php by: 
/*
 sudo apt-get install php-pear
 sudo apt-get install php5-dev
 sudo pecl install zmq-beta
 sudo nano /etc/php5/apache2/php.ini
 y escribir extension=zmq.so
*/  

echo "-------------- Send Hello to server in zmq --------------\n";

// Create context
$context = new ZMQContext();

//  Socket to talk to server
echo "Connecting to hello world server…\n";
$requester = new ZMQSocket($context, ZMQ::SOCKET_REQ);
$requester->connect("tcp://localhost:5555");

for ($request_nbr = 0; $request_nbr != 10; $request_nbr++) {
    printf ("Sending request %d…\n", $request_nbr);
    $requester->send("Hello");

    $reply = $requester->recv();
    printf ("Received reply %d: [%s]\n", $request_nbr, $reply);
}

?>
