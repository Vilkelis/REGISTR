

/*
<div class="modal" id="alertbox" style="display: none">
  <div class="alert alert-block alert-error fade in" id="alertbody" style="margin-bottom: 0px;">
    <button class="close" id="alertbtnclose">×</button>
    <div id="alertmessage">
      <!--h4 id="alerttitle" class="alert-heading"></h4>
      <p>Измените данные в полях ввода и попробуйте отправить форму повторно. Яркие, как день, лучи гнали перед собою гнилые туманы. Разорванные, взлохмаченные туманы метались и приникали к земле.</p-->
    </div>
    <p>
    <div id="alertfooter">
        <!--a class="btn btn-danger" href="#">Отменить</a> <a class="btn" href="#">Повторить</a-->
    </div>
  </div>
</div>

*/

var alertBoxCloseFunction; //Функция, выполняемая при закрытии окна AlertBox

//Вызов окна
// alertclass = info , error, warning
function AlertBox(message, title, alertclass, buttons, onClick)
{
      alertBoxCloseFunction = onClick;

      var alCl = "alert alert-block ";
      if(title != undefined && title != "")
      {
          message = '<h4 class="alert-title">'+title+'</h4><p>'+ message+'</p>';
      }
      else
      {
        message = '<p>'+message+'</p>';
      }

      if( (alertclass == undefined) || (alertclass == "") )
      {
         alertclass = "info"
      }

     if(alertclass == "info")
     {
       $('#alertbody').attr("class",alCl+"alert-info");  //Синий
     }
     else
     {
     if(alertclass == "error")
     {
       $('#alertbody').attr("class",alCl+"alert-error");    //Красный
     }
     else {
     if(alertclass == "warning")
     {
        $('#alertbody').attr("class",alCl+"alert-warning");  //Желтый
     }
     else{
        if(alertclass=="ok")
        {
         $('#alertbody').attr("class",alCl+"alert-success");//Зеленый
        }
        else{
          $('#alertbody').attr("class",alCl+"alert-white");   //Белый
        }
     }
     }
     }

	 $('#alertmessage').html(message);
	 $('#alertbtnclose').attr("onClick",'AlertBoxClose(-1);'); //Кнопка закрытия окна идет под индексом -1

	 var s = ""
	 var j = 0

      for(i=0;i<buttons.length;i++)
      {
	    if(buttons[i].btnclass != undefined && buttons[i].btnclass == "space")
		{
		  s = s +  ' <span class="space"></span>';
		}
		else{
		   j = j + 1 //Номер кнопки (без разделителей)
		   s = s + ' <a href="#"  onClick="AlertBoxClose('+j+');" class="btn';
           if(buttons[i].btnclass != undefined && buttons[i].btnclass!='')
		   {
		    s = s + ' ' + buttons[i].btnclass
		   }
		   s = s + '">';
		   if(buttons[i].iconclass != undefined && buttons[i].iconclass != '')
		   {
		     s = s + '<i class="'+buttons[i].iconclass+'"></i>';
		   }
		   s = s + buttons[i].btncaption + '</a>'
		}
      }
	  $("#alertfooter").html(s);

      $('#alertbox').modal({show:true, keyboard:true, backdrop:true});
}

//При закрытии окна
function AlertBoxClose(btnnum)
{
      $('#alertbox').modal('hide');
      if(alertBoxCloseFunction != undefined)
      {   alertBoxCloseFunction(btnnum); }
      alertBoxCloseFunction = undefined;
}

//Вспомогательные функции
function AlertYesNo(message,onClick)
{
 var buttons = [
     {btncaption:"Да", btnclass:"btn-primary"},
     {btnclass:"space"},
     {btncaption:"Нет"}
    ];
     AlertBox(message,'Вопрос:','white',buttons,onClick);
}

function AlertYesNoCancel(message,onClick)
{
 var buttons = [
     {btncaption:"Да", btnclass:"btn-primary"},
     {btnclass:"space"},
     {btncaption:"Нет", btnclass:"btn-danger"},
     {btnclass:"space"},
      {btnclass:"space"},
     {btncaption:"Отмена"}
    ];
     AlertBox(message,'Вопрос:','white',buttons,onClick);
}

function AlertOk(message,title, alertclass)
{
    var buttons =  [{btncaption:"OK", btnclass:"btn-primary"}
                    ];
    AlertBox(message,title,alertclass,buttons,undefined);


}

function AlertErr(message, title, doOnClose)
{
    var buttons =  [{btncaption:"OK", btnclass:"btn-danger"}
                    ];
    if(title==undefined)
    {
       title = 'Ошибка!';
    }
    AlertBox(message,title,'error',buttons,doOnClose);
}
