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

echo "-------------- Saving Answer to file --------------\n";
exec('mkdir -p -v corrections/' . $pregunta);

file_put_contents ( 'corrections/' . $pregunta . '/respuesta.txt', '//##codigo usuario##' . "\n" . $respuesta . "\n" . '//##codigo usuario##');

echo "-------------- Executing make --------------\n";

$descriptorspec = array(
   0 => array("pipe", "r"),  // stdin
   1 => array("pipe", "w"),  // stdout
   2 => array("pipe", "w"),  // stderr
);

$command = 'make ANSWER_ID=' . $pregunta . ' QUESTION_ID=' . $pregunta;

$process = proc_open($command, $descriptorspec, $pipes, dirname(__FILE__), null);

$stdout = stream_get_contents($pipes[1]);
fclose($pipes[1]);

$stderr = stream_get_contents($pipes[2]);
fclose($pipes[2]);

echo $stdout;
echo "\n";

echo $stderr;
echo "\n";

echo "-------------- Fin --------------\n";
?>
</pre></code>
</body>
