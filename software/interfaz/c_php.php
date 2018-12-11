<!-- #include file="pathconfig.asp"-->


<?php
// ---------------------------------------------------------------------
// DESCRIPCIÓN: Correccion ejercicios tipo GC (lenguaje C)
// AUTOR: Miguel Sánchez de León Peque
// ULTIMA REVISION: 12/04/2010 por Miguel Sánchez de León Peque
// ---------------------------------------------------------------------

//on error resume next
$maxtime=10;
$startline=0;
set_time_limit(200);
echo "comienzo_mensaje" //esto es para que el applet sepa a partir de qué caracter tiene que sacarlo por pantalla al usuario



// *** RECOGE LOS DATOS DE ENTRADA ***
$flag_compilacion_incorrecta = 0;
$accion=strtolower(trim($_POST["accion"]));
$num_ficheros=intval($_POST["num_ficheros"]);
$nombre3=$_POST["nombre3"];
$fichero[$num_ficheros+1)];
$nombre_fichero[$num_ficheros+1];
$nombre_solucion[$num_ficheros+1];

for ($i=0;$i<$num_ficheros;$i++){
	$fichero[i]=$_POST["fichero_".i];
	$nombre_fichero[i]=$_POST["$nombre_fichero_".i];
	$nombre_solucion[i]=$_SERVER['DOCUMENT_ROOT']."/".$_POST["$nombre_solucion_".i)]; //asi pasamos del path virtual al path real
}

$file[$num_ficheros+1];


// *** BORRA POSIBLES RESIDUOS ANTERIORES Y CREA LA CARPETA CORRESPONDIENTE***
$nombre_carpeta = $_SERVER['DOCUMENT_ROOT']."/"."tmp/";

// *** CREAMOS LOS ARCHIVOS .C y .H PARA COMPILARLOS LUEGO ***
$nombre_completo_fichero[$num_ficheros+1];
for ($i=0;$i<$num_ficheros;$i++){
	$nombre_completo_fichero[i] = $nombre_carpeta . $nombre_fichero[i];
	$file[i] = fopen($nombre_completo_fichero[i], "x+");
	$trozos_del_fichero = explode("//##codigo usuario##",$fichero[i]);
	j=1;
	do while (j<count($trozos_del_fichero)){//error?
		//************************************************ SEGURIDAD ************************************************
		$trozos_del_fichero[j] = str_replace("#","//#",$trozos_del_fichero[j]); //(previene la utilización de "include")
		$trozos_del_fichero[j] = str_replace("\\","",$trozos_del_fichero[j]); //(previene la ruptura de lineas, que pueden saltarse el filtrado de seguridad y la creación o modificación de archivos del sistema)
		$trozos_del_fichero[j] = str_replace("printf","//printf",$trozos_del_fichero[j]); //(previene la utilización de "printf")
		$trozos_del_fichero[j] = str_replace("system","//system",$trozos_del_fichero[j]); //(previene la ejecución de comandos del sistema, aunque el profesor haya incluido la librería "stdlib")
		//***********************************************************************************************************
		j=j+2;
	}
	j=0;
	do while (j<=count($trozos_del_fichero)){
		fwrite($file[i],$trozos_del_fichero[j]);
		j=j+1;
	}
	fwrite($file[i],chr(10));
	fclose($file[i]);
}



// *** COMPILAMOS TODOS LOS FICHEROS .C Y DEVOLVEMOS EL RESULTADO EN CASO DE HABER PULSADO EL BOTON COMPILAR***

$compilacion[$num_ficheros+1];
for ($i=0;$i<$num_ficheros;$i++){
	$trozos_del_nombre = explode(".",$nombre_fichero[i],2);
	$nombre_sin_extension = $nombre_carpeta . "/" . $trozos_del_nombre[0];
	if ($trozos_del_nombre(1) == "c"){
		system("gcc -Wall -o " . $nombre_sin_extension . " " . $nombre_sin_extension . ".c 2>" .$nombre_sin_extension. ".txt");
		$compilacion[i]=shell_exec("cat -s " .$nombre_sin_extension. ".txt");
		if ($compilacion[i] != ""){
			$flag_compilacion_incorrecta = 1;
			$compilacion[i] = str_replace($nombre_carpeta,"",$compilacion[i]);
			$texto_error = $texto_error . $compilacion[i];
		}
	}
}
//En caso de que el único error sea que no existe la función "main", no lo contamos como error
if (strpos ($texto_error, "WinMain@16"))!= FALSE && (strlen($texto_error) < 170) {
		$flag_compilacion_incorrecta = 0;
}
//En caso de obtener errores en la compilación, los mostramos por pantalla
if ($flag_compilacion_incorrecta == 1) {
	echo $clave_secreta;
	echo "ERROR DE COMPILACIÓN./n /n" . $texto_error;
	echo $clave_secreta;
else{
	if ($accion == "compilar") {
		echo $clave_secreta;
		echo "Compilación correcta";
		echo $clave_secreta;
	}
}



// *** CUANDO LA ACCION ES EJECUTAR Y SE HA COMPILADO BIEN HAREMOS LO SIGUIENTE ***
if ($flag_compilacion_incorrecta == 0 and $accion == "ejecutar") {///////
	
	
	//CREAMOS ESTAS VARIABLES QUE NECESITAMOS
	$fichero_solucion[$num_ficheros+1];
	$fichero_definitivo[$num_ficheros+1];
	//LEEMOS LOS FICHEROS .SOL Y LOS GUARDAMOS EN VARIABLES
	for (i=0;i<$num_ficheros;i++){
		$file[i] = fopen($nombre_solucion[i], "r");
		$fichero_solucion[i] = file_get_contents($file[i]);
		fclose($file[i]);
	}
	

//crear para borrar
	//BORRAMOS LA CARPETA CON TODOS LOS FICHEROS Y VOLVEMOS A CREARLOS MEZCLANDO CON LO ESCRITO POR EL PROFESOR
	for ($i=0;$i<$num_ficheros;$i++){
		$trozos_del_fichero = explode("//##codigo usuario##",$fichero[i]);
		$trozos_del_$fichero_solucion = explode("//##codigo usuario##",$fichero_solucion[i]);
		j=1;
		do while (j<count($trozos_del_fichero)){
			//************************************************ SEGURIDAD ************************************************
			$trozos_del_fichero[j] = str_replace("#","//#",$trozos_del_fichero[j]); //(previene la utilización de "include")
			$trozos_del_fichero[j] = str_replace("\\","",$trozos_del_fichero[j]); //(previene la ruptura de lineas, que pueden saltarse el filtrado de seguridad y la creación o modificación de archivos del sistema)
			$trozos_del_fichero[j] = str_replace("printf","//printf",$trozos_del_fichero[j]); //(previene la utilización de "printf")
			$trozos_del_fichero[j] = str_replace("system","//system",$trozos_del_fichero[j]); //(previene la ejecución de comandos del sistema, aunque el profesor haya incluido la librería "stdlib")
			//***********************************************************************************************************		
			$trozos_del_$fichero_solucion[j]=$trozos_del_fichero[j];
			j=j+2;
		}
		for (j=0;j<count($trozos_del_fichero);j++){
			$fichero_definitivo[i]=$fichero_definitivo[i] . $trozos_del_$fichero_solucion[j];
		}
	}

	for ($i=0;$i<$num_ficheros;$i++){
		unlink($nombre_completo_fichero[i]);
		$file[i] = fopen($nombre_completo_fichero[i], "x+");
		fwrite($file[i],$fichero_definitivo[i]);
		fclose($file[i]);
	}

	//COMPILAMOS LOS ARCHIVOS
	for ($i=0;$i<$num_ficheros;$i++){
		$trozos_del_nombre = explode(".",$nombre_fichero[i],2);
		$nombre_sin_extension = $nombre_carpeta . "/" . $trozos_del_nombre[0];
		if ($trozos_del_nombre[1] == "c") {
			system("gcc -Wall -o " . $nombre_sin_extension . " " . $nombre_sin_extension . ".c 2>" .$nombre_sin_extension. ".txt");
			$compilacion[i]=shell_exec("cat -s " .$nombre_sin_extension. ".txt");
			if  ($compilacion[i] != "") {
				echo "OOOOOOOOPS!/nPARECE QUE HAY UN ERROR EN ESTA PREGUNTA! /n /n";
				echo "POR FAVOR, INFORMA DE ESTO A TU PROFESOR: /n /n" . compilacion[i] . "/n /n";
				echo "(Probablemente esté pasando esto porque la plantilla de corrección de la pregunta tenga algún defecto en el código) /n";
				echo "Gracias por tu colaboración!/n:-) /n /n /n";
			}
		}
	}


	//BUSCAMOS EL ARCHIVO QUE TIENE LA FUNCION main Y LO EJECUTAMOS
	for ($i=0;$i<$num_ficheros;$i++){
		if (strpos($fichero_definitivo[i]," main(")!=FALSE){
			$trozos_del_nombre = explode(".",$nombre_fichero[i], 2);
			$fichero_para_ejecutar = $trozos_del_nombre[0];
			$ejecucion = shell_exec($nombre_carpeta . "/" . $fichero_para_ejecutar);
			echo $ejecucion;
		}
	}
}

// *** BORRA LOS ARCHIVOS QUE HEMOS CREADO ***
Dim objFile,objFolder;
Set objFolder = $fso.GetFolder($nombre_carpeta);
	for Each objFile in objFolder.files{
		nombreArchivo= split(objFile.Name,".");
		if (($nombre3=right(nombreArchivo(0),3)) AND ((strtolower (nombreArchivo(1))="c") OR (strtolower (nombreArchivo(1))="exe"))){
			objFile.Delete;
		}
	}
//LIBERA RECURSOS
Set objFolder=nothing;
set executor=nothing;
set $fso=nothing;


?>

