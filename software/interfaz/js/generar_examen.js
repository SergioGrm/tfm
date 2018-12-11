var zona_editable =[];    //vector global que contendra el nº linea del comienzo de la seccion editable y el final (contando desde el final)
var editor = []; //Variable que controlará el editor de texto
var linea;
function setAffixContainerSize(){
        $('.sidebar').width($('.sidebar').parent().innerWidth()-10);
    }

    $(window).resize(function(){
        setAffixContainerSize();
    });

$( document ).ready(function() {  //Cuando se cargue la pagina se ejecutara
    generar_editores();
    generar_enlaces();
    setAffixContainerSize()
   // generar_enlaces();
   
     $('.sidebar').affix({
        offset: {
            top: 0
        }
    }).on('affix.bs.affix',function(){
        setAffixContainerSize();
    });
    //localStorage.setItem("cuestion1","dsfdsfsfdsf");
    setTimeout(function(){fin_examen()}, 30000);
});
  
