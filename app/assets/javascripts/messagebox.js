//Вызов окна сообщений
/*
  ПРИМЕР:
  function clickMsg(btnNum)
  {
    alert(btnNum);
  }

   function myMessage()
   {
     var buttons =  [{btncaption:"OK", iconclass:"icon-remove", btnclass:"btn-primary"}, {btnclass:"space"}, {btncaption:"Отмена",iconclass:"icon-remove"}];
     MessageBox('Привет!',buttons,'Сообщение','clickMsg');
   }

  HTML РАЗМЕТКА
    <!-- Окно диалога  -->
	<div class="modal" id="messagebox" style="display: none">
	<div class="modal-body" >
	   <button class="close" id="messageboxbtnclose">×</button>
	   <font size="3">
	     <div id="messageboxbody">
	     </div>
	   </font>
	 </div>
	 <div class="modal-footer" id="messageboxfooter">
	  </div>
	</div>


 */

//Вызов окна
function MessageBox(message,buttons,onClick)
{
	  $('#messageboxbody').html(message);
	  $('#messageboxbtnclose').attr("onClick",'MessageBoxClose("'+onClick+'",-1);'); //Кнопка закрытия окна идет под индексом -1

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
		   s = s + ' <a href="#"  onClick="MessageBoxClose(\''+onClick+'\','+j+');" class="btn';
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
	  $("#messageboxfooter").html(s);

      $('#messagebox').modal({show:true, keyboard:true, backdrop:true});
}

//При закрытии окна
function MessageBoxClose(onClick,btnnum)
{
      $('#messagebox').modal('hide');
     eval(onClick+'('+btnnum+')');

}

//Вспомогательные функции
function YesNoDlg(message,onClick)
{
 var buttons =  [{btncaption:"Да", btnclass:"btn-primary"},
                 {btncaption:"Нет"}];
     MessageBox(message,buttons,onClick);
}

function OkDlg(message)
{
    var buttons =  [{btncaption:"OK", btnclass:"btn-primary"}
                    ];
    MessageBox(message,buttons,"");


}

function ErrDlg(message)
{
    var buttons =  [{btncaption:"OK", btnclass:"btn-primary"}
                    ];
    MessageBox('Ошибка: ' + message,buttons,"");


}