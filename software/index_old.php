<?php

function getRealIP()
{

    if (isset($_SERVER["HTTP_CLIENT_IP"]))
    {
        return $_SERVER["HTTP_CLIENT_IP"];
    }
    elseif (isset($_SERVER["HTTP_X_FORWARDED_FOR"]))
    {
        return $_SERVER["HTTP_X_FORWARDED_FOR"];
    }
    elseif (isset($_SERVER["HTTP_X_FORWARDED"]))
    {
        return $_SERVER["HTTP_X_FORWARDED"];
    }
    elseif (isset($_SERVER["HTTP_FORWARDED_FOR"]))
    {
        return $_SERVER["HTTP_FORWARDED_FOR"];
    }
    elseif (isset($_SERVER["HTTP_FORWARDED"]))
    {
        return $_SERVER["HTTP_FORWARDED"];
    }
    else
    {
        return $_SERVER["REMOTE_ADDR"];
    }

}
session_start();

	if (isset($_COOKIE['TestCookie'])){
		echo $_COOKIE['TestCookie'];
	}
	print_r($_COOKIE)
?>
<html>
<head>
	<meta charset="utf-8" />
</head>
<body>
	<?php
	if (!isset($_COOKIE['TestCookie'])){
	?>
	<h1>Index provisional aquí se pedirán las credenciales</h1>
	<a href="interfaz/examen.php"><button>Examen</button></a>
	<?php 
}
	?>
</body>
</html>
