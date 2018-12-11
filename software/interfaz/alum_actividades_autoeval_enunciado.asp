<%@ LANGUAGE="VBSCRIPT" %>
<!-- #include file="identifica_asignaturas.asp"-->

<%
' **************************************************************************
' PAGINA: alum_actividades_autoeval_enunciado.asp
' AUTOR: Luis M. Pabón
' ÚLTIMA REVISIÓN: 17.05.2000
' DESCRIPCIÓN: Presentación del enunciado de las preguntas para ejercicios
'              de autoevaluación. Incluye botones para responder, anular,
'              imprimir, guardar, finalizar y navegación entre las preguntas.
' **************************************************************************
%>

<%
' *** COMPROBACIONES DE SEGURIDAD Y DEPURACIÓN ***
response.expires=0
if session("seguridad")<0 then response.redirect "login.asp"
'if session("alum_debug")=0 then On Error Resume Next
%>

<%
' *** Obtiene los datos de la pregunta ***
volver=request("volver")
pregunta=UCase(trim(request.querystring("pregunta")))
idxpreg=request.querystring("idxpreg")
numpreg=request.querystring("numpreg")
faltan=request.querystring("faltan")
respuesta=request("respuesta")
peso=request("peso")
if pregunta = "" then'esto esta puesto para cuando los parametros se pasan por POST en vez de por GET (cosa que se hizo para solucionar el tema de que no funcionaba en el internet explorer por que este no aceptaba url muy grandes)
pregunta=request.form("pregunta")
idxpreg=request.form("idxpreg")
numpreg=request.form("numpreg")
faltan=request.form("faltan")
respuesta=request.form("respuesta")
peso=request.form("peso")
end if
maxtime2=10
if (peso="" OR isnull(peso)) then
	puntuacionPreg=round(10/cint(numpreg),2)
else
	puntuacionPreg2=split(peso,",")
	puntuacionPreg3=0
	for i=0 to (cint(numpreg)-1)
		puntuacionPreg3=puntuacionPreg3+cint(puntuacionPreg2(i))
	next
	puntuacionPreg=round(10*puntuacionPreg2(cint(idxpreg)-1)/puntuacionPreg3,2)
end if
'Response.write "Pregunta: "&pregunta&" idxpreg: "&idxpreg&" numpreg: "&numpreg&" faltan: "&faltan&" respuesta: "&respuesta

' *** Conecta con la Base de Datos
set conexion=server.createobject("ADODB.Connection")
conexion.open session("DSN")

'Para identificar si es de un plan u otro
comandoSQL="SELECT codigo_etsii FROM asignaturas WHERE id_asignat='" & session("id_asignat") & "'"
set RS=conexion.execute(comandoSQL)

' *** Obtiene informacion del alumno

sql="SELECT * FROM alumnos WHERE id_alumno='" & session("usuario") & "'"
set info_alumno=conexion.execute(sql)
if NOT info_alumno.EOF then session("num_matricula")=info_alumno("num_mat") else session("num_matricula")="0"

' *** Recupera la informacion de la pregunta
if (esDeBolonia(RS("codigo_ETSII"))="1") then
	sql="SELECT * FROM preguntasB WHERE id_asignat='" & session("id_asignat") & "' AND id_pregunta='" & pregunta & "'"
	set pregunta_ejercicio=conexion.execute(sql)
else
	sql="SELECT * FROM preguntas WHERE id_asignat='" & session("id_asignat") & "' AND id_pregunta='" & pregunta & "'"
	set pregunta_ejercicio=conexion.execute(sql)
end if
if pregunta_ejercicio.EOF then
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR><TD ALIGN="center" VALIGN="top" ID="t1">
	<IMG SRC="../images/icono-error.gif" WIDTH="32" HEIGHT="32" BORDER=0 ALT="Imágen incorrecta"><BR><BR>
	Ha especificado una pregunta no válida<BR><BR>
	<INPUT ID="t1" TYPE="reset" VALUE="Anterior" NAME="anterior" ONCLICK="javascript:history.back();">
	</TD></TR>
	</TABLE>
<%
else
	' *** se recuperan los path de los ficheros enunciados
	path_virtual_preguntas="/webaula/preguntas/asg-" & session("id_asignat")
	path_real_preguntas=Server.MapPath(path_virtual_preguntas)
	enunciado=path_real_preguntas & "\" & pregunta_ejercicio("enunciado")
	tipo_pregunta=pregunta_ejercicio("id_tipo")
	
	'Corregido path_temporal para que indique el path de temporal del servidor
	path_temporal=request.serverVariables("appl_physical_path")&"temp"
%>

<HTML>
<HEAD>
<TITLE>Enunciado</TITLE>
<SCRIPT LANGUAGE="javascript" SRC="tablas.js"></SCRIPT>
<STYLE TYPE="text/css">
  <!--
  #nc { font-family: Tahoma, Arial; font-size: 11px; font-weight: bold; color:#ff0000; }
  #sc { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color:#008000; border-color: #00C000 ;}
  -->
</STYLE>
<META HTTP-EQUIV="cache-control" CONTENT="must-revalidate">
<META HTTP-EQUIV="cache-control" CONTENT="private">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</HEAD>
<BODY ID="t1" MARGINWIDTH="0" MARGINHEIGHT="0" LEFTMARGIN="0" TOPMARGIN="0" BGCOLOR="#ffffff" TEXT="#000000" LINK="#000080" VLINK="#000080" ALINK="#ff8000">
<SCRIPT LANGUAGE="javascript">
<!--
  parent.parent.inferior.document.estado.src="../images/est-espere.gif";
// -->
</SCRIPT>
<CENTER>
<TABLE WIDTH="95%" HEIGHT="100%" BORDER="0" CELLPADDING="0" CELLSPACING="0" ALIGN="center">
<TR>
<TD ALIGN="center" VALIGN="top" ID="t0"><CENTER>
<FORM NAME="pregunta" METHOD="POST" ACTION="alum_actividades_autoeval_resultado.asp" TARGET="resultado">
<INPUT TYPE="hidden" NAME="accion" VALUE="">
<SCRIPT LANGUAGE="JavaScript">
<!--
	abre_titulo("<span id=t1><b>Pregunta <%=idxpreg%> de <%=numpreg%></b> <FONT SIZE=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Puntuación: <FONT COLOR=red><b><%=puntuacionPreg%></b></FONT> sobre <FONT COLOR=red><b>10</b></FONT>)</FONT></span>","#d0d0d0","#f8f8f8","100%","",true);
// -->
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
/* Generador de números aleatorios */
var seedy=<%=clng(session("semilla")*(idxpreg/numpreg))%>;
function aleatorio() {
  seedy=((16807*seedy) % 2147483647);
  return (seedy/2147483647);
}

/* Comando de impresión */
function imprimirEjercicio() {
  if(confirm("Esta acción mostrará una copia del ejercicio que\npodrá imprimir con las opciones del navegador.\n¿Desea continuar?")) {
	//document.pregunta.accion.value='Imprimir';
	//document.pregunta.submit();
	parent.control.imprimirEjercicio()
    return true;
  } else { return false; }
}

/* Comando de grabación */
function guardar() {
  if(confirm("Esta acción interrumpirá el ejercicio y lo almacenará\npara poder ser continuado en otro momento.\n¿Desea proceder así?")) {
	//document.pregunta.accion.value='Guardar';
	//document.pregunta.submit();
	parent.control.guardar()
    return true;
  } else { return false; }
}

/* Comando de finalización */
function finalizar() {
  mensaje="¿Realmente quieres dar por finalizado el ejercicio?";
  if (parent.control.faltan!=0) mensaje="Aún te faltan algunas preguntas por responder.\n"+mensaje;
  if(confirm(mensaje)) {
	parent.control.finalizar()
    return true;
  } else { return false; }
}

function ResponderCodigo() {
  // NOTA: Parece que Netscape 4.x no puede acceder a los métodos del applet TPascal
  document.pregunta.accion.value='Responder';
  tpascal = document.getElementById("TPascal");
  document.pregunta.respuesta.value = TPascal.getRespuesta();
  //document.pregunta.respuesta.value=document.pregunta.TPascal.getRespuesta();
  }
  
function ResponderPR() {

  document.pregunta.accion.value='Responder';
  document.pregunta.respuesta.value=document.AProg.getRespuesta();//accedemos al metodo getRespuesta del applet que nos devolvera un string con la respuesta
   //alert(<%=respuesta%>);
  //document.pregunta.respuesta.value="que bien que bien";
  }
function ResponderPRGC() {

  document.pregunta.accion.value='Responder';
  document.pregunta.respuesta.value="fichero_"+editor.getValue();
   //alert(<%=respuesta%>);
  //document.pregunta.respuesta.value="que bien que bien";
  }
  
function ResponderMM() {
  document.pregunta.accion.value='Responder';
  document.pregunta.respuesta.value=document.appmath.getRespuesta();
  }
  
  function ResponderMS() {
  document.pregunta.accion.value='Responder';
  document.pregunta.respuesta.value=document.appmath2.getRespuesta();
  }
  
  function ResponderVA() {
	respuesta=document.getElementsByName("respuesta")[0].value;
	var caracter=respuesta.substr(0,1);
	if (caracter=="+") {
		document.getElementsByName("respuesta")[0].value=respuesta.substr(1);
	}
	document.pregunta.accion.value='Responder';
  }
  
function AnularCodigo() {
  document.pregunta.accion.value='Anular';
  document.pregunta.respuesta.value="";
  document.pregunta.TPascal.resetRespuesta();
}

function AnularPR() {
  document.pregunta.accion.value='Anular';
  document.pregunta.respuesta.value="";
  document.AProg.resetRespuesta();////accedemos al metodo resetRespuesta del applet que 

}

function AnularPRGC() {
  parent.control.responder('')
  }

function GuardarRespuestaVR(num_cuestiones) {
var respuesta=document.pregunta.respuesta.value;
	document.pregunta.accion.value='Responder';
	respuesta=String(num_cuestiones);
	for(i=1;i<=num_cuestiones;i++)
	{
		var cuestion="document.pregunta.Q"+i;
		if (eval(cuestion + ".type").indexOf("select")==0) {
			opcion=eval(cuestion + ".selectedIndex");
			respuesta=respuesta + "|" + eval(cuestion + ".options[" + opcion + "].value");
		}
		else {
			respuesta=respuesta + "|" + eval(cuestion + ".value");
		}
	}
	document.pregunta.respuesta.value=respuesta;
}


function Validame() {
      alert("Por favor pulse el boton Responder del applet para enviar su respuesta");
      document.formulario.descripcion.focus();
      return (false);
    }

//-->
</SCRIPT>
<%
	set fso=server.createobject("Scripting.FileSystemObject")
	' *** Enunciado de preguntas variantes (VA)
	
	if (tipo_pregunta="VA") then
	
		' *** Conversión @CX@ ----> Caracteres especiales ***
			especial=chr(13) & chr(10) & "””;'#%&+\"
			respuesta=replace(respuesta,"@CX=1@@CX=2@","¶")
			respuesta=replace(respuesta,"@CX=2@","¶")
			for j=1 to Len(especial)
				respuesta=replace(respuesta,"@CX=" & j & "@",mid(especial,j,1))
			next
	
		' *** genera el enunciado ejecutando el fichero .exe
		semilla=session("semilla")
		set executor = Server.Createobject("Dynu.Exec")
		'set ejecutable = fso.GetFile(enunciado)
		'response.write (pregunta_ejercicio("enunciado"))
		
		' ***genera un nombre para cada sesion del archivo .exe
		'nomEnun=split(pregunta_ejercicio("enunciado"),".")
		ejecutableEXE="V"&CStr(Minute(Now()))&CStr(Second(Now()))&right(Session.SessionID,3)&".exe"
		enunciado_ejecutable=path_temporal & "\" & ejecutableEXE
		set archivo=fso.getfile(enunciado)
		archivo.copy(enunciado_ejecutable)
		'fso.Copyfile enunciado,path_temporal & "\"
		
		ejecucion=executor.execute("awcmd /C " & server.mappath("/webaula/tpascal/runsec2.exe") & " "&enunciado_ejecutable & " /e " & cstr(semilla) & " "& maxtime2)

		'ejecucion=executor.execute("awcmd /C """ & enunciado_ejecutable & " /E " & CStr(semilla) & """")
		'Solución provisional para la asignatura de máquinas eléctricas (316), en la que no se visualizaban las imágenes
		'de las preguntas al no indicar correctamente la ruta.
		ejecucion=replace(ejecucion, "src ="&chr(34)&"\webaula", "src ="&chr(34)&"..")
		response.write replace(ejecucion, "src="&chr(34)&"\webaula", "src ="&chr(34)&"..")
		'fin de modificación
		if fso.FileExists(enunciado_ejecutable) then fso.DeleteFile (enunciado_ejecutable)
		set executor=nothing	
	' *** Enunciado de preguntas con varias respuestas (VR) o enunciado variable (VV)
	elseif (tipo_pregunta="VR" or tipo_pregunta="VV") then
		session("ver_solucion")="0"
		session("num_cuestiones")=CStr(pregunta_ejercicio("respuesta"))
		session("id_pregunta")=pregunta
		' *** las respuestas se almacenan separadas por |
		' *** ,siendo el valor 0 del array el num. de cuestiones (ejemplo 5|||||)
		if respuesta="" then
			respuesta=session("num_cuestiones")
			For i=1 To respuesta
				respuesta=respuesta & "|"
			Next
		end if
		session("respuestas")=respuesta
		Server.Execute path_virtual_preguntas & "/" & trim(pregunta_ejercicio("enunciado"))
%>
		<INPUT TYPE="hidden" NAME="respuesta" VALUE="">		
<%
	' *** Enunciado general de las preguntas
	else
  		set fentrada=fso.OpenTextFile(enunciado,1,false)
  		Do While NOT fentrada.AtEndOfStream
			linea=fentrada.readline
			posrandom=instr(linea,"Math.random()")
			if (posrandom>0) then
				linea=left(linea,posrandom-1) & "aleatorio()" & right(linea,len(linea)-posrandom-12)
			end if
			response.write linea & chr(13)
		Loop
  		fentrada.close
  		set fentrada=nothing
		
		' *** Caso particular de las preguntas de código
		if (tipo_pregunta="CO") then
			programa_enunciado=path_virtual_preguntas & "/" & pregunta_ejercicio("id_pregunta") & ".enu"
			programa_solucion=path_real_preguntas & "\" & pregunta_ejercicio("solucion")
%>
			<CENTER>
			<APPLET ID="TPascal" NAME="TPascal" CODE="TPascal.class" CODEBASE="." WIDTH=512 HEIGHT=288 >
			<!--<OBJECT ID="TPascal" WIDTH="512" HEIGHT="288" CLASSID="CLSID:8AD9C840-044E-11d1-B3E9-00805F499D93">
			<PARAM NAME="code" value="TPascal.class">
			<PARAM NAME="codebase" value=".">-->
			<PARAM name="titulo" value="PREGUNTA-<%=idxpreg%>.PAS">
			<PARAM name="programa" value="<%=programa_enunciado%>">
			<PARAM name="solucion" value="<%=programa_solucion%>">
			<PARAM name="proceso" value="<%=session("directorio")%>/privado/alum_actividades_autoeval_codigo.asp">
			<PARAM name="usuario" value="<%=session("usuario")%>">
			<PARAM name="respuesta" value="<%=respuesta%>">
			<!--</OBJECT>-->
			</APPLET>
			</CENTER>
			<INPUT TYPE="hidden" NAME="respuesta" VALUE="">
<%
  		end if
		
		
		if (tipo_pregunta="PR") then
		
			programa_enunciado=path_virtual_preguntas & "/" & pregunta_ejercicio("id_pregunta")
			programa_solucion=path_real_preguntas & "\" & pregunta_ejercicio("solucion")
			
			sql="SELECT COUNT(orden) as num_ficheros FROM preguntas_ficheros WHERE id_pregunta='" & pregunta_ejercicio("id_pregunta") & "' AND id_asignatura='" & session("id_asignat") & "' GROUP BY id_pregunta"
			set contador=conexion.execute(sql)			
			
			'Antes de esto que hacemos aqui abajo, deberiamos contar cuantos ficheros hay en el enunciado y despues hacer una sola consulta
			
			sql="SELECT * FROM preguntas_ficheros WHERE id_pregunta='" & pregunta_ejercicio("id_pregunta") & "' AND id_asignatura='" & session("id_asignat") & "'"
			set datos=conexion.execute(sql)
			if NOT datos.EOF then tipo_lenguaje=datos("id_lenguaje")
			sql="SELECT * FROM lenguajes WHERE id_tipo='" & tipo_lenguaje & "'"
			set lenguaje=conexion.execute(sql)
			if NOT lenguaje.EOF then tokens_lenguaje=lenguaje("tokens")
			
			If tipo_lenguaje = "GC" then 'Division entre C y Java
				' *** Conversión @CX@ ----> Caracteres especiales ***
				especial=chr(13) & chr(10) & "””;'#%&+\"
				respuesta=replace(respuesta,"@CX=1@@CX=2@",vbCrLf)
				respuesta=replace(respuesta,"@CX=2@",vbCrLf)
				respuesta=replace(respuesta,"@CX=tab","")
				respuesta=replace(respuesta,"fichero_","")
				
				for j=1 to Len(especial)
					respuesta=replace(respuesta,"@CX=" & j & "@",mid(especial,j,1))
				next
				respuesta=Left(respuesta,InStrRev(respuesta,"}"))
				'respuesta=replace(respuesta, "@CX=tab", chr(9))'esto no se puede poner porque cuando le pasas al applet un chr(9) no entiende lo que es y no pone nada asi que lo mejor es dejar "@CX=tab"y en el applet se cambia por "\t"
				set fso = CreateObject("Scripting.FileSystemObject")
				redim nombre_fichero(cint(contador("num_ficheros"))-1)
				sesion=Session.SessionID
				
				'Interfaz en Javascript y HTML para la realización de ejercicios en C
				%>
					<link rel="stylesheet" href="css/ventana_resultado_editor_codemirror.css">
					<link rel="stylesheet" href="codemirror/lib/codemirror.css">
					<link rel="stylesheet" href="javascripts_editor_c/jquery-ui-1.11.4.custom/jquery-ui.css">
					<script src="codemirror/lib/codemirror.js"></script>
					<script src="codemirror/mode/clike/clike.js"></script>
					<script src="codemirror/addon/edit/matchbrackets.js"></script>
					<script src="javascripts_editor_c/jquery_1.10.2.js"></script>
					<script src="javascripts_editor_c/jquery-ui-1.11.4.custom/jquery-ui.js"></script>
					<script src="javascripts_editor_c/editor.js"></script>
					<script src="javascripts_editor_c/ventana_resultado_accion.js"></script>
					
					
				<div id="interfaz_editor">
					
					<table >
						<tr>
						 <form method="post" action="">
									
							<td>
							   <input type="hidden" id="n_preg" VALUE="<%=pregunta_ejercicio("id_pregunta")%>"/>
							   <input class="accion" id="accion_compilar" type="button" name="accion" value="Compilar" onclick="procesar(this.value)"/>
							   <input class="accion" id="accion_ejecutar" type="button" name="accion" value="Ejecutar" onclick="procesar(this.value)"/>
							   <input type="button" value = "Ayuda" onclick='$("#acerca").dialog( "open" )'/>
							   <input type="hidden" id="respuesta_trozo" name="respuesta_trozo">
							   <input type="hidden" id="respuesta" name="respuesta">
							</td>
						</form>
						</tr>
						<tr>
						
							<td>
								<textarea class="CodeMirror" id="editor" cols="50" rows="5"><%
						If respuesta = "" OR Len(respuesta)<10 then  'Si no hay ninguna respuesta abro el archivo con el enunciado lo voy copiando en el editor
							If fso.FileExists(path_real_preguntas & "\" & pregunta_ejercicio("id_pregunta")&"_0.enu") Then
								set archivo = fso.OpenTextFile(path_real_preguntas & "\" & pregunta_ejercicio("id_pregunta")&"_0.enu")
								 Do While not archivo.atEndOfStream 
										 lineactual = archivo.readLine 
										 response.write lineactual&vbCrLf 
								 Loop
								archivo.Close
							Else
							response.write "Enunciado no encontrado, Póngase en contacto con su profesor."&vbCrLf
							response.write "Pregunta: "&pregunta_ejercicio("id_pregunta")
							End If
						'Si hay respuesta copio la respuesta en el editor
						Else
							response.write respuesta
						End If
						set archivo = nothing
						%>
								</textarea>
							</td>
						
						</tr>
						</table>
						<table id="posicion">
						<tr>
						
							<td>Ln:</td>
							<td id="linea">- </td>
							<td>Ch:</td>
							<td id="char">- </td>
						
						</tr>
						
						

					</table>
					<p style="text-align:right;font-size:10px"> Esta aplicaci&oacute;n emplea Codemirror para su funcionamiento (Ver Ayuda).
					<br />
					Copyright (C) 2016 by Marijn Haverbeke <marijnh@gmail.com> and others
					</p>

				</div>
				<div id="dialogo" class="dialogo">
				</div>
				<div id="acerca" class="dialogo" title="Ayuda">
				<b>Compilador Virtual</b><br /><br />
				(Unidad Docente Informatica Industrial/ETSI Industriales/UPM)<br />
				Rellena los fragmentos de codigo que le falta al programa entre las lineas "//##codigo usuario##".<br />
				Puedes pulsar sobre la opcion 'Compilar' para comprobar la sintaxis.<br />
				Se mostraran como maximo 5 errores.<br />
				Puedes pulsar sobre la opcion 'Ejecutar' para verificar que cumple la funcionalidad requerida.<br />
				No incluya funciones tales como printf, scanf o system. No podra mandar su respuesta a comprobar<br /><br/>
				<a href="https://codemirror.net/LICENSE" target="_blank">Licencia de Codemirror</a>
				</div>
				<%
			Else
				' *** Conversión @CX@ ----> Caracteres especiales ***
				especial=chr(13) & chr(10) & "””;'#%&+\"
				respuesta=replace(respuesta,"@CX=1@@CX=2@","¶")
				respuesta=replace(respuesta,"@CX=2@","¶")
				for j=1 to Len(especial)
					respuesta=replace(respuesta,"@CX=" & j & "@",mid(especial,j,1))
				next
				'respuesta=replace(respuesta, "@CX=tab", chr(9))'esto no se puede poner porque cuando le pasas al applet un chr(9) no entiende lo que es y no pone nada asi que lo mejor es dejar "@CX=tab"y en el applet se cambia por "\t"
			
			
	'		if Len(respuesta)< 10 then respuesta = ""
			'Response.write "Respuesta lolo: " & respuesta			
				'respuesta = "fichero_0=asdfasdf                           dfazxcvzxcv            sdf"
				'if respuesta = "" then Response.write "estra vacia"
				redim nombre_fichero(cint(contador("num_ficheros"))-1)
				sesion=Session.SessionID
	%> 
				<CENTER>
				
				

	<!--			<OBJECT ID="JApplet" width=750 height=400 CLASSID="CLSID:8AD9C840-044E-11d1-B3E9-00805F499D93">	-->
					<APPLET NAME="AProg" code="JApplet.class" archive="JApplet.jar" CODEBASE="." WIDTH=750 HEIGHT=400 >
					
					<PARAM NAME="titulo" VALUE="PREGUNTA - <%=pregunta_ejercicio("id_pregunta")%>">
					<PARAM NAME="tokens_lenguaje" VALUE="<%=tokens_lenguaje%>">
					<PARAM NAME="num_ficheros" VALUE="<%=contador("num_ficheros")%>"> <!--Hay que hacer una consulta a la base de datos-->

	<%				
					for i=0 to (contador("num_ficheros")-1) 'aqui hay que poner el numero de ficheros-1
						SELECT CASE tipo_lenguaje
							CASE "JA": extension=".java"
							CASE "GC": extension=".c"
						END SELECT
						sql2="SELECT * FROM preguntas_ficheros WHERE id_pregunta='" & pregunta_ejercicio("id_pregunta") & "' AND id_asignatura='" & session("id_asignat") & "'" & "AND orden='" & i & "'"
						set nombre_arch=conexion.execute(sql2)
						if extension=".java" then 
						nombre_fichero(i)=nombre_arch("nombre_compilacion")
						elseif(cint(numpreg)>9) then
							nombre_fichero(i)=cstr(i)&numpreg&CStr(Second(Now()))&right(sesion,3)&extension
						else
							nombre_fichero(i)=cstr(i)&numpreg&CStr(Second(Now()))&right(sesion,4)&extension
						end if
	%>
						<PARAM NAME="codigo_a_rellenar_<%=i%>" VALUE="<%=path_virtual_preguntas & "/" & datos("enunciado")%>">
						<PARAM NAME="nombre_fichero_<%=i%>" VALUE="<%=nombre_fichero(i)%>">
						<PARAM NAME="nombre_solucion_<%=i%>" VALUE="<%=path_virtual_preguntas & "/" & datos("solucion")%>">
						<PARAM NAME="nombre_titulo_<%=i%>" VALUE="<%=datos("nombre_compilacion")%>">

		<%
						datos.movenext
					next
					nombre3=cstr(right(sesion,3))
					SELECT CASE tipo_lenguaje%>
						<%CASE "JA":%><PARAM name="proceso" value="<%=session("directorio")%>/privado/correccion_ejercicio_tipo_pr_java.asp?nombre3=<%=nombre3%>">
						<%CASE "GC":%><PARAM name="proceso" value="<%=session("directorio")%>/privado/correccion_ejercicio_tipo_pr_gc.asp?nombre3=<%=nombre3%>">
					<%END SELECT%>
					<PARAM name="usuario" value="<%=session("usuario")%>">
					<PARAM name="respuesta" value="<%=respuesta%>">

					</APPLET>	
	<!--			</OBJECT>	-->
				</CENTER>
				<INPUT TYPE="hidden" NAME="respuesta" VALUE="">
				
		<%			
%>

<%			end If
		end if
	end if
	
' ***************************************
'BORRO POSIBLES RESIDUOS
Set objFolder = fso.GetFolder(path_temporal)
for Each objFile in objFolder.files
	nombreArchivo= split(objFile.Name,".")
	if  ((nombre3=right(nombreArchivo(0),3)) AND ((lcase(nombreArchivo(1))="c") OR (lcase(nombreArchivo(1))="exe")))then
		objFile.Delete
	end if
next
%>
<HR WIDTH="100%" SIZE="1" COLOR="#c0c0c0" NOSHADE>
<TABLE WIDTH="100%" BORDER="0" CELLPADDING="0" CELLSPACING="0">
<TR>
<TD ID="t0" ALIGN="left"><% if (respuesta="")  then response.write "<font color=#ff0000><b>Pregunta sin contestar</b></font>" else response.write "<font color=#008000>Pregunta contestada</font>"%> - Te quedan <%=faltan%> preguntas por responder.</TD>
<TD ID="t0" ALIGN="right">
<%	if (tipo_pregunta="CO") then%>
		<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Responder" TITLE="Responder a esta pregunta" ONCLICK="javascript:ResponderCodigo();">&nbsp;<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Anular" TITLE="Anular la respuesta a esta pregunta" ONCLICK="javascript:AnularCodigo();">
<%	elseif (tipo_pregunta="PR") then%>
	<%If tipo_lenguaje="GC" Then%>
		<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Responder" TITLE="Responder a esta pregunta" ONCLICK="javascript:ResponderPRGC();">&nbsp;<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Anular" TITLE="Anular la respuesta a esta pregunta" ONCLICK="javascript:AnularPRGC();">
	<%Else%>
		<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Responder" TITLE="Responder a esta pregunta" ONCLICK="javascript:ResponderPR();">&nbsp;<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Anular" TITLE="Anular la respuesta a esta pregunta" ONCLICK="javascript:AnularPR();">
<%	End If

	elseif (tipo_pregunta="VR") or (tipo_pregunta="VV") then%>
		<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Responder" TITLE="Responder a esta pregunta" ONCLICK="javascript:GuardarRespuestaVR(<%=session("num_cuestiones")%>);">&nbsp;<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Anular" TITLE="Anular la respuesta a esta pregunta" ONCLICK="javascript:document.pregunta.accion.value='Anular';">
<%	elseif (tipo_pregunta="MM") then%>
		<INPUT TYPE="hidden" NAME="respuesta" VALUE="">
		<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Responder" TITLE="Responder a esta pregunta" ONCLICK="javascript:ResponderMM();">&nbsp;<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Anular" TITLE="Anular la respuesta a esta pregunta" ONCLICK="javascript:document.pregunta.accion.value='Anular';">
<%	elseif (tipo_pregunta="MS") then%>
		<INPUT TYPE="hidden" NAME="respuesta" VALUE="">
		<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Responder" TITLE="Responder a esta pregunta" ONCLICK="javascript:ResponderMS();">&nbsp;<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Anular" TITLE="Anular la respuesta a esta pregunta" ONCLICK="javascript:document.pregunta.accion.value='Anular';">
<%	else%>
		<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Responder" TITLE="Responder a esta pregunta" ONCLICK="javascript:ResponderVA();">&nbsp;<INPUT ID="t0" NAME="boton" TYPE="submit" VALUE="Anular" TITLE="Anular la respuesta a esta pregunta" ONCLICK="javascript:document.pregunta.accion.value='Anular';">
<%	end if%>
</TD>
</TR></TABLE>
<SCRIPT LANGUAGE="JavaScript">
<!--
  cierra_recuadro("#f8f8f8",true);
// -->
</SCRIPT>
<%end if%>
<SPAN ID="t0">
<TABLE WIDTH="100%" BORDER="0" CELLPADDING="0" CELLSPACING="0">
<TR>
<TD COLSPAN="2"><IMG SRC="../images/pixel.gif" WIDTH="2" HEIGHT="2" BORDER="0"></TD>
</TR>
<TR><TD ID="t0" ALIGN="left" VALIGN="top">
<SCRIPT LANGUAGE="JavaScript">
<!--
/* Botones de navegación */
for (i=0;i<parent.control.numpreg;i++) {
  if (parent.control.respuestas[i]!='') {
    document.write('<input type="button" title="Ir a la pregunta '+(i+1)+'" id="sc" onclick="javascript:parent.control.mueve_cursor('+i+')" value=" '+(i+1)+' "> ');
  } else {
    document.write('<input type="button" title="Ir a la pregunta '+(i+1)+'" id="nc" onclick="javascript:parent.control.mueve_cursor('+i+')" value=" '+(i+1)+' "> ');
  }
}
//-->
</SCRIPT></TD>
<TD ID="t0" ALIGN="right" VALIGN="top">
<%if (session("tipo")<>0) and (session("seguridad")<2) then %>
	<INPUT ID="t0" NAME="boton" TITLE="Imprimir una copia del ejercicio." TYPE="button" VALUE="Imprimir" ONCLICK="javascript:return imprimirEjercicio();">
	<INPUT ID="t0" NAME="boton" TITLE="Guardar el ejercicio para continuarlo en otro momento." TYPE="button" VALUE="Guardar" ONCLICK="javascript:return guardar();">
<%end if%>
<INPUT ID="t0" NAME="boton" STYLE="font-weight:bold;" TITLE="Finalizar y corregir el presente ejercicio." TYPE="button" VALUE="Finalizar" ONCLICK="javascript:return finalizar();">
<IMG SRC="../images/pixel.gif" WIDTH="6" HEIGHT="4" BORDER="0">
</TD>
</TR></TABLE>
</SPAN>
</FORM>
<%
' *** MARCADO DE LAS RESPUESTAS ALMACENADAS ***
if (respuesta<>"") then
	clave=split(respuesta,",")
	maxclave=ubound(clave)
	clave(0)=trim(lcase(clave(0)))
	For i=1 to maxclave
  		clave(i)=trim(lcase(clave(i)))
	Next
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
<%	if (tipo_pregunta<>"CO") then%>

    /* Marcado de las respuestas */
  document.pregunta.respuesta.value="<%=respuesta%>";
  for (i=0;i<document.pregunta.respuesta.length;i++) {
<%		For i=0 to maxclave%>
    if (document.pregunta.respuesta[i].value=="<%=clave(i)%>") document.pregunta.respuesta[i].checked=true;
<% 		Next%>
  }
<%	end if%>
//-->
</SCRIPT>


<%
end if
conexion.Close
set conexion=nothing
%>

<BR>
</CENTER>
</TD>
</TR>
</TABLE>
</CENTER>
<SCRIPT LANGUAGE="javascript">
<!--
  parent.parent.inferior.document.estado.src="../images/est-normal.gif";
// -->
</SCRIPT>
</BODY>
</HTML>
