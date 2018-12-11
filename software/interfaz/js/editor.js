function generar_editores(){
    var i;
    var j;
	
    var textarea=$(".CodeMirror");
    var n_cuestiones= textarea.length;
    for (j=0;j<n_cuestiones;j++){
		//Inicializacion de editores de texto con Codemirror
		editor[j]=CodeMirror.fromTextArea(textarea[j], {
			lineNumbers: true, //Muestra los numeros de linea
			matchBrackets: true, //Muestra con que parentesis, llave o corchete corresponde el que tenemos al lado del cursorsor
			mode: "text/x-csrc", //Modo Lenguaje C
			indentUnit:1, //La longitud de la autotabulacion
			smartIndent:false //Evita que añada tabulaciones automaticamente al saltar de linea, pero si mantiene las que haya
		});
		editor[j]["cuestion"]=j; //añado n pregunta
		zona_editable[j]=[-1,-1];
		//Buscamos las lineas //##codigo usuario## para dar valor al vector zona_editable
		for(i = 0; i < editor[j].lineCount(); i++){
			linea=editor[j].getLine(i);
			if(linea.search("//##codigo usuario##")!=-1){
				//editor.markText({line:-1}, {line:i}, {readOnly:true});
				if(zona_editable[j][0]==-1){
					zona_editable[j][0] = i;
				}else if (zona_editable[j][1] = -1){
					zona_editable[j][1] =editor[j].lineCount()- i;
				}else {         
					alert("Ha habido un problema, informe a su profesor");
				}
			 }
		}
		//Configuracion e inicicion del evento beforeChange que evitara que se borren cosas de las zonas fuera de //##codigo usuario##
		editor[j].on("beforeChange",function(cm,change) {
			var k=cm["cuestion"];
            inicio_cambio=change.from.line;
            final_cambio=change.to.line;
			if ( inicio_cambio<=zona_editable[k][0] || (editor[k].lineCount()-inicio_cambio)<=zona_editable[k][1] || (editor[k].lineCount()-final_cambio)<=zona_editable[k][1]) {
				change.cancel();
            }
		});
	}
}
