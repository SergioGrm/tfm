<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>

<h1>Introduce la respuesta</h1>

<?php 
$pregunta = $_GET["pregunta"];
?>

<p> Identificador de la pregunta: <?php echo $pregunta; ?></p>

<p> <pre> <code>
    <?php 
    echo "Archivo: ";
    echo "./preguntas/" . $pregunta . ".enu\n\n"; 
    readfile("./preguntas/" . $pregunta . ".enu"); 
    echo "\nContesta a continuación \n";
    ?>
</code> </pre> </p>

<?php 
$action = "do_distrib_correct.php?pregunta=" . $pregunta;
?>

<form action=<?php echo '"'; echo $action; echo '"'; ?> method="post" enctype="multipart/form-data">
    
<br>
<textarea name="respuesta" cols="80" rows="7">
Introduce la respuesta.
</textarea>
<br>
<br>

<input type="submit">

</form>

</body>
</html>
