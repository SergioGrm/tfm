function generar_enlaces(){
	function botones_corregir(){
		$(".btn-corregir").each(function(btn){
			$(this).click(function(){
				corregir(btn)
				});
		});
		};
	function enlaces_pregunta(){
		for (var i=1; i<=$(".panel").length;i++){
			$("#index_body").append("<tr><td><a href='#c"+i+"'>Cuestion "+i+"</a></td><td class='resultado'>Sin hacer</td></tr>");
			}
		};
	
	botones_corregir();
	enlaces_pregunta();
}
