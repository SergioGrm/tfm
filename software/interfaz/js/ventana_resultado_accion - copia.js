function detectmob() { //Funcion para detectar si se usa dispositivo movil
 if( navigator.userAgent.match(/Android/i)
 || navigator.userAgent.match(/webOS/i)
 || navigator.userAgent.match(/iPhone/i)
 || navigator.userAgent.match(/iPad/i)
 || navigator.userAgent.match(/iPod/i)
 || navigator.userAgent.match(/BlackBerry/i)
 || navigator.userAgent.match(/Windows Phone/i)
 ){
    return true;
  }
 else {
    return false;
  }
}

$(function() { //Al cargarse el documento iniciamos las cajas modales que nos da Jquery UI
    $( "#dialogo" ).dialog({//Este contendra los resultados de la compilacion y ejecucion
	  autoOpen: false,
      resizable: false,
      draggable: false,
      modal: true, //No permitira hacer click si no se da a aceptar (compo un alert)
      width: 325,
      buttons: {
        "Aceptar": function() {
          $( this ).dialog( "close" ); // El boton aceptar cerrara la caja modal
        },
      }
    });
	 $( "#acerca" ).dialog({ //Esta caja contendra las instrucciones y ayuda para los alumnos
	  autoOpen: false,
      resizable: false,
      draggable: false,
      modal: true,
      width: 650,
      buttons: {
        "Aceptar": function() {
          $( this ).dialog( "close" );
        },
      }
    });
  });

function busca_fin(){ // Funcion para buscar la linea donde esta la llave que cierra la funcion que hay que completar
	var i;
	var fin_linea=0;
	llaves=0;// El numero de llaves abiertas hasta el momento
	var buscar_fin=false; //Hasta que no se encuentre la zona editable no se empezara a buscar cierre de llaves
	for(i=0;i<editor.lineCount();i++){ //Se hace asi porque a veces la ultima linea no es la que contiene la llave ya que hay varias funciones
		if(i==zona_editable[0]){ //Si llego al comoienzo de la zona editable paso al final y ya empiezo la busqueda del cierre
		buscar_fin=true;
		i=editor.lineCount()-zona_editable[1]+1;
		}
		linea=editor.getLine(i);
		if((linea.search("{")!=-1)){
		llaves++;
		}
		if((linea.search("}")!=-1)){
		llaves--;
		}
		if(llaves==0 && buscar_fin){
			fin_linea=i+1;
			break;
		}
	}
	
	return fin_linea; //retorno de la linea con la llave
}


function procesar(orden){ //Funcion a la que llamara el evento onclick de los botones Compilar y Ejecutar
	$("#accion_compilar").attr("disabled","disabled");//desactivo los botones 
	$("#accion_ejecutar").attr("disabled","disabled");
	copiar(); //recupera y copia la zona editable en textarea respuesta_trozo, Codigo en el documento editor.js
	 var respuesta=$("#respuesta_trozo").val(); // cojo el valor de respuesta_trozo
	 if((respuesta.indexOf("scanf")!=-1) || (respuesta.indexOf("printf")!=-1) || (respuesta.indexOf("system")!=-1)){ //Primera barrera de seguridad para estas funciones
		 $( "#dialogo" ).empty();
		 $( "#dialogo" ).append("Funciones no permitidas en su respuesta");
		 $( "#dialogo" ).dialog({title: "Atenci\u00f3n"});
		 $( "#dialogo" ).dialog( "open" );
		 $("#accion_compilar").removeAttr("disabled");//Activo botones
		 $("#accion_ejecutar").removeAttr("disabled");
		 }else if((respuesta.indexOf("#")!=-1) || (respuesta.indexOf("\\")!=-1)){ //Primera barrera para evitar directivas
			 $( "#dialogo" ).empty();
			 $( "#dialogo" ).append("No incluya directivas");
			 $( "#dialogo" ).dialog({title: "Atenci\u00f3n"});
			 $( "#dialogo" ).dialog( "open" );
			 $("#accion_compilar").removeAttr("disabled");
			 $("#accion_ejecutar").removeAttr("disabled");
			 }else{
	if(orden=="Ejecutar"){ //Si se cumplen los requisitos para mandar a comprobar 
		encabezado="Resultado ejecuci\u00f3n\n";
		} else if(orden=="Compilar"){
		encabezado="Resultado compilaci\u00f3n\n";
		}else{
			$( "#dialogo" ).empty();
			$( "#dialogo" ).append("Orden mal recibida");
			$( "#dialogo" ).dialog({title: "Atenci\u00f3nn"});
			$( "#dialogo" ).dialog( "open" );
			$("#accion_compilar").removeAttr("disabled");
			$("#accion_ejecutar").removeAttr("disabled");
			return;
			}
	linea_final=busca_fin(); //Busqueda linea ultima llave cerrada
	respuesta=encodeURIComponent(respuesta); //Codifico caracteres para no tener problema al pasarlos por post
			$( "#dialogo" ).empty();
			$( "#dialogo" ).append("Procesando su petici&oacute;n. Por favor, espere la respuesta");
			$( "#dialogo" ).dialog({title: encabezado});
			$( "#dialogo" ).dialog( "open" );
	$.ajax({ //Peticion ajax para no recargar la pagina, mando respuesta, la accion,linea inicio zona editable y la ultima linea con }
		
		url: 'correccion_preguntas_pr_gc_nuevo.asp',
		data:'L_I_real='+ zona_editable[0]+'&respuesta='+respuesta+'&accion='+orden+'&n_preg='+document.getElementById("n_preg").value+"&n_lineas="+linea_final,
		method: 'POST', 
		dataType: 'html',
		timeout:30000, //Si pasan 30 segundos se cancela peticion
		success: function(resultado,estado,peticion){//Peticion correcta
			$( "#dialogo" ).dialog( "close" );
			$( "#dialogo" ).empty();
			$( "#dialogo" ).append(resultado);
			$( "#dialogo" ).dialog({title: encabezado});
			$( "#dialogo" ).dialog( "open" );
			$("#accion_compilar").removeAttr("disabled");
			$("#accion_ejecutar").removeAttr("disabled");
			},
		error: function(respuesta,estado,error){//Error en la peticion, no activo botones
			$( "#dialogo" ).dialog( "close" );
			$( "#dialogo" ).empty();
			$( "#dialogo" ).append("Error al procesar la pregunta, pongase en contacto con su profesor");
			$( "#dialogo" ).dialog({title: encabezado});
			$( "#dialogo" ).dialog( "open" );
					
			
		}
	});

}
	
}
$( document ).ready(function() {
	if(detectmob()){//Si se usa un movil o tablet desactivara los botones y no se podra escribbir en el editor
		$("#accion_compilar").attr("disabled","disabled");//desactivo los botones 
		$("#accion_ejecutar").attr("disabled","disabled");
		editor.setOption("readOnly","nocursor");//editor es la variable global que controla el editor de texto declarada en editor.js
		alert("Se detect\u00f3 que est\u00e1 usando un navegador de un dispositivo m\u00f3vil. Solamente podr\u00e1 editar texto y comprobar sus respuestas si activa la vista como ordenador en los ajustes del dispositivo.")
	}
	});
