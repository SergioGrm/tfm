<?php
setcookie("TestCookie","prueba",time()+60*5,"/") or die('unable to create cookie');
?>
<!doctype html>
<html lang="es">
	<head>
		<!-- Required meta tags -->
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<!-- Bootstrap CSS -->
		<link rel="stylesheet" href="extern/Bootstrap_3.3.7/css/bootstrap.min.css" />
		<link rel="stylesheet" href="extern/Codemirror_5.12/lib/codemirror.css" />
		<link rel="stylesheet" href="interfaz/css/examen.css" />

		<title>Examen Programación</title>
	</head>
	<body oncontextmenu="return false">
		<div id=inicio class="jumbotron text-center">
			<h1>Examen</h1>
			<p></p>
		</div>
		<div class="container-fluid">
		  <div class="row">
			<div class="col-sm-3">
			<div class="sidebar">
				<h3>Navegador</h3>
			  <table class="table table-hover">
				<thead>
					<tr>
						<th>Nº Cuestión</th>
						<th>Estado</th>
					</tr>
				</thead>
				<tbody id="index_body">

				</tbody>
			  </table>
			 <button class="btn" data-toggle="modal" data-target="#ayuda">Ayuda</button>
			 <button class="btn" onclick="corregir_todo()">Corregir todo</button>
			 <button class="btn" onclick="fin_examen()">Terminar</button>
			</div>
			</div>
			<div class="col-sm-9">
			<?php
				include("generar_examen.php");
			?>
			</div>
		  </div>
		</div>
		<!-- Modal ayuda-->
		<div id="ayuda" class="modal fade" role="dialog">
		  <div class="modal-dialog">
			<div class="modal-content">
			  <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">Ayuda</h4>
			  </div>
			  <div class="modal-body">
				<p>Aquí aparecerá la ayuda para alumnos y la licencia de codemirror</p>
			  </div>
			  <div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			  </div>
			</div>

		  </div>
		</div>
		<!-- jQuery , Bootstrap JS, Codemirror -->
		<script type="text/javascript" src="extern/Jquery_3.3.1/jquery-3.3.1.min.js"></script>
		<script type="text/javascript" src="extern/Bootstrap_3.3.7/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="extern/Codemirror_5.12/lib/codemirror.js"></script>
		<script type="text/javascript" src="extern/Codemirror_5.12/mode/clike/clike.js"></script>
		<script type="text/javascript" src="extern/Codemirror_5.12/addon/edit/matchbrackets.js"></script>
		<!-- JavaScript -->
		<script type="text/javascript" src="js/editor.js" ></script>
		<script type="text/javascript" src="js/generar_enlaces.js" ></script>
		<script type="text/javascript" src="js/corregir.js" ></script>
		<script type="text/javascript" src="js/generar_examen.js" ></script>
	</body>
</html>
