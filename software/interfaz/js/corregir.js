function corregir(cuestion){
	var respuesta="";
	for (var i=zona_editable[cuestion][0]+1;i<editor[cuestion].lineCount()-zona_editable[cuestion][1];i++){
		respuesta+=editor[cuestion].getLine(i)+"\n";
	}
	pregunta=$(".CodeMirror")[cuestion*2].attributes["data-pregunta"].value;//El *2 es importante ya que codemirror genera un div class codemirror
	$.ajax({ //Peticion ajax para no recargar la pagina, mando respuesta, la accion,linea inicio zona editable y
		url: '../do_distrib_correct_new.php',
		data:'respuesta='+respuesta+'&pregunta='+pregunta,
		method: 'POST', 
		dataType: 'text',
		timeout:30000, //Si pasan 30 segundos se cancela peticion
		success: function(resultado,estado,peticion){//Peticion correcta
			if(resultado.search(" CORRECTO")>0){
				$(".resultado")[cuestion].innerHTML="Correcta";
				$(".resultado")[cuestion].className="resultado success";
				editor[cuestion].options.readOnly=true;
				$(".btn-corregir")[cuestion].disabled=true;
			}else{
				$(".resultado")[cuestion].innerHTML="Incorrecta";
				$(".resultado")[cuestion].className="resultado danger";
			}
			alert(resultado);
			
			
			},
		error: function(respuesta,estado,error){//Error en la peticion, no activo botones
			alert("Fallo");
					
		}
	});
}

function corregir_todo(){
	var n_preguntas=$(".resultado").length
	for(var i=0; i<n_preguntas;i++){
		if($(".resultado")[i].className !== "resultado success"){
			corregir(i);
		}
	}
}
function fin_examen(){
	corregir_todo();
	$.ajax({ //Peticion ajax para no recargar la pagina, mando respuesta, la accion,linea inicio zona editable y
		url: 'fin_examen.php',
		data:'respuesta='+1,
		method: 'POST', 
		dataType: 'text',
		timeout:30000, //Si pasan 30 segundos se cancela peticion
		success: function(resultado,estado,peticion){//Peticion correcta
			alert("fin");
			window.location.replace("../index.php");
			},
		error: function(respuesta,estado,error){//Error en la peticion, no activo botones
			alert("Fallo");
					
		}
	});
	} 
