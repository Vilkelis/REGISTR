//===========ГЛОБАЛЬНЫЕ ДЕЙСТВИЯ ПРИЛОЖЕНИЯ==============================

window.onbeforeunload=deleteAllCookies;

var saveViewFunction = undefined;

//Переход на страницу hospitals.index по link
function gotolink_hospitals_index()
{
  //Если удалось сохранить текущую страницу, то переходим
  if(saveViewFunction != undefined)
  {
    saveViewFunction(goto_hospitals_index);
  }
  else
  {
    goto_hospitals_index();
  }
}

//Непосредственный переход на страницу hospitals.index
function  goto_hospitals_index()
{
  goto_url("hospitals");
}

function gotolink_users_index()
{
  //Если удалось сохранить текущую страницу, то переходим
  if(saveViewFunction != undefined)
  {
    saveViewFunction(goto_users_index);
  }
  else
  {
    goto_users_index();
  }
}

function  goto_users_index()
{
  goto_url("users");
}


function gotolink_signin()
{
  //Если удалось сохранить текущую страницу, то переходим
  if(saveViewFunction != undefined)
  {
    saveViewFunction(goto_signin);
  }
  else
  {
    goto_signin();
  }

}

function goto_signin()
{
  goto_url("signin");
}

function gotolink_changeMyPassword()
{
  goto_url("change_my_password");
}

function gotolink_signout()
{
  //Если удалось сохранить текущую страницу, то переходим
  if(saveViewFunction != undefined)
  {
    saveViewFunction(goto_signout);
  }
  else
  {
    goto_signout();
  }

}

function goto_signout()
{
  saveViewFunction = undefined; //Уже все сохранили. Стираем глобальную переменную функции сохранения вида
  $.ajax({
    url: 'signout',
    type: "DELETE",
    //data: ({id : gridSelectedRow.id}),
    timeout: 5000,
    success: function(data, textStatus, jqXHR)
    {
      //перенаправить на страницу входа
      showMenu({show:false});
      goto_home();
    },
    error: function(jqXHR, textStatus, errorThrown)
    {
      parseErrAndShow(jqXHR, textStatus, errorThrown);
    }
   });
}

function gotolink_home()
{
  //Если удалось сохранить текущую страницу, то переходим
  if(saveViewFunction != undefined)
  {
    saveViewFunction(goto_home);
  }
  else
  {
    goto_home();
  }

}

function goto_home()
{
  goto_url('/');
}

function gotolink_patients_index()
{
  //Если удалось сохранить текущую страницу, то переходим
  if(saveViewFunction != undefined)
  {
    saveViewFunction(goto_patients_index);
  }
  else
  {
    goto_patients_index();
  }
}

function  goto_patients_index()
{
  goto_url("patients");
}


function gotolink_reports_index()
{
  //Если удалось сохранить текущую страницу, то переходим
  if(saveViewFunction != undefined)
  {
    saveViewFunction(goto_reports_index);
  }
  else
  {
    goto_reports_index();
  }

}

function goto_reports_index()
{
   goto_url("reports");
}

//ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

function gotolink_url(url_path)
{
  //Если удалось сохранить текущую страницу, то переходим
  if(saveViewFunction != undefined)
  {
    saveViewFunction(function(){goto_url(url_path)});
  }
  else
  {
    goto_url(url_path);
  }
}

//Просто переход по указанному пути через AJAX (метод GET)
function goto_url(url_path)
{
  saveViewFunction = undefined; //Уже все сохранили. Стираем глобальную переменную функции сохранения вида
  $.ajax({
    url: url_path,
    type: "GET",
    //data: ({id : gridSelectedRow.id}),
    timeout: 5000,
    success: function(data, textStatus, jqXHR)
    {

    },
    error: function(jqXHR, textStatus, errorThrown)
    {
      parseErrAndShow(jqXHR, textStatus, errorThrown);
    }
   });
}

function showMenu(params)
{
  if((params != undefined) && (params.show == true))
  {

     var menu = ' <li class="divider-vertical"></li>'+
                '<li><a href="#" onclick="gotolink_patients_index();">Регистр</a></li> ';




     if((params.show_reports != undefined) && (params.show_reports == true))
     {
        menu = menu + '<li id="reports_menu"><a href="#" onclick="gotolink_reports_index();">Отчеты</a></li>';
     }
     menu = menu + '<li class="divider-vertical"></li>'
      if((params.show_admin != undefined) && (params.show_admin == true))
      {
         menu = menu + '<li class="dropdown" ><a class="dropdown-toggle" data-toggle="dropdown" href="#">Администрирование<b class="caret"></b></a> '+
                 ' <ul id="menu1" class="dropdown-menu"> ' +
                 ' <li><a hreg="#" onclick="gotolink_users_index();">Пользователи</a></li> '+
                 ' <li class="divider"></li> '+
                 ' <li><a href="#" onclick="gotolink_hospitals_index();">Список ЛПУ</a></li> '+
                 ' </ul> '+
                 ' </li> '+
                 ' <li class="divider-vertical"></li> ';
      }



     if(params.username != undefined)
     {
       $('#menu_username').text(params.username);
     }
     else
     {
       $('#menu_username').text('Неизвестный');
     }
     $('#main_menu').html(menu);
     $('#signed_menu').removeAttr("hidden");
  }
  else
  {
     $('#signed_menu').attr("hidden","true");

  }



}


function imtCalc(w_input,h_input,imt_val,imt_cond_val)
{
    $.ajax({
     url: 'imt',
     type: "GET",
     data: ({weight: $('#'+w_input).val(), height: $('#'+h_input).val()}),
     timeout: 5000,
     success: function(data, textStatus, jqXHR)
     {
        $('#'+imt_val).text(data[0].imt);
        $('#'+imt_cond_val).text(data[0].imt_cond);
     },
     error: function(jqXHR, textStatus, errorThrown)
     {
       parseErrAndShow(jqXHR, textStatus, errorThrown);
     }
    });
}


function ageCalc(birth_date,element)
{
   $.ajax({
    url: 'age',
    type: "GET",
    data: ({birth_date : birth_date}),
    timeout: 5000,
    success: function(data, textStatus, jqXHR)
    {
       $('#'+element).text(data[0].age)
    },
    error: function(jqXHR, textStatus, errorThrown)
    {
      parseErrAndShow(jqXHR, textStatus, errorThrown);
    }
   });
}

function deleteAllCookies() {
    var cookies = document.cookie.split(";");

    for (var i = 0; i < cookies.length; i++) {
        var cookie = cookies[i];
        var eqPos = cookie.indexOf("=");
        var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
        document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
}